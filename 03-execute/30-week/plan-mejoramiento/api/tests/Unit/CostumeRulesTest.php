<?php
namespace Tests\Unit;
use PHPUnit\Framework\TestCase;
use App\Domain\CostumeRules;
use App\Domain\RentalRules;
use App\Domain\Reference;
use App\Domain\DateRange;
use App\Domain\OperatorRules;
final class CostumeRulesTest extends TestCase {
 public function test_business_rule():void {$this->assertSame(2,CostumeRules::changeTotal(3,1,4));$this->assertSame(0,CostumeRules::withdraw(1));$this->assertSame(1,CostumeRules::restock(0,3));}
}
