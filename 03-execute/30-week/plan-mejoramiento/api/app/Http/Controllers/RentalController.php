<?php
namespace App\Http\Controllers;
use App\Application\RentalUseCase;
use App\Application\ReturnUseCase;
use App\Exceptions\ApiException;
use App\Support\JsonData;
use App\Support\Presenters;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Carbon\CarbonImmutable;
final class RentalController extends BaseController {
    public function store(Request $request,RentalUseCase $service){
        $data=$request->validate(['customer_id'=>'required|uuid','items'=>'required|array|min:1|max:3','items.*.costume_id'=>'required|uuid']);
        $ids=array_map(fn($item)=>$item['costume_id'],$data['items']);
        return response()->json($service->execute($data['customer_id'],$request->attributes->get('operator')->id,$ids),201);
    }
    public function show(string $id){$row=DB::table('rentals')->where('id',$id)->first();if(!$row)throw new ApiException('NOT_FOUND','Alquiler no encontrado.',404);return response()->json(Presenters::rental($row));}
    public function returnItem(string $rental_id,string $item_id,ReturnUseCase $service){return response()->json($service->execute($rental_id,$item_id));}
    public function overdue(){
        $now=CarbonImmutable::now('UTC');
        $rows=DB::table('rental_items')->join('rentals','rentals.id','=','rental_items.rental_id')->join('customers','customers.id','=','rentals.customer_id')->whereNull('rental_items.returned_at')->where('rental_items.due_at','<',$now)->orderBy('rental_items.due_at')->get(['rental_items.*','customers.full_name']);
        return response()->json(['items'=>$rows->map(fn($row)=>['rental_id'=>$row->rental_id,'item_id'=>$row->id,'costume_name'=>$row->costume_name,'customer_name'=>$row->full_name,'due_at'=>JsonData::utc($row->due_at),'days_late'=>max(1,(int)floor(CarbonImmutable::parse($row->due_at)->diffInSeconds($now)/86400))])->all()]);
    }
    public function index(Request $request){
        $data=$request->validate(['from'=>'sometimes|date_format:Y-m-d','to'=>'sometimes|date_format:Y-m-d','customer_id'=>'sometimes|uuid','status'=>'sometimes|in:open,overdue,closed']);
        if(isset($data['from'],$data['to'])&&$data['from']>$data['to'])throw new ApiException('INVALID_DATE_RANGE','El rango de fechas no es válido.',422);
        [$page,$size]=JsonData::pagination($request);
        $query=DB::table('rentals')->orderByDesc('rented_at')->orderBy('id');
        if(!empty($data['from']))$query->whereDate('rented_at','>=',$data['from']);
        if(!empty($data['to']))$query->whereDate('rented_at','<=',$data['to']);
        if(!empty($data['customer_id']))$query->where('customer_id',$data['customer_id']);
        $rows=$query->get()->map(fn($row)=>Presenters::rental($row));
        if(!empty($data['status']))$rows=$rows->filter(fn($row)=>$row['status']===$data['status']);
        $all=array_values($rows->all());
        return response()->json(['items'=>array_slice($all,($page-1)*$size,$size),'page'=>$page,'size'=>$size,'total'=>count($all)]);
    }
}
