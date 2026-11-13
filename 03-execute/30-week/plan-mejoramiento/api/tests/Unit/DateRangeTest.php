<?php
namespace Tests\Unit;
use PHPUnit\Framework\TestCase;
use App\Domain\CostumeRules;
use App\Domain\RentalRules;
use App\Domain\Reference;
use App\Domain\DateRange;
use App\Domain\OperatorRules;
final class DateRangeTest extends TestCase {
 public function test_business_rule():void {DateRange::validate('2026-11-01','2026-11-10');$this->expectException(\InvalidArgumentException::class);DateRange::validate('2026-11-10','2026-11-01');}
}
