<?php
namespace App\Http\Controllers;
use App\Exceptions\ApiException;
use Illuminate\Http\Request;
abstract class BaseController {
    protected function admin(Request $request):void {
        if($request->attributes->get('operator')->role!=='admin') throw new ApiException('FORBIDDEN_ROLE','No tiene permiso para realizar esta acción.',403);
    }
}
