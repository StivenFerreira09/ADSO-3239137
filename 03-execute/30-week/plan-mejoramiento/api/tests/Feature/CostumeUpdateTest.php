<?php
namespace Tests\Feature;
use Tests\TestCase;
use Illuminate\Support\Facades\DB;
final class CostumeUpdateTest extends TestCase {
 public function test_evidence():void {$id=$this->costume(3);$this->putJson('/api/v1/costumes/'.$id,['name'=>'Traje nuevo','designer'=>'Taller nuevo','category_id'=>$this->category(),'total_units'=>5],$this->headers())->assertOk()->assertJsonPath('available_units',5);}
}
