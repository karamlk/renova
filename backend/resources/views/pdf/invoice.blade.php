<!DOCTYPE html>
<html lang="ar" dir="rtl">

<head>
    <meta charset="UTF-8">

    <style>

        body{
            font-family: dejavusans;
            direction: rtl;
            font-size:13px;
            color:#333;
            margin:35px;
        }

        .header{
            width:100%;
            border-bottom:3px solid #f07c1f;
            padding-bottom:15px;
            margin-bottom:25px;
        }

        .logo{
            width:80px;
        }

        .company{
            text-align:center;
        }

        .company h1{
            margin:0;
            color:#f07c1f;
            font-size:28px;
        }

        .company p{
            margin:0;
            color:#666;
        }

        .invoice-title{

            text-align:center;
            margin-top:25px;
            margin-bottom:25px;

        }

        .invoice-title h2{

            margin:0;
            color:#f07c1f;

        }

        .info-table{

            width:100%;
            border-collapse:collapse;
            margin-bottom:25px;

        }

        .info-table td{

            padding:8px;
            border:1px solid #ddd;

        }

        .section-title{

            background:#5E5D6290;
            color:white;
            padding:10px;
            font-weight:bold;
            margin-top:25px;

        }

        .details{

            width:100%;
            border-collapse:collapse;

        }

        .details th{

            background:#f3f6fb;
            padding:10px;
            border:1px solid #ddd;

        }

        .details td{

            padding:10px;
            border:1px solid #ddd;

        }

        .amount{

            font-size:22px;
            color:#f07c1f;
            font-weight:bold;
            text-align:center;
            margin-top:20px;

        }

        .notes{

            border:1px solid #ddd;
            padding:15px;
            margin-top:20px;

        }

        .footer{

            margin-top:50px;

        }

        .signature{

            width:100%;
            margin-top:50px;

        }

        .signature td{

            text-align:center;
            padding-top:40px;

        }

        /*.qr{*/

        /*    text-align:center;*/
        /*    margin-top:25px;*/

        /*}*/

        .copyright{

            text-align:center;
            margin-top:40px;
            color:#888;
            font-size:12px;

        }

        .badge{

            padding:6px 10px;
            border-radius:5px;
            color:white;
            font-weight:bold;
            display:inline-block;

        }

        .paid{

            background:#28a745;

        }

        .issued{

            background:#3d424c;

        }

        .cancelled{

            background:#dc3545;

        }

    </style>

</head>

<body>

<table class="header">

    <tr>

        <td width="15%">

            <img
                class="logo"
                src="{{ public_path('logo.png') }}">

        </td>

        <td class="company">

            <h1>ReNova</h1>

            <p>Reconstruction Platform</p>

        </td>

    </tr>

</table>

<div class="invoice-title">

    <h2>OFFICIAL INVOICE</h2>

</div>

<table class="info-table">

    <tr>

        <td>

            <strong>رقم الفاتورة</strong>

        </td>

        <td>

            {{ $invoice->invoice_number }}

        </td>

        <td>

            <strong>تاريخ الإصدار</strong>

        </td>

        <td>

            {{ optional($invoice->issued_at)->format('Y-m-d H:i') }}

        </td>

    </tr>

    <tr>

        <td>

            <strong>الحالة</strong>

        </td>

        <td>

            @if($invoice->status=='paid')

                <span class="badge paid">مدفوعة</span>

            @elseif($invoice->status=='issued')

                <span class="badge issued">صادرة</span>

            @else

                <span class="badge cancelled">ملغاة</span>

            @endif

        </td>

        <td>

            <strong>نوع الفاتورة</strong>

        </td>

        <td>

            @switch($invoice->invoice_type)

                @case('first_payment')

                    الدفعة الأولى

                    @break

                @case('second_payment')

                    الدفعة الثانية

                    @break

                @case('final_payment')

                    الدفعة الأخيرة

                    @break

                @case('release')

                    تحويل للمتعهد

                    @break

            @endswitch

        </td>

    </tr>

</table>

<div class="section-title">

    بيانات المشروع

</div>

<table class="details">

    <tr>

        <th width="30%">وصف المشروع</th>

        <td>{{ $invoice->project->form->building_description }}</td>

    </tr>

    <tr>

        <th>المتضرر</th>

        <td>{{ $invoice->user->name }}</td>

    </tr>

    <tr>

        <th>المتعهد</th>

        <td>{{ $invoice->contractor->name }}</td>

    </tr>

    <tr>

        <th>المبلغ</th>

        <td>{{ number_format($invoice->amount,2) }} ل.س</td>

    </tr>

</table>

<div class="amount">

    {{ number_format($invoice->amount,2) }}

    ل.س

</div>

@if($invoice->notes)

    <div class="section-title">

        الملاحظات

    </div>

    <div class="notes">

        {{ $invoice->notes }}

    </div>

@endif

{{--<div class="qr">--}}

{{--    <img--}}

{{--        src="data:image/png;base64,{{ $qr }}"--}}

{{--        width="120">--}}

{{--    <br><br>--}}

{{--    Scan To Verify--}}

{{--</div>--}}

<table class="signature">

    <tr>

        <td>

            ___________________

            <br><br>

            توقيع المستفيد

        </td>

        <td>

            ___________________

            <br><br>

            إدارة ReNova

        </td>

    </tr>

</table>

<div class="copyright">

    Generated Automatically By ReNova © {{ date('Y') }}

</div>

</body>

</html>
