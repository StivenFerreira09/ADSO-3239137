<?php
use Illuminate\Support\Facades\Artisan;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;
Artisan::command('app:provision-admin', function () {
    $username=strtolower(trim((string)env('ADMIN_USERNAME','')));
    $password=(string)env('ADMIN_PASSWORD','');
    if (!$username || strlen($password)<12) { $this->error('Defina ADMIN_USERNAME y ADMIN_PASSWORD de al menos 12 caracteres.'); return 1; }
    if (!DB::table('operators')->where('username',$username)->exists()) {
        DB::table('operators')->insert(['id'=>(string)Str::uuid(),'username'=>$username,'password_hash'=>password_hash($password,PASSWORD_ARGON2ID),'role'=>'admin']);
        $this->info('Administrador inicial creado.');
    } else $this->info('El administrador ya existe.');
    return 0;
});
