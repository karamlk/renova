
<!DOCTYPE html>
<html lang="ar" dir="rtl">

<head>
    <meta charset="UTF-8">

    <style>

        body {
            font-family: dejavusans;
            direction: rtl;
            font-size: 13px;
            color: #333;
            margin: 35px;
        }

        .header {
            width: 100%;
            border-bottom: 3px solid #f07c1f;
            padding-bottom: 15px;
            margin-bottom: 25px;
        }

        .logo {
            width: 80px;
        }

        .company {
            text-align: center;
        }

        .company h1 {
            margin: 0;
            color: #f07c1f;
            font-size: 28px;
        }

        .company p {
            margin: 0;
            color: #666;
        }

        .document-title {
            text-align: center;
            margin-top: 25px;
            margin-bottom: 25px;
        }

        .document-title h2 {
            margin: 0;
            color: #f07c1f;
            font-size: 22px;
        }

        .document-title p {
            color: #666;
            margin-top: 5px;
        }

        .info-table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 25px;
        }

        .info-table td {
            padding: 8px;
            border: 1px solid #ddd;
        }

        .info-table td:first-child,
        .info-table td:nth-child(3) {
            background: #f3f6fb;
        }

        .section-title {
            background: #5E5D62;
            color: white;
            padding: 10px;
            font-weight: bold;
            margin-top: 25px;
            margin-bottom: 10px;
        }

        .details {
            width: 100%;
            border-collapse: collapse;
        }

        .details th {
            background: #f3f6fb;
            color: #444;
            padding: 10px;
            border: 1px solid #ddd;
            width: 30%;
        }

        .details td {
            padding: 10px;
            border: 1px solid #ddd;
        }

        .cost-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 10px;
        }

        .cost-table th {
            background: #f3f6fb;
            color: #444;
            padding: 9px;
            border: 1px solid #ddd;
            text-align: center;
        }

        .cost-table td {
            padding: 9px;
            border: 1px solid #ddd;
            text-align: center;
        }

        .total-row {
            background: #eeeeee;
            font-weight: bold;
        }

        .total-amount {
            color: #f07c1f;
            font-size: 18px;
            font-weight: bold;
        }

        .notes {
            border: 1px solid #ddd;
            background: #fafafa;
            padding: 15px;
            margin-top: 10px;
            margin-bottom: 15px;
            line-height: 1.8;
        }

        .badge {
            padding: 6px 10px;
            border-radius: 5px;
            color: white;
            font-weight: bold;
            display: inline-block;
        }

        .approved {
            background: #28a745;
        }

        .pending {
            background: #3d424c;
        }

        .rejected {
            background: #dc3545;
        }

        .signature {
            width: 100%;
            margin-top: 50px;
        }

        .signature td {
            text-align: center;
            padding-top: 40px;
        }

        .copyright {
            text-align: center;
            margin-top: 40px;
            color: #888;
            font-size: 12px;
        }

        .orange {
            color: #f07c1f;
            font-weight: bold;
        }

    </style>

</head>

<body>

{{-- HEADER --}}

<table class="header">

    <tr>

        <td width="15%">

            <img
                class="logo"
                src="{{ public_path('logo.png') }}"
            >

        </td>

        <td class="company">

            <h1>ReNova</h1>

            <p>Reconstruction Platform</p>

        </td>

    </tr>

</table>


{{-- TITLE --}}

<div class="document-title">

    <h2>
        استمارة تكاليف أعمال البناء وإعادة الإعمار
    </h2>

    <p>
        وثيقة رسمية معتمدة وموثقة
    </p>

</div>


{{-- GENERAL INFORMATION --}}

<div class="section-title">

    1. معلومات عامة عن الطلب

</div>

<table class="info-table">

    <tr>

        <td>
            <strong>رقم الاستمارة الرسمية</strong>
        </td>

        <td>
            #FORM-{{ $form->id }}
        </td>

        <td>
            <strong>رقم طلب إعادة الإعمار</strong>
        </td>

        <td>
            #REQ-{{ $form->reconstruction_request_id }}
        </td>

    </tr>

    <tr>

        <td>
            <strong>حالة الاعتماد</strong>
        </td>

        <td>

            @if($form->status === 'approved')

                <span class="badge approved">
                    مقبولة
                </span>

            @elseif($form->status === 'rejected')

                <span class="badge rejected">
                    مرفوضة
                </span>

            @else

                <span class="badge pending">
                    {{ $form->status }}
                </span>

            @endif

        </td>

        <td>
            <strong>تاريخ الاستمارة</strong>
        </td>

        <td>
            {{ optional($form->created_at)->format('Y-m-d') }}
        </td>

    </tr>

