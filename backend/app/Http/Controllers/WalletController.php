<?php

namespace App\Http\Controllers;

use App\Services\PaymentService;
use App\Services\WalletService;

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

}
