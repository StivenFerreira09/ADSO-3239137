<?php
use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;
use Illuminate\Support\Facades\DB;
return new class extends Migration {
 public function up():void {
    Schema::create('categories',function(Blueprint $t){$t->uuid('id')->primary();$t->string('name',120)->unique();});
    Schema::create('operators',function(Blueprint $t){$t->uuid('id')->primary();$t->string('username',120)->unique();$t->string('password_hash',512);$t->string('role',40);});
    Schema::create('customers',function(Blueprint $t){$t->uuid('id')->primary();$t->string('full_name',200);$t->string('document_number',30)->unique();});
    Schema::create('costumes',function(Blueprint $t){$t->uuid('id')->primary();$t->string('name',250);$t->string('designer',200);$t->string('reference',50);$t->foreignUuid('category_id')->constrained('categories')->restrictOnDelete();$t->integer('total_units');$t->integer('available_units');$t->string('cover_key',512)->nullable();$t->timestampTz('deleted_at')->nullable();});
    Schema::create('rentals',function(Blueprint $t){$t->uuid('id')->primary();$t->foreignUuid('customer_id')->constrained('customers')->restrictOnDelete();$t->foreignUuid('rented_by_operator_id')->constrained('operators')->restrictOnDelete();$t->timestampTz('rented_at');$t->index('rented_at');});
    Schema::create('rental_items',function(Blueprint $t){$t->uuid('id')->primary();$t->foreignUuid('rental_id')->constrained('rentals')->restrictOnDelete();$t->foreignUuid('costume_id')->constrained('costumes')->restrictOnDelete();$t->string('costume_name',250);$t->string('reference',50);$t->string('category_name',120);$t->timestampTz('due_at');$t->timestampTz('returned_at')->nullable();$t->unique(['rental_id','costume_id']);$t->index('costume_id');});
    DB::statement('ALTER TABLE costumes ADD CONSTRAINT ck_costume_total_positive CHECK (total_units >= 1)');
    DB::statement('ALTER TABLE costumes ADD CONSTRAINT ck_costume_available_range CHECK (available_units >= 0 AND available_units <= total_units)');
    DB::statement("ALTER TABLE operators ADD CONSTRAINT ck_operator_role CHECK (role IN ('admin','advisor'))");
    DB::statement('CREATE UNIQUE INDEX ux_active_costume_reference ON costumes(reference) WHERE deleted_at IS NULL');
    DB::statement('CREATE INDEX ix_active_costume_category_name ON costumes(category_id,name) WHERE deleted_at IS NULL');
    DB::statement('CREATE INDEX ix_open_rental_due ON rental_items(due_at) WHERE returned_at IS NULL');
    $names=['gala','folclor','teatro','infantiles','temporada'];
    foreach($names as $i=>$name){$n=$i+1;DB::table('categories')->insert(['id'=>str_repeat((string)$n,8).'-'.str_repeat((string)$n,4).'-4'.str_repeat((string)$n,3).'-8'.str_repeat((string)$n,3).'-'.str_repeat((string)$n,12),'name'=>$name]);}
 }
 public function down():void {Schema::dropIfExists('rental_items');Schema::dropIfExists('rentals');Schema::dropIfExists('costumes');Schema::dropIfExists('customers');Schema::dropIfExists('operators');Schema::dropIfExists('categories');}
};
