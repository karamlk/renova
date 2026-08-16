import 'dart:io';

import 'package:engineer_app/extras/theme.dart';
import 'package:engineer_app/models/engineer_profile_model.dart';
import 'package:engineer_app/providers/auth_provider.dart';
import 'package:engineer_app/providers/engineer/profile_provider.dart';
import 'package:engineer_app/screens/Engineer/audit/form_pdf_viewer_screen.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ShowProfileEngineerScreen extends StatefulWidget {
  const ShowProfileEngineerScreen({super.key});

  @override
  State<ShowProfileEngineerScreen> createState() =>
      _ShowProfileEngineerScreenState();
}

class _ShowProfileEngineerScreenState extends State<ShowProfileEngineerScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _fetchProfile());
  }

  Future<void> _fetchProfile() async {
    final token = context.read<AuthProvider>().token;
    if (token != null) await context.read<ProfileProvider>().fetch(token);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ملفك الشخصي')),
      body: Consumer<ProfileProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading && provider.profile == null) {
            return const Center(child: CircularProgressIndicator());
          }
          final profile = provider.profile;
          if (profile == null) {
            return Center(
              child: ElevatedButton(
                onPressed: _fetchProfile,
                child: const Text('إعادة المحاولة'),
              ),
            );
          }
          return RefreshIndicator(
            onRefresh: _fetchProfile,
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                _profileHeader(profile),
                const SizedBox(height: 20),
                _section('البيانات الشخصية'),
                _info('الاسم الأول', profile.firstName),
                _info('اسم العائلة', profile.lastName),
                _info('البريد الإلكتروني', profile.email),
                _info('رقم الهاتف', profile.phone),
                _info('الموقع', profile.location),
                const SizedBox(height: 14),
                _section('البيانات المهنية'),
                _info('الاختصاص', profile.specialization),
                _info('رقم النقابة', profile.syndicateNumber),
                _info('الدرجة العلمية', profile.degree),
                _info('سنوات الخبرة', '${profile.yearsOfExperience}'),
                _info('مناطق التغطية', profile.coveredZones),
                _info('نبذة', profile.bio ?? '—'),
                const SizedBox(height: 14),
                _section('الوثائق'),
                _document('بطاقة النقابة', profile.syndicateCardUrl),
                _document('ملف الشهادة', profile.certificateUrl),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _profileHeader(EngineerProfileModel profile) {
    final hasImage = profile.imageUrl != null && profile.imageUrl!.isNotEmpty;
    return Column(
      children: [
        ClipOval(
          child: Container(
            width: 140,
            height: 140,
            color: primarycolor2,
            child: hasImage
                ? Image.network(
                    '${profile.imageUrl!}?refresh=${DateTime.now().millisecondsSinceEpoch}',
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const Icon(
                      Icons.person,
                      size: 75,
                      color: primarycolor1,
                    ),
                    loadingBuilder: (_, child, progress) {
                      if (progress == null) return child;
                      return const Center(
                        child: CircularProgressIndicator(color: primarycolor1),
                      );
                    },
                  )
                : const Icon(Icons.person, size: 75, color: primarycolor1),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          '${profile.firstName} ${profile.lastName}',
          style: const TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: primarycolor2,
            foregroundColor: primarycolor1,
          ),
          onPressed: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => EditEngineerProfileScreen(profile: profile),
              ),
            );
            if (mounted) await _fetchProfile();
          },
          icon: const Icon(Icons.edit),
          label: const Text('تعديل'),
        ),
      ],
    );
  }

  Widget _section(String title) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: primarycolor2,
      ),
    ),
  );
  Widget _info(String label, String value) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(label),
        const SizedBox(height: 5),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: softSurface,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(value),
        ),
      ],
    ),
  );
  Widget _document(String title, String? url) {
    final available = url != null && url.isNotEmpty;
    final isImage = available && _isImageDocument(url!);
    return Card(
      child: ListTile(
        leading: available && isImage
            ? ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Image.network(
                  url!,
                  width: 48,
                  height: 48,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const Icon(
                    Icons.image_not_supported_outlined,
                    color: primarycolor2,
                  ),
                ),
              )
            : const Icon(
                Icons.insert_drive_file_outlined,
                color: primarycolor2,
              ),
        title: Text(title),
        subtitle: Text(available ? 'اضغط لعرض الملف' : 'لا يوجد ملف مرفق'),
        trailing: available ? const Icon(Icons.open_in_new) : null,
        onTap: available ? () => _previewDocument(title, url!) : null,
      ),
    );
  }

  bool _isImageDocument(String url) {
    final path = Uri.tryParse(url)?.path.toLowerCase() ?? url.toLowerCase();
    return path.endsWith('.jpg') ||
        path.endsWith('.jpeg') ||
        path.endsWith('.png') ||
        path.endsWith('.webp');
  }

  Future<void> _previewDocument(String title, String url) async {
    if (!_isImageDocument(url)) {
      final token = context.read<AuthProvider>().token;
      if (token == null || !mounted) return;
      await Navigator.push<void>(
        context,
        MaterialPageRoute(
          builder: (_) => FormPdfViewerScreen(pdfUrl: url, token: token),
        ),
      );
      return;
    }

    if (!mounted) return;
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => Dialog(
        insetPadding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 8, 4),
              child: Row(
                children: [
                  IconButton(
                    tooltip: 'فتح خارج التطبيق',
                    icon: const Icon(Icons.open_in_new),
                    onPressed: () => _openAttachment(url),
                  ),
                  Expanded(
                    child: Text(
                      title,
                      textAlign: TextAlign.right,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  IconButton(
                    tooltip: 'إغلاق',
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(dialogContext),
                  ),
                ],
              ),
            ),
            Flexible(
              child: InteractiveViewer(
                minScale: 0.8,
                maxScale: 4,
                child: Image.network(
                  url,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => const Padding(
                    padding: EdgeInsets.all(32),
                    child: Text('تعذر تحميل صورة الوثيقة.'),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openAttachment(String url) async {
    final uri = Uri.tryParse(url);
    if (uri == null ||
        !await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('تعذر فتح الملف.')));
      }
    }
  }
}

class EditEngineerProfileScreen extends StatefulWidget {
  const EditEngineerProfileScreen({super.key, required this.profile});
  final EngineerProfileModel profile;

  @override
  State<EditEngineerProfileScreen> createState() =>
      _EditEngineerProfileScreenState();
}

class _EditEngineerProfileScreenState extends State<EditEngineerProfileScreen> {
  late final Map<String, TextEditingController> controllers;
  File? personalImage;
  File? syndicateCard;
  File? certificateFile;

  @override
  void initState() {
    super.initState();
    final p = widget.profile;
    controllers = {
      'first_name': TextEditingController(text: p.firstName),
      'last_name': TextEditingController(text: p.lastName),
      'phone': TextEditingController(text: p.phone),
      'location': TextEditingController(text: p.location),
      'specialization': TextEditingController(text: p.specialization),
      'syndicate_number': TextEditingController(text: p.syndicateNumber),
      'degree': TextEditingController(text: p.degree),
      'years_of_experience': TextEditingController(
        text: p.yearsOfExperience.toString(),
      ),
      'covered_zones': TextEditingController(text: p.coveredZones),
      'bio': TextEditingController(text: p.bio ?? ''),
    };
  }

  @override
  void dispose() {
    for (final controller in controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _pickPersonalImage() async {
    final file = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (file != null && mounted)
      setState(() => personalImage = File(file.path));
  }

  Future<void> _pickSyndicateCard() async {
    final file = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    if (file != null && mounted)
      setState(() => syndicateCard = File(file.path));
  }

  Future<void> _pickCertificate() async {
    final selected = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'png'],
    );
    final path = selected?.files.single.path;
    if (path != null && mounted) setState(() => certificateFile = File(path));
  }

  Future<void> _save() async {
    if (int.tryParse(controllers['years_of_experience']!.text) == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('سنوات الخبرة يجب أن تكون رقماً.')),
      );
      return;
    }
    final token = context.read<AuthProvider>().token;
    if (token == null) return;
    final fields = controllers.map(
      (key, value) => MapEntry(key, value.text.trim()),
    );
    final message = await context.read<ProfileProvider>().update(
      token,
      fields,
      image: personalImage,
      syndicateCardImage: syndicateCard,
      certificateFile: certificateFile,
    );
    if (!mounted) return;
    if (message == null)
      Navigator.pop(context);
    else
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final saving = context.watch<ProfileProvider>().isSaving;
    return Scaffold(
      appBar: AppBar(title: const Text('تعديل الملف الشخصي')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Center(
            child: GestureDetector(
              onTap: _pickPersonalImage,
              child: CircleAvatar(
                radius: 55,
                backgroundColor: primarycolor2,
                backgroundImage: personalImage == null
                    ? null
                    : FileImage(personalImage!),
                child: personalImage == null
                    ? const Icon(
                        Icons.add_a_photo_outlined,
                        color: primarycolor1,
                        size: 35,
                      )
                    : null,
              ),
            ),
          ),
          const SizedBox(height: 8),
          const Text('اضغط لاختيار صورة شخصية', textAlign: TextAlign.center),
          const SizedBox(height: 20),
          ...controllers.entries.map(
            (entry) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: TextField(
                controller: entry.value,
                keyboardType: entry.key == 'years_of_experience'
                    ? TextInputType.number
                    : TextInputType.text,
                decoration: InputDecoration(
                  labelText: _label(entry.key),
                  border: const OutlineInputBorder(),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          _fileButton(
            'صورة بطاقة النقابة',
            syndicateCard,
            _pickSyndicateCard,
            Icons.badge_outlined,
          ),
          const SizedBox(height: 10),
          _fileButton(
            'ملف الشهادة (PDF أو صورة)',
            certificateFile,
            _pickCertificate,
            Icons.picture_as_pdf_outlined,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(52),
              backgroundColor: primarycolor2,
              foregroundColor: primarycolor1,
            ),
            onPressed: saving ? null : _save,
            child: saving
                ? const CircularProgressIndicator(color: primarycolor1)
                : const Text('حفظ التعديلات'),
          ),
        ],
      ),
    );
  }

  Widget _fileButton(
    String title,
    File? file,
    VoidCallback onTap,
    IconData icon,
  ) => OutlinedButton.icon(
    onPressed: onTap,
    icon: Icon(icon),
    label: Text(
      file == null
          ? title
          : 'تم اختيار: ${file.path.split(Platform.pathSeparator).last}',
    ),
  );
  String _label(String key) => {
    'first_name': 'الاسم الأول',
    'last_name': 'اسم العائلة',
    'phone': 'رقم الهاتف',
    'location': 'الموقع',
    'specialization': 'الاختصاص',
    'syndicate_number': 'رقم النقابة',
    'degree': 'الدرجة العلمية',
    'years_of_experience': 'سنوات الخبرة',
    'covered_zones': 'مناطق التغطية',
    'bio': 'نبذة',
  }[key]!;
}
