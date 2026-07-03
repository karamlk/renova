<!DOCTYPE html>

<html lang="ar" dir="rtl">
<head>
    <meta charset="UTF-8">
    <title>استمارة تكاليف أعمال البناء</title>

    ```
    <style>
        body {
            font-family: sans-serif;
            direction: rtl;
            text-align: right;
            color: #2d3748;
            line-height: 1.6;
        }

        .header {
            border-bottom: 3px solid #2b6cb0;
            padding-bottom: 10px;
            margin-bottom: 25px;
            text-align: center;
        }

        .header h1 {
            color: #2b6cb0;
            font-size: 22pt;
            margin: 0 0 5px 0;
        }

        .header p {
            color: #4a5568;
            font-size: 12pt;
            margin: 0;
        }

        .section-title {
            font-size: 14pt;
            color: #2b6cb0;
            border-bottom: 1px solid #e2e8f0;
            padding-bottom: 5px;
            margin-top: 25px;
            font-weight: bold;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 10px;
            margin-bottom: 15px;
        }

        th,
        td {
            border: 1px solid #cbd5e0;
            padding: 10px;
            font-size: 11pt;
            text-align: right;
        }

        th {
            background-color: #ebf8ff;
            color: #2b6cb0;
            width: 30%;
            font-weight: bold;
        }

        .cost-table th {
            width: auto;
            text-align: center;
        }

        .cost-table td {
            text-align: center;
        }

        .total-row {
            background-color: #e2e8f0;
            font-weight: bold;
        }

        .notes-box {
            border: 1px solid #cbd5e0;
            background-color: #f7fafc;
            padding: 12px;
            font-size: 11pt;
            margin-top: 8px;
            margin-bottom: 15px;
        }
    </style>
    ```

</head>
<body>

<div class="header">
    <h1>استمارة تكاليف أعمال البناء وإعادة الإعمار</h1>
    <p>وثيقة رسمية معتمدة ومقبولة نهائياً</p>
</div>

<div class="section-title">1. معلومات عامة عن الطلب</div>

<table>
    <tr>
        <th>رقم الاستمارة الرسمية</th>
        <td>#FORM-{{ $form->id }}</td>
    </tr>

    ```
    <tr>
        <th>رقم طلب إعادة الإعمار الأصلي</th>
        <td>#REQ-{{ $form->reconstruction_request_id }}</td>
    </tr>

    <tr>
        <th>حالة الاعتماد في النظام</th>
        <td>مقبولة وموثقة نهائياً ({{ $form->status }})</td>
    </tr>
    ```

</table>

<div class="section-title">2. التفاصيل الفنية والإنشائية للمبنى</div>

<table>
    <tr>
        <th>وصف أعمال البناء المقررة</th>
        <td>{{ $form->building_description }}</td>
    </tr>

    ```
    <tr>
        <th>مدة التنفيذ والتسليم المتوقعة</th>
        <td>{{ $form->execution_duration }}</td>
    </tr>

    <tr>
        <th>فترة الضمان الممنوحة من المتعهد</th>
        <td>{{ $form->warranty_period }}</td>
    </tr>
    ```

</table>

<div class="section-title">3. الكشف المالي التفصيلي وتحليل الأسعار</div>

<table class="cost-table">
    <thead>
    <tr>
        <th>تكلفة المواد الإنشائية الأساسية</th>
        <th>تكلفة الأيدي العاملة والتنفيذ</th>
        <th>هامش ربح جهة التعهد (المقاول)</th>
    </tr>
    </thead>

    ```
    <tbody>
    <tr>
        <td>{{ number_format($form->materials_cost, 2) }} د.أ</td>
        <td>{{ number_format($form->labor_cost, 2) }} د.أ</td>
        <td>{{ number_format($form->profit, 2) }} د.أ</td>
    </tr>

    <tr class="total-row">
        <td colspan="2" style="text-align: left; padding-left: 15px;">
            إجمالي التكلفة الكلية المعتمدة للمشروع:
        </td>

        <td>{{ number_format($form->total_cost, 2) }} د.أ</td>
    </tr>
    </tbody>
    ```

</table>

<div class="section-title">4. جدول المواد الإنشائية المعتمدة</div>

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

    ```
    <tbody>

    @forelse($form->materials as $material)
        <tr>
            <td>{{ $material->material_name }}</td>
            <td>{{ $material->material_type }}</td>
            <td>{{ $material->quantity }}</td>
            <td>{{ $material->unit }}</td>
            <td>{{ number_format($material->unit_price, 2) }} د.أ</td>
            <td>{{ number_format($material->total_price, 2) }} د.أ</td>
        </tr>
    @empty
        <tr>
            <td colspan="6">
                لا توجد مواد مسجلة لهذه الاستمارة
            </td>
        </tr>
    @endforelse

    </tbody>
    ```

</table>

<div class="section-title">5. الملاحظات والاعتمادات الرسمية للأطراف</div>

<p style="margin-bottom: 2px; font-weight: bold; color: #2b6cb0;">
    ملاحظات واعتماد المهندس المدقق:
</p>

<div class="notes-box">
    {{ $form->engineer_notes ?? 'تمت المراجعة والقبول الفني والإنشائي من قِبل المهندس المختص دون أي ملاحظات.' }}
</div>

<p style="margin-bottom: 2px; font-weight: bold; color: #2b6cb0;">
    ملاحظات واعتماد المتضرر (المستفيد النهائي):
</p>

<div class="notes-box">
    {{ $form->user_notes ?? 'تمت الموافقة والاعتماد النهائي على بنود الاستمارة والأسعار من قِبل المستفيد للبدء بالتنفيذ.' }}
</div>

</body>
</html>
