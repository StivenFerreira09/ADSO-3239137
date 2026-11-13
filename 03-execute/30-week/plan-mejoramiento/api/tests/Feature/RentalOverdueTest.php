<?php
namespace Tests\Feature;
use Tests\TestCase;
use Illuminate\Support\Facades\DB;
final class RentalOverdueTest extends TestCase {
 public function test_evidence():void {$id=$this->costume();$h=$this->headers();$c=$this->customer();$this->postJson('/api/v1/rentals',['customer_id'=>$c,'items'=>[['costume_id'=>$id]]],$h)->assertCreated();DB::table('rental_items')->update(['due_at'=>now('UTC')->subDays(2)]);$this->getJson('/api/v1/rentals/overdue',$h)->assertOk()->assertJsonCount(1,'items');$this->postJson('/api/v1/rentals',['customer_id'=>$c,'items'=>[['costume_id'=>$id]]],$h)->assertStatus(409)->assertJsonPath('code','CUSTOMER_HAS_OVERDUE');}
}
