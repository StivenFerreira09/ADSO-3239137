<?php
namespace App\Support;
use Carbon\CarbonImmutable;
use Illuminate\Http\Request;
use App\Exceptions\ApiException;
final class JsonData {
    public static function utc(?string $date):?string {return $date===null?null:CarbonImmutable::parse($date)->utc()->format('Y-m-d\TH:i:s\Z');}
    public static function pagination(Request $request):array {
        $page=(int)$request->query('page',1);$size=(int)$request->query('size',20);
        if($page<1 || $size<1 || $size>50 || (string)$page!== (string)$request->query('page','1') || (string)$size!==(string)$request->query('size','20')) throw new ApiException('VALIDATION_ERROR','Paginación no válida.',422);
        return [$page,$size];
    }
    public static function paged($query,Request $request,callable $map):array {
        [$page,$size]=self::pagination($request);$p=$query->paginate($size,['*'],'page',$page);
        return ['items'=>array_map($map,$p->items()),'page'=>$page,'size'=>$size,'total'=>$p->total()];
    }
}
