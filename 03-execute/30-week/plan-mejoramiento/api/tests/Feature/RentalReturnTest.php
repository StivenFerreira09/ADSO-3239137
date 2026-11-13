<?php
namespace Tests\Feature;
use Tests\TestCase;
use Illuminate\Support\Facades\DB;
final class RentalReturnTest extends TestCase {
 public function test_evidence():void {$id=$this->costume(1);$h=$this->headers();$response=$this->postJson('/api/v1/rentals',['customer_id'=>$this->customer(),'items'=>[['costume_id'=>$id]]],$h)->assertCreated()->json();$url='/api/v1/rentals/'.$response['id'].'/items/'.$response['items'][0]['id'].'/return';$this->postJson($url,[],$h)->assertOk();$this->postJson($url,[],$h)->assertStatus(409)->assertJsonPath('code','ITEM_ALREADY_RETURNED');$this->assertSame(1,DB::table('costumes')->where('id',$id)->value('available_units'));}
}
