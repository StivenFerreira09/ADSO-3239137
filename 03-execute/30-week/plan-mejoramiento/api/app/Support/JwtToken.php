<?php
namespace App\Support;
use App\Exceptions\ApiException;
final class JwtToken {
    private static function base64url(string $text):string {return rtrim(strtr(base64_encode($text),'+/','-_'),'=');}
    private static function decode(string $value):string|false {return base64_decode(strtr($value,'-_','+/'),true);}
    private static function secret():string {
        $key=(string)env('JWT_SECRET');if(strlen($key)<32) throw new \RuntimeException('JWT_SECRET debe tener 32 caracteres o más.');return $key;
    }
    public static function issue(string $id,string $role):string {
        $head=self::base64url(json_encode(['alg'=>'HS256','typ'=>'JWT']));
        $body=self::base64url(json_encode(['sub'=>$id,'role'=>$role,'iat'=>time(),'exp'=>time()+28800]));
        $data="$head.$body";$sign=self::base64url(hash_hmac('sha256',$data,self::secret(),true));
        return "$data.$sign";
    }
    public static function verify(string $token):array {
        $parts=explode('.',$token);
        if(count($parts)!==3) throw new ApiException('INVALID_CREDENTIALS','Token inválido o vencido.',401);
        [$head,$body,$sign]=$parts;
        $expected=self::base64url(hash_hmac('sha256',"$head.$body",self::secret(),true));
        $header=json_decode(self::decode($head)?:'',true);
        $data=json_decode(self::decode($body)?:'',true);
        if(!hash_equals($expected,$sign) || ($header['alg']??null)!=='HS256' || !is_array($data) || !is_string($data['sub']??null) || !in_array($data['role']??null,['admin','advisor'],true) || !is_int($data['exp']??null) || $data['exp']<=time()) throw new ApiException('INVALID_CREDENTIALS','Token inválido o vencido.',401);
        return $data;
    }
}
