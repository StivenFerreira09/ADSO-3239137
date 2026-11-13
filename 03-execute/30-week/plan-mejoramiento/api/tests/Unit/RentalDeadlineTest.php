<?php
namespace Tests\Unit;
use PHPUnit\Framework\TestCase;
use App\Domain\CostumeRules;
use App\Domain\RentalRules;
use App\Domain\Reference;
use App\Domain\DateRange;
use App\Domain\OperatorRules;
final class RentalDeadlineTest extends TestCase {
 public function test_business_rule():void {$base=new \DateTimeImmutable('2026-11-01T00:00:00Z');$this->assertSame('2026-11-05T00:00:00+00:00',RentalRules::dueAt($base)->format('c'));}
}
