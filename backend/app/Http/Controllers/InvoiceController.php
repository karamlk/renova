<?php

namespace App\Http\Controllers;

use App\Models\Invoice;
use App\Services\InvoiceService;
use Illuminate\Http\Request;

class InvoiceController extends Controller
{

    public function myInvoices()
    {
        return response()->json(

            app(InvoiceService::class)
                ->myInvoices()

        );
    }
    public function contractorInvoices()
    {
        return response()->json(

            app(InvoiceService::class)
                ->contractorInvoices()

        );
    }
    public function adminInvoices()
    {
        return response()->json(

            app(InvoiceService::class)
                ->adminInvoices()

        );
    }
    public function pdf(
        Invoice $invoice
    )
    {
        return app(
            InvoiceService::class
        )->generatePdf(
            $invoice
        );
    }
    public function verify(
        Invoice $invoice
    )
    {
        return response()->json(

            app(InvoiceService::class)
                ->verify(
                    $invoice
                )

        );
    }
}
