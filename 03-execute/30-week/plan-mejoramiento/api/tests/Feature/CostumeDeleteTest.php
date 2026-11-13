<?php
namespace Tests\Feature;
use Tests\TestCase;
use Illuminate\Support\Facades\DB;
final class CostumeDeleteTest extends TestCase {
 public function test_evidence():void {$id=$this->costume();$this->deleteJson('/api/v1/costumes/'.$id,[],$this->headers())->assertNoContent();$this->getJson('/api/v1/costumes/'.$id,$this->headers())->assertNotFound();}
}
