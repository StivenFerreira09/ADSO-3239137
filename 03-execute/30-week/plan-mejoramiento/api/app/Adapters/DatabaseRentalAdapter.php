<?php
namespace App\Adapters;

use App\Ports\RentalPort;
use App\Domain\RentalRules;
use App\Exceptions\ApiException;
use App\Support\Presenters;
use App\Support\JsonData;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;
use Carbon\CarbonImmutable;

final class DatabaseRentalAdapter implements RentalPort {
    public function create(string $customerId,string $operatorId,array $costumeIds):array {
        return DB::transaction(function () use($customerId,$operatorId,$costumeIds){
            $customer=DB::table('customers')->where('id',$customerId)->lockForUpdate()->first();
            if(!$customer)throw new ApiException('NOT_FOUND','Cliente no encontrado.',404);

            $now=CarbonImmutable::now('UTC');

            $open=DB::table('rental_items')
                ->join('rentals','rentals.id','=','rental_items.rental_id')
                ->where('rentals.customer_id',$customerId)
                ->whereNull('rental_items.returned_at');

            $count=(clone $open)->count();

            if((clone $open)->where('rental_items.due_at','<',$now)->exists())
                throw new ApiException(
                    'CUSTOMER_HAS_OVERDUE',
                    'El cliente tiene trajes vencidos sin devolver.',
                    409
                );

            if($count+count($costumeIds)>5)
                throw new ApiException(
                    'CUSTOMER_LIMIT_EXCEEDED',
                    'El cliente superaría el límite de 5 trajes.',
                    422,
                    [['field'=>'items','issue'=>'Tiene '.$count.' trajes pendientes.']]
                );

            // Acquire locks in stable order to prevent two operators renting the last unit.
            $costumes=DB::table('costumes')
                ->whereIn('id',$costumeIds)
                ->whereNull('deleted_at')
                ->orderBy('id')
                ->lockForUpdate()
                ->get()
                ->keyBy('id');

            if($costumes->count()!==count($costumeIds))
                throw new ApiException(
                    'NOT_FOUND',
                    'Uno de los trajes no existe.',
                    404
                );

            foreach($costumeIds as $id)
                if($costumes[$id]->available_units<1)
                    throw new ApiException(
                        'COSTUME_NOT_AVAILABLE',
                        'No hay unidades disponibles de «'.$costumes[$id]->name.'».',
                        409
                    );

            $rentalId=(string)Str::uuid();
            $due=$now->addDays(4);

            DB::table('rentals')->insert([
                'id'=>$rentalId,
                'customer_id'=>$customerId,
                'rented_by_operator_id'=>$operatorId,
                'rented_at'=>$now
            ]);

            $cats=DB::table('categories')->pluck('name','id');

            foreach($costumeIds as $id){
                $costume=$costumes[$id];

                DB::table('costumes')
                    ->where('id',$id)
                    ->update([
                        'available_units'=>$costume->available_units-1
                    ]);

                DB::table('rental_items')->insert([
                    'id'=>(string)Str::uuid(),
                    'rental_id'=>$rentalId,
                    'costume_id'=>$id,
                    'costume_name'=>$costume->name,
                    'reference'=>$costume->reference,
                    'category_name'=>$cats[$costume->category_id],
                    'due_at'=>$due,
                    'returned_at'=>null
                ]);
            }

            return Presenters::rental(
                DB::table('rentals')->where('id',$rentalId)->first()
            );
        },3);
    }

    public function returnItem(string $rentalId,string $itemId):array {
        return DB::transaction(function ()use($rentalId,$itemId){
            // A consistent lock order is essential for duplicate return requests.
            $rental=DB::table('rentals')
                ->where('id',$rentalId)
                ->first();

            if(!$rental)
                throw new ApiException(
                    'NOT_FOUND',
                    'Alquiler no encontrado.',
                    404
                );

            $item=DB::table('rental_items')
                ->where('id',$itemId)
                ->where('rental_id',$rentalId)
                ->first();

            if(!$item)
                throw new ApiException(
                    'NOT_FOUND',
                    'Línea no encontrada.',
                    404
                );

            $costume=DB::table('costumes')
                ->where('id',$item->costume_id)
                ->lockForUpdate()
                ->first();

            $item=DB::table('rental_items')
                ->where('id',$itemId)
                ->lockForUpdate()
                ->first();

            if($item->returned_at!==null)
                throw new ApiException(
                    'ITEM_ALREADY_RETURNED',
                    'La línea ya fue devuelta.',
                    409
                );

            if($costume->available_units >= $costume->total_units)
                throw new ApiException(
                    'VALIDATION_ERROR',
                    'Las unidades disponibles no pueden superar el total.',
                    422
                );

            $now=CarbonImmutable::now('UTC');

            DB::table('rental_items')
                ->where('id',$itemId)
                ->update([
                    'returned_at'=>$now
                ]);

            DB::table('costumes')
                ->where('id',$costume->id)
                ->update([
                    'available_units'=>$costume->available_units+1
                ]);

            return [
                'id'=>$item->id,
                'costume_id'=>$item->costume_id,
                'costume_name'=>$item->costume_name,
                'reference'=>$item->reference,
                'category_name'=>$item->category_name,
                'due_at'=>JsonData::utc($item->due_at),
                'returned_at'=>JsonData::utc((string)$now)
            ];
        },3);
    }
}
