<?php
namespace Tests\Feature;
use Tests\TestCase;
use Illuminate\Support\Facades\DB;
final class ReportSnapshotTest extends TestCase {
 public function test_evidence():void {$id=$this->costume();$h=$this->headers();$this->postJson('/api/v1/rentals',['customer_id'=>$this->customer(),'items'=>[['costume_id'=>$id]]],$h)->assertCreated();DB::table('costumes')->where('id',$id)->update(['name'=>'Nombre cambiado']);$date=now('UTC')->toDateString();$this->getJson('/api/v1/reports/most-rented?from='.$date.'&to='.$date,$h)->assertOk()->assertJsonPath('rows.0.costume_name','Traje de gala');}
}
