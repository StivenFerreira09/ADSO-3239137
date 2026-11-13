<?php
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\AuthController;
use App\Http\Controllers\OperatorController;
use App\Http\Controllers\CostumeController;
use App\Http\Controllers\CustomerController;
use App\Http\Controllers\RentalController;
use App\Http\Controllers\ReportController;
Route::prefix('v1')->group(function () {
    Route::get('/health',fn()=>response()->json(['status'=>'ok']));
    Route::post('/auth/login',[AuthController::class,'login']);
    Route::middleware('operator')->group(function () {
        Route::post('/users',[OperatorController::class,'store']);
        Route::get('/categories',[CostumeController::class,'categories']);
        Route::get('/costumes',[CostumeController::class,'index']);
        Route::post('/costumes',[CostumeController::class,'store']);
        Route::get('/costumes/{id}',[CostumeController::class,'show']);
        Route::put('/costumes/{id}',[CostumeController::class,'update']);
        Route::delete('/costumes/{id}',[CostumeController::class,'destroy']);
        Route::get('/costumes/{id}/cover',[CostumeController::class,'cover']);
        Route::put('/costumes/{id}/cover',[CostumeController::class,'putCover']);
        Route::delete('/costumes/{id}/cover',[CostumeController::class,'deleteCover']);
        Route::get('/customers',[CustomerController::class,'index']);
        Route::post('/customers',[CustomerController::class,'store']);
        Route::get('/customers/{id}',[CustomerController::class,'show']);
        Route::get('/rentals/overdue',[RentalController::class,'overdue']);
        Route::get('/rentals',[RentalController::class,'index']);
        Route::post('/rentals',[RentalController::class,'store']);
        Route::get('/rentals/{id}',[RentalController::class,'show']);
        Route::post('/rentals/{rental_id}/items/{item_id}/return',[RentalController::class,'returnItem']);
        Route::get('/reports/most-rented',[ReportController::class,'mostRented']);
    });
});
