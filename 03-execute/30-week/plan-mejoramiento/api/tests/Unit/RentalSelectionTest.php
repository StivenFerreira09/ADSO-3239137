<?php
namespace Tests\Unit;
use PHPUnit\Framework\TestCase;
use App\Domain\CostumeRules;
use App\Domain\RentalRules;
use App\Domain\Reference;
use App\Domain\DateRange;
use App\Domain\OperatorRules;
final class RentalSelectionTest extends TestCase {
 public function test_business_rule():void {RentalRules::validateSelection(['a','b','c'],2,false);$this->expectException(\InvalidArgumentException::class);RentalRules::validateSelection(['a','b'],4,false);}
}
