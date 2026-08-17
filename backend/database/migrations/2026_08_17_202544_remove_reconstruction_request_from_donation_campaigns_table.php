<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('donation_campaigns', function (Blueprint $table) {

            if (Schema::getConnection()->getDriverName() === 'sqlite') {
                // SQLite
                $table->dropForeign(['reconstruction_request_id']);
            } else {
                // MySQL
                $table->dropForeign('dc_reconstruction_request_fk');
            }

            // حذف العمود
            $table->dropColumn('reconstruction_request_id');

            // إضافة موقع الحالة
            $table->string('location')->after('description');
        });
    }

    public function down(): void
    {
        Schema::table('donation_campaigns', function (Blueprint $table) {

            $table->dropColumn('location');

            $table->unsignedBigInteger('reconstruction_request_id')
                ->nullable();

            $table->foreign(
                'reconstruction_request_id',
                'dc_reconstruction_request_fk'
            )
                ->references('id')
                ->on('reconstruction_requests')
                ->nullOnDelete();
        });
    }
};
