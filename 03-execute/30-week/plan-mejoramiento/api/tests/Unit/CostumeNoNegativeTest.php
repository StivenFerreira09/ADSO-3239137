<?php
namespace Tests\Unit;
use PHPUnit\Framework\TestCase;
use App\Domain\CostumeRules;
use App\Domain\RentalRules;
use App\Domain\Reference;
use App\Domain\DateRange;
use App\Domain\OperatorRules;
final class CostumeNoNegativeTest extends TestCase {
 public function test_business_rule():void {$this->expectException(\InvalidArgumentException::class);CostumeRules::changeTotal(5,1,3);}
}
