<?php
namespace Tests\Feature;
use Tests\TestCase;
use Illuminate\Support\Facades\DB;
final class ArchitectureTest extends TestCase {
 public function test_evidence():void {$content=file_get_contents(app_path('Domain/RentalRules.php'));$this->assertStringNotContainsString('Illuminate\\', $content);$this->assertStringNotContainsString('Facades\\DB', $content);}
}
