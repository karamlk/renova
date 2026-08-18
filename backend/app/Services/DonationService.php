<?php

namespace App\Services;

use App\Models\Donation;
use App\Models\DonationCampaign;
use App\Models\ReconstructionRequest;
use App\Models\ReconstructionRequestImage;
use App\Models\Wallet;
use App\Models\WalletTransaction;
use Illuminate\Support\Facades\DB;

class DonationService
{
    public function donate(
        DonationCampaign $campaign,
        float $amount
    ) {
        return DB::transaction(function () use (
            $campaign,
            $amount
        ) {

            // التحقق من مبلغ التبرع
            if ($amount <= 0) {
                abort(
                    422,
                    'مبلغ التبرع يجب أن يكون أكبر من صفر'
                );
            }

            // الحملة يجب أن تكون فعالة
            if ($campaign->status !== 'active') {
                abort(
                    422,
                    'هذه الحملة غير متاحة للتبرع حالياً'
                );
            }

            // المبلغ المتبقي
            $remaining =
                $campaign->target_amount -
                $campaign->collected_amount;

            if ($remaining <= 0) {
                abort(
                    422,
                    'اكتمل مبلغ الحملة'
                );
            }

            // منع التبرع بأكثر من المبلغ المتبقي
            if ($amount > $remaining) {
                abort(
                    422,
                    'مبلغ التبرع أكبر من المبلغ المتبقي للحملة'
                );
            }

            // محفظة المتبرع
            $donorWallet = Wallet::where(
                'user_id',
                auth()->id()
            )->firstOrFail();

            // التحقق من الرصيد
            if ($donorWallet->balance < $amount) {
                abort(
                    422,
                    'الرصيد غير كافٍ للتبرع'
                );
            }

            // الجمعية صاحبة الحملة
            $foundationRequest = $campaign->foundation;

            if (!$foundationRequest) {
                abort(
                    422,
                    'الجمعية المرتبطة بالحملة غير موجودة'
                );
            }

            // User الجمعية
            $foundationUser = $foundationRequest->user;

            if (!$foundationUser) {
                abort(
                    422,
                    'حساب الجمعية غير موجود'
                );
            }

            // محفظة الجمعية
            $foundationWallet = Wallet::where(
                'user_id',
                $foundationUser->id
            )->firstOrFail();

            // منع التبرع للنفس
            if (
                $donorWallet->id ===
                $foundationWallet->id
            ) {
                abort(
                    422,
                    'لا يمكنك التبرع لنفسك'
                );
            }

            /*
             * خصم من محفظة المتبرع
             */
            $donorWallet->decrement(
                'balance',
                $amount
            );

            WalletTransaction::create([
                'wallet_id' => $donorWallet->id,
                'amount' => $amount,
                'type' => 'withdraw',
                'description' =>
                    'تبرع لحملة: ' .
                    $campaign->title,
            ]);

            /*
             * إضافة لمحفظة الجمعية
             */
            $foundationWallet->increment(
                'balance',
                $amount
            );

            WalletTransaction::create([
                'wallet_id' => $foundationWallet->id,
                'amount' => $amount,
                'type' => 'deposit',
                'description' =>
                    'تبرع وارد لحملة: ' .
                    $campaign->title,
            ]);

            /*
             * إنشاء سجل التبرع
             */
            $donation = Donation::create([
                'user_id' => auth()->id(),

                'donation_campaign_id' =>
                    $campaign->id,

                'amount' => $amount,

                'status' => 'completed',
            ]);

            /*
             * تحديث المبلغ المجمع
             */
            $newCollectedAmount =
                $campaign->collected_amount +
                $amount;

            $campaign->update([
                'collected_amount' =>
                    $newCollectedAmount,
            ]);

            /*
             * إذا اكتمل المبلغ
             */
            if (
                $newCollectedAmount >=
                $campaign->target_amount
            ) {

                // إنشاء طلب إعادة الإعمار باسم الجمعية
                $reconstructionRequest =
                    ReconstructionRequest::create([

                        'user_id' =>
                            $foundationUser->id,

                        'title' =>
                            $campaign->title,

                        'description' =>
                            $campaign->description,

                        'location' =>
                            $campaign->location,

                        'type' =>
                            'restoration',

                        'status' =>
                            'open',
                    ]);

                /*
                 * نقل صور الحملة
                 * إلى طلب إعادة الإعمار
                 */
                foreach (
                    $campaign->images as $campaignImage
                ) {

                    ReconstructionRequestImage::create([
                        'reconstruction_request_id' =>
                            $reconstructionRequest->id,

                        'image' =>
                            $campaignImage->image,
                    ]);
                }

                /*
                 * ربط الحملة بطلب إعادة الإعمار
                 */
                $campaign->update([
                    'status' =>
                        'transferred',

                    'reconstruction_request_id' =>
                        $reconstructionRequest->id,
                ]);
            }

            return $donation->load([
                'campaign'
            ]);
        });
    }
}
