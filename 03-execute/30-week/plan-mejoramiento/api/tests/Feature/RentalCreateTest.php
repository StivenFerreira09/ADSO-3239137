<?php
namespace Tests\Feature;
use Tests\TestCase;
use Illuminate\Support\Facades\DB;
final class RentalCreateTest extends TestCase {
 public function test_evidence():void {$id=$this->costume(2);$customer=$this->customer();$this->postJson('/api/v1/rentals',['customer_id'=>$customer,'items'=>[['costume_id'=>$id]]],$this->headers())->assertCreated()->assertJsonPath('status','open')->assertJsonCount(1,'items');$this->assertSame(1,DB::table('costumes')->where('id',$id)->value('available_units'));}
}
