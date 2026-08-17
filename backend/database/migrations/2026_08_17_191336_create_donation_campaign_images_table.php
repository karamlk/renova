<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('donation_campaign_images', function (Blueprint $table) {

            $table->id();

            $table->foreignId('donation_campaign_id');

            $table->foreign(
                'donation_campaign_id',
                'dci_campaign_fk'
            )
                ->references('id')
                ->on('donation_campaigns')
                ->cascadeOnDelete();

            $table->string('image');

            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('donation_campaign_images');
    }
};
