<?php
namespace App\Http\Controllers;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use App\Exceptions\ApiException;
use App\Support\JwtToken;
final class AuthController extends BaseController {
    public function login(Request $request) {
        $data=$request->validate(['username'=>'required|string','password'=>'required|string']);
        $name=strtolower(trim($data['username']));
        $user=DB::table('operators')->where('username',$name)->first();
        if(!$user || !password_verify($data['password'],$user->password_hash)) throw new ApiException('INVALID_CREDENTIALS','Credenciales inválidas.',401);
        return response()->json(['access_token'=>JwtToken::issue($user->id,$user->role),'token_type'=>'Bearer','expires_in'=>28800,'role'=>$user->role]);
    }
}
