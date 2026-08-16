<?php

namespace App\Http\Controllers;

use App\Services\PaymentService;
use App\Services\WalletService;
use Illuminate\Http\Request;

class WalletController extends Controller
{
    public function __construct(
        protected WalletService $walletService
    ) {}

    public function financialAccount()
    {
        return response()->json([
              $this->walletService
                ->myFinancialAccount()
        ]);
    }

// ...

    /**
     * تنفيذ التحويل المالي
     */
    public function transfer(Request $request)
    {
        $request->validate([
            'card_number' => 'required|string',
            'amount'      => 'required|numeric|min:1',
            'description' => 'nullable|string|max:255'
        ]);

        $result = $this->walletService->transfer(
            $request->card_number,
            $request->amount,
            $request->description
        );

        return response()->json($result);
    }

    /**
     * قائمة بالمهندسين المتاحين للمقاول مع أرقام محافظهم
     */
    public function getEngineersForTransfer()
    {
        return response()->json(
             $this->walletService->getMyContractorEngineers());
    }
}
