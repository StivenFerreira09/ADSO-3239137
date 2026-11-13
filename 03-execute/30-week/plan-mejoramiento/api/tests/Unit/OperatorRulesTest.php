<?php
namespace Tests\Unit;
use PHPUnit\Framework\TestCase;
use App\Domain\CostumeRules;
use App\Domain\RentalRules;
use App\Domain\Reference;
use App\Domain\DateRange;
use App\Domain\OperatorRules;
final class OperatorRulesTest extends TestCase {
 public function test_business_rule():void {$this->assertSame('stiven',OperatorRules::username(' Stiven '));$this->assertSame('advisor',OperatorRules::role('advisor'));$this->expectException(\InvalidArgumentException::class);OperatorRules::role('admin');}
}
