<?php
namespace Tests\Feature;
use Tests\TestCase;
use Illuminate\Support\Facades\DB;
final class CostumeSearchTest extends TestCase {
 public function test_evidence():void {$this->costume();$this->getJson('/api/v1/costumes?q=Gala&size=10',$this->headers())->assertOk()->assertJsonPath('total',1)->assertJsonCount(1,'items');}
}
