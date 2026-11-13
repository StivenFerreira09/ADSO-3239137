<?php
namespace Tests\Feature;
use Tests\TestCase;
use Illuminate\Support\Facades\DB;
final class RoleForbiddenTest extends TestCase {
 public function test_evidence():void {$this->postJson('/api/v1/costumes',['name'=>'Gala','designer'=>'Atelier','reference'=>'XY-123','category_id'=>$this->category(),'total_units'=>1],$this->headers('advisor'))->assertStatus(403)->assertJson(['code'=>'FORBIDDEN_ROLE']);}
}
