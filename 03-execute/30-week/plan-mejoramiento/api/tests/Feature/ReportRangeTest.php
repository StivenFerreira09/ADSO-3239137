<?php
namespace Tests\Feature;
use Tests\TestCase;
use Illuminate\Support\Facades\DB;
final class ReportRangeTest extends TestCase {
 public function test_evidence():void {$this->getJson('/api/v1/reports/most-rented?from=2026-11-10&to=2026-11-01',$this->headers())->assertStatus(422)->assertJsonPath('code','INVALID_DATE_RANGE');}
}
