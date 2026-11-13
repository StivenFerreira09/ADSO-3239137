<?php
namespace Tests\Feature;
use Tests\TestCase;
use Illuminate\Support\Facades\DB;
final class AuthRequiredTest extends TestCase {
 public function test_evidence():void {$this->getJson('/api/v1/costumes')->assertStatus(401)->assertJson(['code'=>'INVALID_CREDENTIALS']);}
}
