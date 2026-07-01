import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:renove_provider/providers/Contractor/contractor_provider.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key, required this.contractorId});
  final int contractorId;
  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  final key = GlobalKey<FormState>(),
      title = TextEditingController(),
      description = TextEditingController();
  List<XFile> images = [];
  String status = 'completed';
  double progress = 100;
  @override
  Widget build(BuildContext context) {
    final p = context.watch<ContractorProvider>();
    return Scaffold(
      appBar: AppBar(title: const Text('إضافة عمل')),
      body: Form(
        key: key,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            TextFormField(
              controller: title,
              decoration: const InputDecoration(
                labelText: 'عنوان العمل',
                border: OutlineInputBorder(),
              ),
              validator: _required,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: description,
              minLines: 3,
              maxLines: 6,
              decoration: const InputDecoration(
                labelText: 'الوصف',
                border: OutlineInputBorder(),
              ),
              validator: _required,
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              initialValue: status,
              decoration: const InputDecoration(
                labelText: 'الحالة',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'completed', child: Text('مكتمل')),
                DropdownMenuItem(
                  value: 'in_progress',
                  child: Text('قيد التنفيذ'),
                ),
              ],
              onChanged: (v) => setState(() {
                status = v!;
                if (status == 'completed') progress = 100;
              }),
            ),
            if (status == 'in_progress') ...[
              const SizedBox(height: 12),
              Text('نسبة الإنجاز: ${progress.round()}%'),
              Slider(
                value: progress.clamp(0, 99),
                min: 0,
                max: 99,
                divisions: 99,
                onChanged: (v) => setState(() => progress = v),
              ),
            ],
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () async {
                final picked = await ImagePicker().pickMultiImage(
                  imageQuality: 80,
                );
                if (picked.isNotEmpty) setState(() => images = picked);
              },
              icon: const Icon(Icons.add_photo_alternate_outlined),
              label: Text(
                images.isEmpty
                    ? 'اختيار صور العمل *'
                    : 'تم اختيار ${images.length} صورة',
              ),
            ),
            if (p.errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text(
                  p.errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            const SizedBox(height: 18),
            FilledButton(
              onPressed: p.isSaving
                  ? null
                  : () async {
                      if (!key.currentState!.validate()) return;
                      if (images.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('اختر صورة واحدة على الأقل'),
                          ),
                        );
                        return;
                      }
                      final ok = await p.createPost(
                        title: title.text.trim(),
                        description: description.text.trim(),
                        status: status,
                        progress: progress.round(),
                        images: images,
                        contractorId: widget.contractorId,
                      );
                      if (ok && mounted) Navigator.pop(context);
                    },
              child: p.isSaving
                  ? const SizedBox.square(
                      dimension: 22,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('نشر العمل'),
            ),
          ],
        ),
      ),
    );
  }

  String? _required(String? v) =>
      v == null || v.trim().isEmpty ? 'هذا الحقل مطلوب' : null;
}
