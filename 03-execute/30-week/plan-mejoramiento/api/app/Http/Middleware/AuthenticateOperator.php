<?php
namespace App\Http\Middleware;
use App\Exceptions\ApiException;
use App\Support\JwtToken;
use Illuminate\Support\Facades\DB;
use Closure;
final class AuthenticateOperator {
    public function handle($request,Closure $next) {
        $token=$request->bearerToken();
        if (!$token) throw new ApiException('INVALID_CREDENTIALS','Debe iniciar sesión.',401);
        $data=JwtToken::verify($token);
        $operator=DB::table('operators')->where('id',$data['sub'])->first();
        if (!$operator || $operator->role!==$data['role']) throw new ApiException('INVALID_CREDENTIALS','Token inválido o vencido.',401);
        $request->attributes->set('operator',$operator);
        return $next($request);
    }
}
