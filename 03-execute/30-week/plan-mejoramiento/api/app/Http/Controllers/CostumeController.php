<?php
namespace App\Http\Controllers;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Str;
use Illuminate\Database\QueryException;
use App\Support\JsonData;
use App\Support\Presenters;
use App\Exceptions\ApiException;
use App\Domain\CostumeRules;
use App\Domain\Reference;
use InvalidArgumentException;
final class CostumeController extends BaseController {
    private function query() {return DB::table('costumes')->join('categories','categories.id','=','costumes.category_id')->whereNull('costumes.deleted_at')->select('costumes.*','categories.name as category_name');}
    private function find(string $id) { $costume=$this->query()->where('costumes.id',$id)->first(); if(!$costume)throw new ApiException('NOT_FOUND','Traje no encontrado.',404);return $costume;}
    public function categories() {return response()->json(DB::table('categories')->orderBy('name')->get());}
    public function index(Request $request) {
        $data=$request->validate(['q'=>'sometimes|string|max:250','category_id'=>'sometimes|uuid']);
        $q=$this->query();
        if(!empty($data['q'])) {$term='%'.$data['q'].'%';$q->where(fn($s)=>$s->where('costumes.name','ilike',$term)->orWhere('costumes.designer','ilike',$term));}
        if(!empty($data['category_id'])) $q->where('category_id',$data['category_id']);
        return response()->json(JsonData::paged($q->orderBy('costumes.name')->orderBy('costumes.id'),$request,fn($r)=>Presenters::costume($r)));
    }
    public function show(string $id) {return response()->json(Presenters::costume($this->find($id)));}
    public function store(Request $request) {
        $this->admin($request);
        $d=$request->validate(['name'=>'required|string|max:250','designer'=>'required|string|max:200','reference'=>'required|string|max:50','category_id'=>'required|uuid|exists:categories,id','total_units'=>'required|integer|min:1']);
        try {$reference=Reference::normalize($d['reference']);} catch(InvalidArgumentException $e) {throw new ApiException('VALIDATION_ERROR',$e->getMessage(),422);}
        if(DB::table('costumes')->where('reference',$reference)->whereNull('deleted_at')->exists())throw new ApiException('REFERENCE_TAKEN','La referencia ya existe.',409);
        $id=(string)Str::uuid();
        try {DB::table('costumes')->insert(['id'=>$id,'name'=>trim($d['name']),'designer'=>trim($d['designer']),'reference'=>$reference,'category_id'=>$d['category_id'],'total_units'=>$d['total_units'],'available_units'=>$d['total_units'],'cover_key'=>null,'deleted_at'=>null]);}
        catch(QueryException $e){if($e->getCode()==='23505')throw new ApiException('REFERENCE_TAKEN','La referencia ya existe.',409);throw $e;}
        return response()->json(Presenters::costume($this->find($id)),201);
    }
    public function update(Request $request,string $id) {
        $this->admin($request);
        $d=$request->validate(['name'=>'required|string|max:250','designer'=>'required|string|max:200','category_id'=>'required|uuid|exists:categories,id','total_units'=>'required|integer|min:1']);
        DB::transaction(function()use($id,$d){
            $row=DB::table('costumes')->where('id',$id)->whereNull('deleted_at')->lockForUpdate()->first();
            if(!$row)throw new ApiException('NOT_FOUND','Traje no encontrado.',404);
            try{$available=CostumeRules::changeTotal($row->total_units,$row->available_units,$d['total_units']);}catch(InvalidArgumentException $e){throw new ApiException('VALIDATION_ERROR',$e->getMessage(),422);}
            DB::table('costumes')->where('id',$id)->update(['name'=>trim($d['name']),'designer'=>trim($d['designer']),'category_id'=>$d['category_id'],'total_units'=>$d['total_units'],'available_units'=>$available]);
        });
        return response()->json(Presenters::costume($this->find($id)));
    }
    public function destroy(Request $request,string $id) {
        $this->admin($request);
        DB::transaction(function()use($id){
            $row=DB::table('costumes')->where('id',$id)->whereNull('deleted_at')->lockForUpdate()->first();
            if(!$row)throw new ApiException('NOT_FOUND','Traje no encontrado.',404);
            if(DB::table('rental_items')->where('costume_id',$id)->whereNull('returned_at')->exists()) throw new ApiException('COSTUME_HAS_OPEN_RENTALS','No puede retirar un traje con alquileres abiertos.',409);
            DB::table('costumes')->where('id',$id)->update(['deleted_at'=>now('UTC')]);
        });return response()->noContent();
    }
    public function putCover(Request $request,string $id) {
        $this->admin($request);$this->find($id);
        $d=$request->validate(['file'=>'required|file|mimes:jpg,jpeg,png|max:2048']);
        $file=$d['file'];$mime=$file->getMimeType();
        if(!in_array($mime,['image/jpeg','image/png'],true)) throw new ApiException('VALIDATION_ERROR','Solo se permiten imágenes JPG o PNG.',422);
        $key=(string)Str::uuid().($mime==='image/png'?'.png':'.jpg');$path='covers/'.$key;
        Storage::disk('local')->put($path,file_get_contents($file->getRealPath()));
        $old=DB::table('costumes')->where('id',$id)->value('cover_key');
        DB::table('costumes')->where('id',$id)->update(['cover_key'=>$key]);
        if($old)Storage::disk('local')->delete('covers/'.$old);
        return response()->json(Presenters::costume($this->find($id)));
    }
    public function cover(string $id) {
        $row=$this->find($id);
        if(!$row->cover_key || !Storage::disk('local')->exists('covers/'.$row->cover_key))throw new ApiException('NOT_FOUND','Imagen no encontrada.',404);
        $type=str_ends_with($row->cover_key,'.png')?'image/png':'image/jpeg';
        return response(Storage::disk('local')->get('covers/'.$row->cover_key))->header('Content-Type',$type)->header('Cache-Control','private, max-age=3600');
    }
    public function deleteCover(Request $request,string $id) {
        $this->admin($request);$row=$this->find($id);
        DB::table('costumes')->where('id',$id)->update(['cover_key'=>null]);
        if($row->cover_key)Storage::disk('local')->delete('covers/'.$row->cover_key);
        return response()->noContent();
    }
}