</table>


{{-- TECHNICAL DETAILS --}}

<div class="section-title">

    2. التفاصيل الفنية والإنشائية للمبنى

</div>

<table class="details">

    <tr>

        <th>
            وصف أعمال البناء المقررة
        </th>

        <td>
            {{ $form->building_description }}
        </td>

    </tr>

    <tr>

        <th>
            مدة التنفيذ والتسليم المتوقعة
        </th>

        <td>
            {{ $form->execution_duration }}
        </td>

    </tr>

    <tr>

        <th>
            فترة الضمان الممنوحة من المتعهد
        </th>

        <td>
            {{ $form->warranty_period }}
        </td>

    </tr>

</table>


{{-- COST DETAILS --}}

<div class="section-title">

    3. الكشف المالي التفصيلي وتحليل الأسعار

</div>

<table class="cost-table">

    <thead>

    <tr>

        <th>
            تكلفة المواد
        </th>

        <th>
            تكلفة الأيدي العاملة
        </th>

        <th>
            هامش ربح المتعهد
        </th>

    </tr>

    </thead>

    <tbody>

    <tr>

        <td>
            {{ number_format($form->materials_cost, 2) }}
            ل.س
        </td>

        <td>
            {{ number_format($form->labor_cost, 2) }}
            ل.س
        </td>

        <td>
            {{ number_format($form->profit, 2) }}
            ل.س
        </td>

    </tr>

    <tr class="total-row">

        <td colspan="2" style="text-align: right;">

            إجمالي التكلفة الكلية المعتمدة للمشروع:

        </td>

        <td class="total-amount">

            {{ number_format($form->total_cost, 2) }}
            ل.س

        </td>

    </tr>

    </tbody>

</table>


{{-- MATERIALS --}}

<div class="section-title">

    4. جدول المواد الإنشائية المعتمدة

</div>

<table class="cost-table">

    <thead>

    <tr>

        <th>اسم المادة</th>

        <th>نوع المادة</th>

        <th>الكمية</th>

        <th>الوحدة</th>

        <th>سعر الوحدة</th>

        <th>السعر الإجمالي</th>

    </tr>

    </thead>

    <tbody>

    @forelse($form->materials as $material)

        <tr>

            <td>
                {{ $material->material_name }}
            </td>

            <td>
                {{ $material->material_type }}
            </td>

            <td>
                {{ $material->quantity }}
            </td>

            <td>
                {{ $material->unit }}
            </td>

            <td>
                {{ number_format($material->unit_price, 2) }}
                ل.س
            </td>

            <td>
                {{ number_format($material->total_price, 2) }}
                ل.س
            </td>

        </tr>

    @empty

        <tr>

            <td colspan="6">

                لا توجد مواد مسجلة لهذه الاستمارة

            </td>

        </tr>

    @endforelse

    </tbody>

</table>


{{-- OFFICIAL NOTES --}}

<div class="section-title">

    5. الملاحظات والاعتمادات الرسمية

</div>


<p class="orange">

    ملاحظات واعتماد المهندس المدقق:

</p>

<div class="notes">

    {{ $form->engineer_notes
        ?? 'تمت المراجعة والقبول الفني والإنشائي من قِبل المهندس المختص دون أي ملاحظات.'
    }}

</div>


<p class="orange">

    ملاحظات واعتماد المتضرر:

</p>

<div class="notes">

    {{ $form->user_notes
        ?? 'تمت الموافقة والاعتماد النهائي على بنود الاستمارة والأسعار من قِبل المستفيد للبدء بالتنفيذ.'
    }}

</div>


{{-- SIGNATURES --}}

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

            توقيع المتعهد

        </td>

        <td>

            ___________________

            <br><br>

            إدارة ReNova

        </td>

    </tr>

</table>


{{-- FOOTER --}}

<div class="copyright">

    Generated Automatically By ReNova

    <br>

    Electronic Construction Cost Form © {{ date('Y') }}

</div>

</body>

</html>


{{--<!DOCTYPE html>--}}

