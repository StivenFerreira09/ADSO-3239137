<?php
namespace Tests\Feature;
use Tests\TestCase;
use Illuminate\Support\Facades\DB;
final class CategoryTest extends TestCase {
 public function test_evidence():void {$this->getJson('/api/v1/categories',$this->headers())->assertOk()->assertJsonCount(5);}
}
