<?php
namespace Tests\Unit;
use PHPUnit\Framework\TestCase;
use App\Domain\CostumeRules;
use App\Domain\RentalRules;
use App\Domain\Reference;
use App\Domain\DateRange;
use App\Domain\OperatorRules;
final class RentalStatusTest extends TestCase {
 public function test_business_rule():void {$now=new \DateTimeImmutable('2026-11-10T00:00:00Z');$this->assertSame('open',RentalRules::status([['due_at'=>'2026-11-12T00:00:00Z','returned_at'=>null]],$now));$this->assertSame('overdue',RentalRules::status([['due_at'=>'2026-11-08T00:00:00Z','returned_at'=>null]],$now));$this->assertSame('closed',RentalRules::status([['due_at'=>'2026-11-08T00:00:00Z','returned_at'=>'2026-11-09T00:00:00Z']],$now));}
}