{{--<html lang="ar" dir="rtl">--}}
{{--<head>--}}
{{--    <meta charset="UTF-8">--}}
{{--    <title>استمارة تكاليف أعمال البناء</title>--}}

{{--    ```--}}
{{--    <style>--}}
{{--        body {--}}
{{--            font-family: sans-serif;--}}
{{--            direction: rtl;--}}
{{--            text-align: right;--}}
{{--            color: #2d3748;--}}
{{--            line-height: 1.6;--}}
{{--        }--}}

{{--        .header {--}}
{{--            border-bottom: 3px solid #2b6cb0;--}}
{{--            padding-bottom: 10px;--}}
{{--            margin-bottom: 25px;--}}
{{--            text-align: center;--}}
{{--        }--}}

{{--        .header h1 {--}}
{{--            color: #2b6cb0;--}}
{{--            font-size: 22pt;--}}
{{--            margin: 0 0 5px 0;--}}
{{--        }--}}

{{--        .header p {--}}
{{--            color: #4a5568;--}}
{{--            font-size: 12pt;--}}
{{--            margin: 0;--}}
{{--        }--}}

{{--        .section-title {--}}
{{--            font-size: 14pt;--}}
{{--            color: #2b6cb0;--}}
{{--            border-bottom: 1px solid #e2e8f0;--}}
{{--            padding-bottom: 5px;--}}
{{--            margin-top: 25px;--}}
{{--            font-weight: bold;--}}
{{--        }--}}

{{--        table {--}}
{{--            width: 100%;--}}
{{--            border-collapse: collapse;--}}
{{--            margin-top: 10px;--}}
{{--            margin-bottom: 15px;--}}
{{--        }--}}

{{--        th,--}}
{{--        td {--}}
{{--            border: 1px solid #cbd5e0;--}}
{{--            padding: 10px;--}}
{{--            font-size: 11pt;--}}
{{--            text-align: right;--}}
{{--        }--}}

{{--        th {--}}
{{--            background-color: #ebf8ff;--}}
{{--            color: #2b6cb0;--}}
{{--            width: 30%;--}}
{{--            font-weight: bold;--}}
{{--        }--}}

{{--        .cost-table th {--}}
{{--            width: auto;--}}
{{--            text-align: center;--}}
{{--        }--}}

{{--        .cost-table td {--}}
{{--            text-align: center;--}}
{{--        }--}}

{{--        .total-row {--}}
{{--            background-color: #e2e8f0;--}}
{{--            font-weight: bold;--}}
{{--        }--}}

{{--        .notes-box {--}}
{{--            border: 1px solid #cbd5e0;--}}
{{--            background-color: #f7fafc;--}}
{{--            padding: 12px;--}}
{{--            font-size: 11pt;--}}
{{--            margin-top: 8px;--}}
{{--            margin-bottom: 15px;--}}
{{--        }--}}
{{--    </style>--}}
{{--    ```--}}

{{--</head>--}}
{{--<body>--}}

{{--<div class="header">--}}
{{--    <h1>استمارة تكاليف أعمال البناء وإعادة الإعمار</h1>--}}
{{--    <p>وثيقة رسمية معتمدة ومقبولة نهائياً</p>--}}
{{--</div>--}}

{{--<div class="section-title">1. معلومات عامة عن الطلب</div>--}}

