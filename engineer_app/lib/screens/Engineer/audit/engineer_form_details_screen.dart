import 'package:engineer_app/extras/theme.dart';
import 'package:engineer_app/models/engineer_form_details_model.dart';
import 'package:engineer_app/models/engineer_form_model.dart';
import 'package:engineer_app/providers/auth_provider.dart';
import 'package:engineer_app/providers/engineer/forms_provider.dart';
import 'package:engineer_app/screens/Engineer/audit/form_pdf_viewer_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EngineerFormDetailsScreen extends StatefulWidget {
  const EngineerFormDetailsScreen({super.key, required this.form});

  final EngineerFormModel form;

  @override
  State<EngineerFormDetailsScreen> createState() =>
      _EngineerFormDetailsScreenState();
}

class _EngineerFormDetailsScreenState extends State<EngineerFormDetailsScreen> {
  EngineerFormDetailsModel? _details;
  String? _error;
  bool _isLoading = true;
  bool _isReviewing = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  Future<void> _load() async {
    final token = context.read<AuthProvider>().token;
    if (token == null) return;

    setState(() {
      _isLoading = true;
      _error = null;
    });

    final provider = context.read<FormsProvider>();
    final details = await provider.fetchDetails(token, widget.form.id);
    if (!mounted) return;

    setState(() {
      _details = details;
      _error = provider.detailsError;
      _isLoading = false;
    });
  }

  Future<void> _review(bool approved, {String? notes}) async {
    final token = context.read<AuthProvider>().token;
    if (token == null) return;

    setState(() => _isReviewing = true);
    final error = await context.read<FormsProvider>().review(
      token,
      widget.form,
      approved,
      notes: notes,
    );
    if (!mounted) return;

    setState(() => _isReviewing = false);
    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(approved ? 'تم اعتماد الاستمارة.' : 'تم رفض الاستمارة.'),
      ),
    );
    Navigator.pop(context, true);
  }

  void _showRejectDialog() {
    final notesController = TextEditingController();
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('رفض الاستمارة'),
        content: TextField(
          controller: notesController,
          minLines: 3,
          maxLines: 5,
          decoration: const InputDecoration(
            hintText: 'اكتب ملاحظات الرفض، خمسة أحرف على الأقل',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              final notes = notesController.text.trim();
              if (notes.length < 5) return;
              Navigator.pop(dialogContext);
              _review(false, notes: notes);
            },
            child: const Text('تأكيد الرفض'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('تفاصيل الاستمارة #${widget.form.id}')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _details == null
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(_error ?? 'تعذر تحميل التفاصيل.'),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: _load,
                      child: const Text('إعادة المحاولة'),
                    ),
                  ],
                ),
              ),
            )
          : _content(_details!),
    );
  }

  Widget _content(EngineerFormDetailsModel details) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        _section('بيانات الاستمارة'),
        _info('الحالة', details.status),
        _section('المستفيد'),
        _info('الاسم', details.beneficiaryName),
        _info('رقم الهاتف', details.beneficiaryPhone),
        _section('المتعهد'),
        _info('الاسم', details.contractorName),
        _section('طلب إعادة الإعمار'),
        _info('العنوان', details.requestTitle),
        _info('الوصف', details.requestDescription),
        _info('الموقع', details.requestLocation),
        _info('نوع الطلب', details.requestType),
        _section('التفاصيل الفنية'),
        _info('وصف البناء', details.buildingDescription),
        _info('مدة التنفيذ', details.executionDuration),
        _info('مدة الكفالة', details.warrantyPeriod),
        _section('التكاليف'),
        _cost('تكلفة المواد', details.materialsCost),
        _cost('تكلفة العمالة', details.laborCost),
        _cost('الربح', details.profit),
        _cost('الإجمالي', details.totalCost),
        _section('المواد'),
        if (details.materials.isEmpty)
          const Padding(
            padding: EdgeInsets.only(bottom: 12),
            child: Text('لا توجد مواد مضافة لهذه الاستمارة.'),
          ),
        ...details.materials.map(_material),
        if (details.pdfUrl != null && details.pdfUrl!.isNotEmpty)
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.picture_as_pdf, color: primarycolor2),
            title: const Text('الملف المرفق PDF'),
            subtitle: const Text('عرض داخل التطبيق'),
            trailing: const Icon(Icons.visibility_outlined),
            onTap: () => _openPdfViewer(details.pdfUrl!),
          ),
        const SizedBox(height: 18),
        if (_isReviewing)
          const Center(child: CircularProgressIndicator())
        else
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _showRejectDialog,
                  child: const Text('رفض مع ملاحظات'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primarycolor2,
                    foregroundColor: primarycolor1,
                  ),
                  onPressed: () => _review(true),
                  child: const Text('موافقة'),
                ),
              ),
            ],
          ),
      ],
    );
  }

  Widget _section(String title) => Padding(
    padding: const EdgeInsets.only(top: 12, bottom: 8),
    child: Text(
      title,
      style: const TextStyle(
        color: primarycolor2,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    ),
  );

  Widget _info(String label, String value) => Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(label),
        const SizedBox(height: 4),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: softSurface,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(value.isEmpty ? '—' : value),
        ),
      ],
    ),
  );

  Widget _cost(String label, double value) => _info(
    label,
    '${value.toStringAsFixed(0)} ل.س',
  );

  Widget _material(ConstructionMaterialModel material) => Card(
    child: ListTile(
      title: Text(material.name),
      subtitle: Text(
        '${material.type} • ${material.quantity} ${material.unit}\n'
        'سعر الوحدة: ${material.unitPrice.toStringAsFixed(0)} ل.س',
      ),
      trailing: Text('${material.totalPrice.toStringAsFixed(0)} ل.س'),
    ),
  );

  Future<void> _openPdfViewer(String pdfUrl) async {
    final token = context.read<AuthProvider>().token;
    if (token == null) return;

    await Navigator.push<void>(
      context,
      MaterialPageRoute(
        builder: (_) => FormPdfViewerScreen(
          pdfUrl: pdfUrl,
          token: token,
        ),
      ),
    );
  }
}
