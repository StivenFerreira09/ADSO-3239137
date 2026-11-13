<?php
namespace Tests\Feature;
use Tests\TestCase;
use Illuminate\Support\Facades\DB;
final class HealthTest extends TestCase {
 public function test_evidence():void {$this->getJson('/api/v1/health')->assertOk()->assertJson(['status'=>'ok']);}
}
