<?php

namespace App\Services;

use App\Events\AppEvent;
use App\Models\Donation;
use App\Models\DonationCampaign;
use App\Models\ReconstructionRequest;
use App\Models\ReconstructionRequestImage;
use App\Models\Wallet;
use App\Models\WalletTransaction;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;

class DonationService
{
    public function donate(
        DonationCampaign $campaign,
        float $amount
    ) {
        $result = DB::transaction(function () use ($campaign, $amount) {

            $campaign = DonationCampaign::where('id', $campaign->id)
                ->lockForUpdate()
                ->firstOrFail();

            if ($amount <= 0) {
                abort(422, 'مبلغ التبرع يجب أن يكون أكبر من صفر');
            }

            if ($campaign->status !== 'active') {
                abort(422, 'هذه الحملة غير متاحة للتبرع حالياً');
            }

            $remaining =
                $campaign->target_amount -
                $campaign->collected_amount;

            if ($remaining <= 0) {
                abort(422, 'اكتمل مبلغ الحملة');
            }

            if ($amount > $remaining) {
                abort(
                    422,
                    'مبلغ التبرع أكبر من المبلغ المتبقي للحملة'
                );
            }

            $donorWallet = Wallet::where(
                'user_id',
                auth()->id()
            )
                ->lockForUpdate()
                ->firstOrFail();

            if ($donorWallet->balance < $amount) {
                abort(422, 'الرصيد غير كافٍ للتبرع');
            }

            $foundationRequest = $campaign->foundation;

            if (!$foundationRequest) {
                abort(
                    422,
                    'الجمعية المرتبطة بالحملة غير موجودة'
                );
            }

            $foundationUser = $foundationRequest->user;

            if (!$foundationUser) {
                abort(
                    422,
                    'حساب الجمعية غير موجود'
                );
            }

            $foundationWallet = Wallet::where(
                'user_id',
                $foundationUser->id
            )
                ->lockForUpdate()
                ->firstOrFail();

            if ($donorWallet->id === $foundationWallet->id) {
                abort(422, 'لا يمكنك التبرع لنفسك');
            }

            /*
             * خصم من المتبرع
             */
            $donorWallet->decrement(
                'balance',
                $amount
            );

            /*
             * تسجيل السحب
             */
            Log::info('BEFORE WITHDRAW TRANSACTION');

            $withdrawTransaction = WalletTransaction::create([
                'wallet_id' => $donorWallet->id,
                'amount' => $amount,
                'type' => 'withdraw',
                'description' => 'تبرع لحملة: ' . $campaign->title,
            ]);

            Log::info('AFTER WITHDRAW TRANSACTION', [
                'id' => $withdrawTransaction->id,
            ]);
            WalletTransaction::create([
                'wallet_id' => $donorWallet->id,
                'amount' => $amount,
                'type' => 'withdraw',
                'description' =>
                    'تبرع لحملة: ' . $campaign->title,
            ]);

            /*
             * إضافة للجمعية
             */
            $foundationWallet->increment(
                'balance',
                $amount
            );

            /*
             * تسجيل الإيداع
             */
            Log::info('BEFORE DEPOSIT TRANSACTION');

            $depositTransaction = WalletTransaction::create([
                'wallet_id' => $foundationWallet->id,
                'amount' => $amount,
                'type' => 'deposit',
                'description' => 'تبرع وارد لحملة: ' . $campaign->title,
            ]);

            Log::info('AFTER DEPOSIT TRANSACTION', [
                'id' => $depositTransaction->id,
            ]);
            WalletTransaction::create([
                'wallet_id' => $foundationWallet->id,
                'amount' => $amount,
                'type' => 'deposit',
                'description' =>
                    'تبرع وارد لحملة: ' . $campaign->title,
            ]);

            /*
             * إنشاء التبرع
             */
            $donation = Donation::create([
                'user_id' => auth()->id(),
                'donation_campaign_id' => $campaign->id,
                'amount' => $amount,
                'status' => 'completed',
            ]);
            Log::info('BEFORE DONATION CREATE');

            $donation = Donation::create([
                'user_id' => auth()->id(),
                'donation_campaign_id' => $campaign->id,
                'amount' => $amount,
                'status' => 'completed',
            ]);

            Log::info('AFTER DONATION CREATE', [
                'donation_id' => $donation->id,
            ]);
            /*
             * تحديث الحملة
             */
            $newCollectedAmount =
                $campaign->collected_amount + $amount;

            $campaign->update([
                'collected_amount' => $newCollectedAmount,
            ]);

            /*
             * إذا اكتملت الحملة
             */
            $reconstructionRequest = null;

            if (
                $newCollectedAmount >=
                $campaign->target_amount
            ) {

                $reconstructionRequest =
                    ReconstructionRequest::create([
                        'user_id' => $foundationUser->id,
                        'title' => $campaign->title,
                        'description' => $campaign->description,
                        'location' => $campaign->location,
                        'type' => 'restoration',
                        'status' => 'open',
                    ]);

                foreach ($campaign->images as $campaignImage) {

                    ReconstructionRequestImage::create([
                        'reconstruction_request_id' =>
                            $reconstructionRequest->id,

                        'image' => $campaignImage->image,
                    ]);
                }

                $campaign->update([
                    'status' => 'transferred',
                    'reconstruction_request_id' =>
                        $reconstructionRequest->id,
                ]);
            }

            return [
                'donation' => $donation,
                'foundation_user' => $foundationUser,
                'campaign' => $campaign,
            ];
        });

        /*
         * =====================================================
         * هون انتهت الـ transaction ونجحت قاعدة البيانات
         * =====================================================
         */

        $foundationUser = $result['foundation_user'];
        $donation = $result['donation'];
        $campaign = $result['campaign'];

        /*
         * إشعار Database
         */
        event(new AppEvent(
            $foundationUser->id,
            'تم التبرع لحملتك',
            'تم التبرع بمبلغ ' . $donation->amount . ' لمشروعك.',
            'campaign_donation',
            'donation_campaigns',
            $campaign->id
        ));

        /*
         * FCM
         */
        if ($foundationUser->fcm_token) {

            try {

                app(
                    \App\Services\FirebaseNotificationService::class
                )->send(
                    $foundationUser->fcm_token,
                    'تم التبرع لحملتك',
                    'تم التبرع بمبلغ ' . $donation->amount . ' لمشروعك.',
                    [
                        'type' => 'campaign_donation',
                        'target_path' => 'donation_campaigns',
                        'related_id' =>
                            (string) $campaign->id,
                    ]
                );

            } catch (\Throwable $e) {

                \Log::error('FCM donation notification failed', [
                    'error' => $e->getMessage(),
                    'user_id' => $foundationUser->id,
                ]);
            }
        }

        return $donation->load('campaign');
    }
}
