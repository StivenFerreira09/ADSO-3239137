<?php
namespace Tests\Feature;
use Tests\TestCase;
use Illuminate\Support\Facades\DB;
final class CostumeCreateTest extends TestCase {
 public function test_evidence():void {$this->postJson('/api/v1/costumes',['name'=>'Traje profesional','designer'=>'Costurero','reference'=>'AbC-42','category_id'=>$this->category(),'total_units'=>4],$this->headers())->assertCreated()->assertJsonPath('reference','ABC-42')->assertJsonPath('available_units',4);}
}
