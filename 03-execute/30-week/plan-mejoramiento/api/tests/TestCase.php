<?php
namespace Tests;
use Illuminate\Foundation\Testing\TestCase as BaseTestCase;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;
use App\Support\JwtToken;
abstract class TestCase extends BaseTestCase {
    use RefreshDatabase;
    protected function token(string $role='admin'):string {
        $id=(string)Str::uuid();$username='user'.str_replace('-','',substr($id,0,8));
        DB::table('operators')->insert(['id'=>$id,'username'=>$username,'password_hash'=>password_hash('ExamplePassword123',PASSWORD_ARGON2ID),'role'=>$role]);
        return JwtToken::issue($id,$role);
    }
    protected function headers(string $role='admin'):array {return ['Authorization'=>'Bearer '.$this->token($role)];}
    protected function category():string {return DB::table('categories')->first()->id;}
    protected function costume(int $units=2,string $reference='TRAJE-123'):string {
        $id=(string)Str::uuid();DB::table('costumes')->insert(['id'=>$id,'name'=>'Traje de gala','designer'=>'Taller local','reference'=>$reference,'category_id'=>$this->category(),'total_units'=>$units,'available_units'=>$units,'cover_key'=>null,'deleted_at'=>null]);return $id;
    }
    protected function customer(string $document='991122'):string {
        $id=(string)Str::uuid();DB::table('customers')->insert(['id'=>$id,'full_name'=>'Cliente Prueba','document_number'=>$document]);return $id;
    }
}
