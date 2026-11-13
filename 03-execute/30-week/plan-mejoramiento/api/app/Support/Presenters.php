<?php
namespace App\Support;
use Illuminate\Support\Facades\DB;
use App\Domain\RentalRules;
final class Presenters {
    public static function costume($row):array {
        return ['id'=>$row->id,'name'=>$row->name,'designer'=>$row->designer,'reference'=>$row->reference,'category'=>['id'=>$row->category_id,'name'=>$row->category_name],'total_units'=>(int)$row->total_units,'available_units'=>(int)$row->available_units,'cover_key'=>$row->cover_key];
    }
    public static function rental($row):array {
        $items=DB::table('rental_items')->where('rental_id',$row->id)->orderBy('id')->get()->map(fn($i)=>['id'=>$i->id,'costume_id'=>$i->costume_id,'costume_name'=>$i->costume_name,'reference'=>$i->reference,'category_name'=>$i->category_name,'due_at'=>JsonData::utc($i->due_at),'returned_at'=>JsonData::utc($i->returned_at)])->all();
        return ['id'=>$row->id,'customer_id'=>$row->customer_id,'rented_at'=>JsonData::utc($row->rented_at),'status'=>RentalRules::status($items,new \DateTimeImmutable('now',new \DateTimeZone('UTC'))),'items'=>$items];
    }
}
