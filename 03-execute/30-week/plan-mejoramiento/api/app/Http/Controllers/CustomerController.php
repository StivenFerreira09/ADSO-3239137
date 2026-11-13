<?php
namespace App\Http\Controllers;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;
use Illuminate\Database\QueryException;
use App\Support\JsonData;
use App\Exceptions\ApiException;
final class CustomerController extends BaseController {
    public function index(Request $request){
        $data=$request->validate(['q'=>'sometimes|string|max:200']);
        $q=DB::table('customers');
        if(!empty($data['q'])){$term='%'.$data['q'].'%';$q->where(fn($s)=>$s->where('full_name','ilike',$term)->orWhere('document_number','ilike',$term));}
        return response()->json(JsonData::paged($q->orderBy('full_name')->orderBy('id'),$request,fn($row)=>$row));
    }
    public function show(string $id){
        $row=DB::table('customers')->where('id',$id)->first();if(!$row)throw new ApiException('NOT_FOUND','Cliente no encontrado.',404);
        $active=DB::table('rental_items')->join('rentals','rentals.id','=','rental_items.rental_id')->where('rentals.customer_id',$id)->whereNull('rental_items.returned_at')->count();
        return response()->json(['id'=>$row->id,'full_name'=>$row->full_name,'document_number'=>$row->document_number,'active_rentals'=>$active]);
    }
    public function store(Request $request){
        $d=$request->validate(['full_name'=>'required|string|max:200','document_number'=>'required|string|max:30']);
        $doc=trim($d['document_number']);
        if(DB::table('customers')->where('document_number',$doc)->exists())throw new ApiException('DOCUMENT_TAKEN','El documento ya está registrado.',409);
        $id=(string)Str::uuid();
        try{DB::table('customers')->insert(['id'=>$id,'full_name'=>trim($d['full_name']),'document_number'=>$doc]);}
        catch(QueryException $e){if($e->getCode()==='23505')throw new ApiException('DOCUMENT_TAKEN','El documento ya está registrado.',409);throw $e;}
        return response()->json(['id'=>$id,'full_name'=>trim($d['full_name']),'document_number'=>$doc],201);
    }
}