{{--<table>--}}
{{--    <tr>--}}
{{--        <th>رقم الاستمارة الرسمية</th>--}}
{{--        <td>#FORM-{{ $form->id }}</td>--}}
{{--    </tr>--}}

{{--    ```--}}
{{--    <tr>--}}
{{--        <th>رقم طلب إعادة الإعمار الأصلي</th>--}}
{{--        <td>#REQ-{{ $form->reconstruction_request_id }}</td>--}}
{{--    </tr>--}}

{{--    <tr>--}}
{{--        <th>حالة الاعتماد في النظام</th>--}}
{{--        <td>مقبولة وموثقة نهائياً ({{ $form->status }})</td>--}}
{{--    </tr>--}}
{{--    ```--}}

{{--</table>--}}

{{--<div class="section-title">2. التفاصيل الفنية والإنشائية للمبنى</div>--}}

{{--<table>--}}
{{--    <tr>--}}
{{--        <th>وصف أعمال البناء المقررة</th>--}}
{{--        <td>{{ $form->building_description }}</td>--}}
{{--    </tr>--}}

{{--    ```--}}
{{--    <tr>--}}
{{--        <th>مدة التنفيذ والتسليم المتوقعة</th>--}}
{{--        <td>{{ $form->execution_duration }}</td>--}}
{{--    </tr>--}}

{{--    <tr>--}}
{{--        <th>فترة الضمان الممنوحة من المتعهد</th>--}}
{{--        <td>{{ $form->warranty_period }}</td>--}}
{{--    </tr>--}}
{{--    ```--}}

{{--</table>--}}

{{--<div class="section-title">3. الكشف المالي التفصيلي وتحليل الأسعار</div>--}}

{{--<table class="cost-table">--}}
{{--    <thead>--}}
{{--    <tr>--}}
{{--        <th>تكلفة المواد الإنشائية الأساسية</th>--}}
{{--        <th>تكلفة الأيدي العاملة والتنفيذ</th>--}}
{{--        <th>هامش ربح جهة التعهد (المقاول)</th>--}}
{{--    </tr>--}}
{{--    </thead>--}}

{{--    ```--}}
{{--    <tbody>--}}
{{--    <tr>--}}
{{--        <td>{{ number_format($form->materials_cost, 2) }} د.أ</td>--}}
{{--        <td>{{ number_format($form->labor_cost, 2) }} د.أ</td>--}}
{{--        <td>{{ number_format($form->profit, 2) }} د.أ</td>--}}
{{--    </tr>--}}

{{--    <tr class="total-row">--}}
{{--        <td colspan="2" style="text-align: left; padding-left: 15px;">--}}
{{--            إجمالي التكلفة الكلية المعتمدة للمشروع:--}}
{{--        </td>--}}

{{--        <td>{{ number_format($form->total_cost, 2) }} د.أ</td>--}}
{{--    </tr>--}}
{{--    </tbody>--}}
{{--    ```--}}

{{--</table>--}}

{{--<div class="section-title">4. جدول المواد الإنشائية المعتمدة</div>--}}

{{--<table class="cost-table">--}}
{{--    <thead>--}}
{{--    <tr>--}}
{{--        <th>اسم المادة</th>--}}
{{--        <th>نوع المادة</th>--}}
{{--        <th>الكمية</th>--}}
{{--        <th>الوحدة</th>--}}
{{--        <th>سعر الوحدة</th>--}}
{{--        <th>السعر الإجمالي</th>--}}
{{--    </tr>--}}
{{--    </thead>--}}

{{--    ```--}}
{{--    <tbody>--}}

{{--    @forelse($form->materials as $material)--}}
{{--        <tr>--}}
{{--            <td>{{ $material->material_name }}</td>--}}
{{--            <td>{{ $material->material_type }}</td>--}}
{{--            <td>{{ $material->quantity }}</td>--}}
{{--            <td>{{ $material->unit }}</td>--}}
{{--            <td>{{ number_format($material->unit_price, 2) }} د.أ</td>--}}
{{--            <td>{{ number_format($material->total_price, 2) }} د.أ</td>--}}
{{--        </tr>--}}
{{--    @empty--}}
{{--        <tr>--}}
{{--            <td colspan="6">--}}
{{--                لا توجد مواد مسجلة لهذه الاستمارة--}}
{{--            </td>--}}
{{--        </tr>--}}
{{--    @endforelse--}}

{{--    </tbody>--}}
{{--    ```--}}

{{--</table>--}}

{{--<div class="section-title">5. الملاحظات والاعتمادات الرسمية للأطراف</div>--}}

{{--<p style="margin-bottom: 2px; font-weight: bold; color: #2b6cb0;">--}}
{{--    ملاحظات واعتماد المهندس المدقق:--}}
{{--</p>--}}

{{--<div class="notes-box">--}}
{{--    {{ $form->engineer_notes ?? 'تمت المراجعة والقبول الفني والإنشائي من قِبل المهندس المختص دون أي ملاحظات.' }}--}}
{{--</div>--}}

{{--<p style="margin-bottom: 2px; font-weight: bold; color: #2b6cb0;">--}}
{{--    ملاحظات واعتماد المتضرر (المستفيد النهائي):--}}
{{--</p>--}}

{{--<div class="notes-box">--}}
{{--    {{ $form->user_notes ?? 'تمت الموافقة والاعتماد النهائي على بنود الاستمارة والأسعار من قِبل المستفيد للبدء بالتنفيذ.' }}--}}
{{--</div>--}}

{{--</body>--}}
{{--</html>--}}
