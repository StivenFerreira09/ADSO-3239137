<?php
namespace App\Providers;
use Illuminate\Support\ServiceProvider;
use App\Ports\RentalPort;
use App\Adapters\DatabaseRentalAdapter;
final class AppServiceProvider extends ServiceProvider {
    public function register():void {$this->app->bind(RentalPort::class,DatabaseRentalAdapter::class);}
    public function boot():void {}
}
