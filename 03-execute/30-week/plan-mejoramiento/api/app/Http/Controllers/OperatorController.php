<?php
namespace App\Http\Controllers;
use App\Exceptions\ApiException;
use App\Domain\OperatorRules;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;
final class OperatorController extends BaseController {
    public function store(Request $request) {
        $this->admin($request);
        $data=$request->validate(['username'=>'required|string|max:120','password'=>'required|string|min:12','role'=>'required|string|in:advisor']);
        $name=OperatorRules::username($data['username']);
        if(!$name) throw new ApiException('VALIDATION_ERROR','El nombre es obligatorio.',422);
        if(DB::table('operators')->where('username',$name)->exists()) throw new ApiException('USERNAME_TAKEN','El usuario ya existe.',409);
        $id=(string)Str::uuid();DB::table('operators')->insert(['id'=>$id,'username'=>$name,'password_hash'=>password_hash($data['password'],PASSWORD_ARGON2ID),'role'=>'advisor']);
        return response()->json(['id'=>$id,'username'=>$name,'role'=>'advisor'],201);
    }
}
