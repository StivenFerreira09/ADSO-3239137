<?php
namespace Tests\Feature;
use Tests\TestCase;
use Illuminate\Support\Facades\DB;
final class CustomerCreateTest extends TestCase {
 public function test_evidence():void {$this->postJson('/api/v1/customers',['full_name'=>'Laura Fernández','document_number'=>'123-456'],$this->headers('advisor'))->assertCreated()->assertJsonPath('document_number','123-456');}
}
