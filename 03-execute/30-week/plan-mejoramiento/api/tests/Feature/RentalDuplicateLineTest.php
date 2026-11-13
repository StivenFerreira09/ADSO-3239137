<?php
namespace Tests\Feature;
use Tests\TestCase;
use Illuminate\Support\Facades\DB;
final class RentalDuplicateLineTest extends TestCase {
 public function test_evidence():void {$id=$this->costume(2);$this->postJson('/api/v1/rentals',['customer_id'=>$this->customer(),'items'=>[['costume_id'=>$id],['costume_id'=>$id]]],$this->headers())->assertStatus(422)->assertJsonPath('code','DUPLICATE_COSTUME_IN_RENTAL');}
}
