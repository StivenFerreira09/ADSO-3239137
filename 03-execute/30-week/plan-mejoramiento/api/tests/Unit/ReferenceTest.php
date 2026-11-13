<?php
namespace Tests\Unit;
use PHPUnit\Framework\TestCase;
use App\Domain\CostumeRules;
use App\Domain\RentalRules;
use App\Domain\Reference;
use App\Domain\DateRange;
use App\Domain\OperatorRules;
final class ReferenceTest extends TestCase {
 public function test_business_rule():void {$this->assertSame('TRAJE-05',Reference::normalize(' traje-05 '));$this->expectException(\InvalidArgumentException::class);Reference::normalize('!!!');}
}
