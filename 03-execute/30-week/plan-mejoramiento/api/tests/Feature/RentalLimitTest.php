<?php
namespace Tests\Feature;
use Tests\TestCase;
use Illuminate\Support\Facades\DB;
final class RentalLimitTest extends TestCase {
 public function test_evidence():void {$c=$this->customer();$ids=[];for($i=0;$i<6;$i++)$ids[]=$this->costume(1,'LIMIT-'.$i);$h=$this->headers();$payload=fn($ids)=>['customer_id'=>$c,'items'=>array_map(fn($id)=>['costume_id'=>$id],$ids)];$this->postJson('/api/v1/rentals',$payload(array_slice($ids,0,3)),$h)->assertCreated();$this->postJson('/api/v1/rentals',$payload(array_slice($ids,3,2)),$h)->assertCreated();$this->postJson('/api/v1/rentals',$payload([$ids[5]]),$h)->assertStatus(422)->assertJsonPath('code','CUSTOMER_LIMIT_EXCEEDED');}
}
