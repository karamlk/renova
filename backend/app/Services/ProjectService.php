<?php

namespace App\Services;

use App\Models\Payment;
use App\Models\Project;

class ProjectService
{


    public function waitingRelease()
    {
       // return Payment::with([

         return Payment::with([

             'user',

             'form.contractor',

             'form.engineer',

             'form.reconstructionRequest:id,title',

             'form:id,reconstruction_request_id,contractor_id,engineer_id,building_description',

             'form.project:id,construction_form_id,progress,status'



        ])

            ->where('status', 'paid')

            ->whereColumn(
                'released_amount',
                '<',
                'amount'
            )

            ->orderBy('created_at')

            ->get()

            ->map(function ($payment) {

                return [

                    'payment_id'        => $payment->id,

                    'project_id'        => $payment->form->id,

                    'construction_form' => $payment->construction_form_id,

                    'payment_type'      => $payment->type,

                    'contractor'        => $payment->form->contractor->name,

                    'engineer'          => $payment->form->engineer->name,

                    'user'              => $payment->user->name,

                    'title'=>$payment->form->reconstructionRequest->title,

                    'project_cost'      => $payment->form->total_cost,

                    'payment_amount'    => $payment->amount,

                    'released_amount'   => $payment->released_amount,

                    'remaining_amount'  => $payment->amount - $payment->released_amount,

                    'created_at'        => $payment->created_at,
                ];

            });

    }
    public function finishedPayments()
    {
        return Payment::with([

            'user',

            'form.contractor',

            'form.engineer',

            'form.reconstructionRequest'

        ])

            ->where('status','paid')

            ->whereColumn(

                'released_amount',

                '=',

                'amount'

            )

            ->orderByDesc('updated_at')

            ->get()

            ->map(function ($payment){

                return [

                    'payment_id'        => $payment->id,

                    'project_id'        => $payment->form->id,

                    'payment_type'      => $payment->type,

                    'contractor'        => $payment->form->contractor->name,

                    'engineer'          => $payment->form->engineer->name,

                    'user'              => $payment->user->name,

                    'amount'            => $payment->amount,

                    'released_amount'   => $payment->released_amount,

                    'released_at'       => $payment->updated_at

                ];

            });

    }

    public function userProjects()
    {
        return Project::with([
            'form.reconstructionRequest',
            'contractor',
            'engineer',
        ])
            ->where('user_id', auth()->id())
            ->latest()
            ->get();
    }

//    public function userProject($id)
//    {
//        return Project::with([
//            'form.reconstructionRequest',
//            'contractor',
//            'engineer',
//        ])
//            ->where('id', $id)
//            ->whereHas('form.reconstructionRequest', function ($query) {
//                $query->where('user_id', auth()->id());
//            })
//            ->firstOrFail();
//    }
    public function userProject($id)
    {
        return Project::with([
            'form.reconstructionRequest',
            'engineer',
            'contractor',
        ])
            ->where('id', $id)
            ->where('user_id', auth()->id())
            ->firstOrFail();
    }

//    public function show($id){
//        return Project::with([
//            'form.reconstructionRequest',
//            'engineer',
//            'user',
//        ])
//            ->where('id', $id)
//            ->where('user_id', auth()->id())
//            ->firstOrFail();
//
//    }

}
