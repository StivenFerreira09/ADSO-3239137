<?php
namespace Tests\Feature;
use Tests\TestCase;
use Illuminate\Support\Facades\DB;
final class PaginateLimitTest extends TestCase {
 public function test_evidence():void {$this->getJson('/api/v1/costumes?size=51',$this->headers())->assertStatus(422)->assertJsonPath('code','VALIDATION_ERROR');}
}
