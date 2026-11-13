<?php
namespace Tests\Feature;
use Tests\TestCase;
use Illuminate\Support\Facades\DB;
final class CustomerDuplicateTest extends TestCase {
 public function test_evidence():void {$this->customer('12345');$this->postJson('/api/v1/customers',['full_name'=>'Nueva','document_number'=>'12345'],$this->headers())->assertStatus(409)->assertJsonPath('code','DOCUMENT_TAKEN');}
}
