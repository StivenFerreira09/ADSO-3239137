<?php
namespace Tests\Feature;
use Tests\TestCase;
use Illuminate\Support\Facades\DB;
final class CostumeDuplicateTest extends TestCase {
 public function test_evidence():void {$this->costume(2,'DUPLICATE-1');$this->postJson('/api/v1/costumes',['name'=>'Copia','designer'=>'Prueba','reference'=>'DUPLICATE-1','category_id'=>$this->category(),'total_units'=>1],$this->headers())->assertStatus(409)->assertJsonPath('code','REFERENCE_TAKEN');}
}
