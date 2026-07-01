import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:renove_provider/providers/Contractor/show_profile_provider.dart';
import 'package:renove_provider/screens/Contractor/profile/contractor_profile_form_screen.dart';

class ShowProfileContractorScreen extends StatelessWidget {
  const ShowProfileContractorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ContractorShowProfileProvider>();
    final profile = provider.profile;
    return Scaffold(
      appBar: AppBar(title: const Text('الملف الشخصي'), centerTitle: true),
      floatingActionButton: profile == null
          ? null
          : FloatingActionButton.extended(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ContractorProfileFormScreen(),
                ),
              ),
              icon: const Icon(Icons.edit),
              label: const Text('تعديل'),
            ),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : profile == null
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('لا توجد بيانات للملف الشخصي'),
                  TextButton(
                    onPressed: provider.fetchProfile,
                    child: const Text('إعادة المحاولة'),
                  ),
                ],
              ),
            )
          : RefreshIndicator(
              onRefresh: provider.fetchProfile,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 100),
                children: [
                  Center(child: _ProfileAvatar(provider: provider)),
                  const SizedBox(height: 14),
                  Text(
                    '${profile.firstName} ${profile.lastName}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (profile.location?.isNotEmpty == true) ...[
                    const SizedBox(height: 5),
                    Text(
                      profile.location!,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                  ],
                  const SizedBox(height: 20),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          _InfoRow(
                            icon: Icons.email_outlined,
                            title: 'البريد',
                            value: profile.email,
                          ),
                          const Divider(),
                          _InfoRow(
                            icon: Icons.phone_outlined,
                            title: 'الهاتف',
                            value: profile.phone ?? '-',
                          ),
                          const Divider(),
                          _InfoRow(
                            icon: Icons.business_outlined,
                            title: 'الشركة',
                            value: profile.companyName ?? '-',
                          ),
                          const Divider(),
                          _InfoRow(
                            icon: Icons.verified_outlined,
                            title: 'الحالة',
                            value: _status(profile.status),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (provider.errorMessage != null) ...[
                    const SizedBox(height: 12),
                    Text(
                      provider.errorMessage!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ],
                ],
              ),
            ),
    );
  }

  static String _status(String value) => switch (value.toLowerCase()) {
    'approved' => 'مقبول',
    'pending' => 'قيد المراجعة',
    'rejected' => 'مرفوض',
    _ => value.isEmpty ? '-' : value,
  };
}

class _ProfileAvatar extends StatelessWidget {
  const _ProfileAvatar({required this.provider});
  final ContractorShowProfileProvider provider;

  @override
  Widget build(BuildContext context) {
    final url = provider.resolveMediaUrl(provider.profile?.imageUrl);
    final Widget image;
    if (provider.imageBytes != null) {
      image = Image.memory(
        provider.imageBytes!,
        width: 104,
        height: 104,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => _fallback(),
      );
    } else if (url.isNotEmpty) {
      image = Image.network(
        url,
        width: 104,
        height: 104,
        fit: BoxFit.cover,
        webHtmlElementStrategy: WebHtmlElementStrategy.prefer,
        errorBuilder: (_, _, _) => _fallback(),
      );
    } else {
      image = _fallback();
    }
    return ClipOval(child: SizedBox.square(dimension: 104, child: image));
  }

  Widget _fallback() => ColoredBox(
    color: Colors.grey.shade200,
    child: const Icon(Icons.person, size: 48, color: Colors.grey),
  );
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.title,
    required this.value,
  });
  final IconData icon;
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Icon(icon, size: 20),
      const SizedBox(width: 8),
      Text(title),
      const SizedBox(width: 12),
      Expanded(
        child: Text(
          value,
          textAlign: TextAlign.end,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    ],
  );
}
