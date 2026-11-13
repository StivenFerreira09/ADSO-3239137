<?php
namespace Tests\Feature;
use Tests\TestCase;
use Illuminate\Support\Facades\DB;
final class AuthInvalidTest extends TestCase {
 public function test_evidence():void {$this->postJson('/api/v1/auth/login',['username'=>'none','password'=>'badpassword'])->assertStatus(401)->assertJsonStructure(['code','message','details'])->assertDontSee('password_hash');}
}
