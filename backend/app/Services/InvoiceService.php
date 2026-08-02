<?php

namespace App\Services;

use App\Models\Invoice;
use App\Models\Payment;
use Illuminate\Support\Str;
use Mpdf\Mpdf;
use SimpleSoftwareIO\QrCode\Facades\QrCode;

class InvoiceService
{
    public function create(Payment $payment)
    {
        if ($payment->invoice) {
            return $payment->invoice;
        }

        $form = $payment->form;

        $project = $form->project;

        return Invoice::create([

            'invoice_number' => $this->generateInvoiceNumber(),

            'payment_id' => $payment->id,

            'project_id' => $project->id,

            'user_id' => $payment->user_id,

            'contractor_id' => $form->contractor_id,

            'amount' => $payment->amount,

            'invoice_type' => $payment->type,

            'status' => 'paid',

            'issued_at' => now(),

            'notes' => 'Invoice generated automatically.'

        ]);
    }

    private function generateInvoiceNumber()
    {
        return 'INV-'
            . now()->format('Y')
            . '-'
            . str_pad(
                Invoice::count() + 1,
                5,
                '0',
                STR_PAD_LEFT
            );
    }

    public function createReleaseInvoice(
        Payment $payment,
        float $releasedAmount
    )
    {
        $form = $payment->form;

        $project = $form->project;

        return Invoice::create([

            'invoice_number' => $this->generateInvoiceNumber(),

            'payment_id' => $payment->id,

            'project_id' => $project->id,

            'user_id' => $payment->user_id,

            'contractor_id' => $form->contractor_id,

            'amount' => $releasedAmount,

            'invoice_type' => 'release',

            'status' => 'paid',

            'issued_at' => now(),

            'notes' => 'Transfer invoice issued by admin.'

        ]);
    }
    public function myInvoices()
    {
        return Invoice::with([

            'project',

            'payment'

        ])
            ->where(
                'user_id',
                auth()->id()
            )
            ->latest()
            ->get();
    }
    public function contractorInvoices()
    {
        return Invoice::with([

            'project',

            'payment',

            'user'

        ])
            ->where(
                'contractor_id',
                auth()->id()
            )
            ->where(
                'invoice_type',
                'release'
            )
            ->latest()
            ->get();
    }
    public function adminInvoices()
    {
        return Invoice::with([

            'user',

            'contractor',

            'project',

            'payment'

        ])
            ->latest()
            ->get();
    }


    public function generatePdf(Invoice $invoice)
    {
        $invoice->load([

            'payment',

            'project.form',

            'user',

            'contractor'

        ]);

//            $qr = base64_encode(
//
//                QrCode::format('png')
//
//                    ->size(180)
//
//                    ->generate(
//
//                        url('/api/invoice/'.$invoice->id.'/verify')
//
//                    )
//


       // );

//        $html = view(
//
//            'pdf.invoice',
//
//            [
//
//                'invoice' => $invoice,
//
//                'qr' => $qr
//
//            ]
//
//        )->render();

        $html = view(
            'pdf.invoice',
            compact('invoice')
        )->render();

        $pdf = new Mpdf([

            'mode' => 'utf-8',

            'format' => 'A4'

        ]);

        $pdf->WriteHTML($html);

        return response(

            $pdf->Output('', 'S')

        )->header(

            'Content-Type',

            'application/pdf'

        );
    }
    public function verify(
        Invoice $invoice
    )
    {
        $invoice->load([

            'user',

            'contractor',

            'project.form'

        ]);

        return [

            'valid'=>true,

            'invoice_number'=>$invoice->invoice_number,

            'project'=>$invoice->project->form->building_description,

            'user'=>$invoice->user->name,

            'contractor'=>$invoice->contractor->name,

            'amount'=>$invoice->amount,

            'status'=>$invoice->status,

            'issued_at'=>$invoice->issued_at

        ];
    }

}
