<?php
namespace App\Http\Controllers;
use App\Exceptions\ApiException;
use App\Domain\DateRange;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use InvalidArgumentException;
final class ReportController extends BaseController {
    public function mostRented(Request $request){
        $this->admin($request);
        $d=$request->validate(['from'=>'required|date_format:Y-m-d','to'=>'required|date_format:Y-m-d']);
        try{DateRange::validate($d['from'],$d['to']);}catch(InvalidArgumentException $e){throw new ApiException('INVALID_DATE_RANGE',$e->getMessage(),422);}
        $rows=DB::table('rental_items')->join('rentals','rentals.id','=','rental_items.rental_id')->whereDate('rentals.rented_at','>=',$d['from'])->whereDate('rentals.rented_at','<=',$d['to'])->select('rental_items.costume_id','rental_items.costume_name','rental_items.category_name')->selectRaw('COUNT(*) as times_rented')->groupBy('rental_items.costume_id','rental_items.costume_name','rental_items.category_name')->orderByDesc('times_rented')->orderBy('rental_items.costume_name')->get();
        return response()->json(['from'=>$d['from'],'to'=>$d['to'],'rows'=>$rows]);
    }
}
