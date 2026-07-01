import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:renove_provider/providers/Contractor/show_profile_provider.dart';

class ContractorProfileFormScreen extends StatefulWidget {
  const ContractorProfileFormScreen({super.key, this.isFirstSetup = false});
  final bool isFirstSetup;
  @override
  State<ContractorProfileFormScreen> createState() =>
      _ContractorProfileFormScreenState();
}

class _ContractorProfileFormScreenState
    extends State<ContractorProfileFormScreen> {
  final formKey = GlobalKey<FormState>();
  final first = TextEditingController(),
      last = TextEditingController(),
      phone = TextEditingController(),
      location = TextEditingController(),
      company = TextEditingController();
  XFile? avatar, record;

  @override
  void initState() {
    super.initState();
    final p = context.read<ContractorShowProfileProvider>().profile;
    if (p != null) {
      first.text = p.firstName;
      last.text = p.lastName;
      phone.text = p.phone ?? '';
      location.text = p.location ?? '';
      company.text = p.companyName ?? '';
    }
  }

  Future<XFile?> pick() async {
    return ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ContractorShowProfileProvider>();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.isFirstSetup ? 'إكمال ملف المقاول' : 'تعديل الملف الشخصي',
        ),
      ),
      body: Form(
        key: formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const Icon(Icons.badge_outlined, size: 64),
            const SizedBox(height: 12),
            _field(first, 'الاسم الأول', required: true),
            _field(last, 'الاسم الأخير', required: true),
            _field(phone, 'رقم الهاتف', keyboard: TextInputType.phone),
            _field(location, 'الموقع'),
            _field(company, 'اسم الشركة'),
            OutlinedButton.icon(
              onPressed: () async {
                final f = await pick();
                if (f != null) setState(() => avatar = f);
              },
              icon: const Icon(Icons.person),
              label: Text(
                avatar == null ? 'اختيار الصورة الشخصية' : 'تم اختيار الصورة',
              ),
            ),
            const SizedBox(height: 10),
            OutlinedButton.icon(
              onPressed: () async {
                final f = await pick();
                if (f != null) setState(() => record = f);
              },
              icon: const Icon(Icons.description),
              label: Text(
                record == null
                    ? 'اختيار صورة السجل التجاري${widget.isFirstSetup ? ' *' : ''}'
                    : 'تم اختيار السجل التجاري',
              ),
            ),
            if (provider.errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text(
                  provider.errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: provider.isSaving
                  ? null
                  : () async {
                      if (!formKey.currentState!.validate()) return;
                      final ok = await provider.saveProfile(
                        firstName: first.text.trim(),
                        lastName: last.text.trim(),
                        phone: phone.text.trim(),
                        location: location.text.trim(),
                        companyName: company.text.trim(),
                        avatar: avatar,
                        commercialRecord: record,
                      );
                      if (ok && mounted) Navigator.pop(context, true);
                    },
              child: provider.isSaving
                  ? const SizedBox.square(
                      dimension: 22,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('حفظ وإرسال'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _field(
    TextEditingController c,
    String label, {
    bool required = false,
    TextInputType? keyboard,
  }) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: TextFormField(
      controller: c,
      keyboardType: keyboard,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      validator: required
          ? (v) => v == null || v.trim().isEmpty ? 'هذا الحقل مطلوب' : null
          : null,
    ),
  );
}
