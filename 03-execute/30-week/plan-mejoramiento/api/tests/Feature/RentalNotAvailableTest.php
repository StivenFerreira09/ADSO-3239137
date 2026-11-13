<?php
namespace Tests\Feature;
use Tests\TestCase;
use Illuminate\Support\Facades\DB;
final class RentalNotAvailableTest extends TestCase {
 public function test_evidence():void {$id=$this->costume(1);$c=$this->customer();$h=$this->headers();$this->postJson('/api/v1/rentals',['customer_id'=>$c,'items'=>[['costume_id'=>$id]]],$h)->assertCreated();$c2=$this->customer('991123');$this->postJson('/api/v1/rentals',['customer_id'=>$c2,'items'=>[['costume_id'=>$id]]],$h)->assertStatus(409)->assertJsonPath('code','COSTUME_NOT_AVAILABLE');}
}
