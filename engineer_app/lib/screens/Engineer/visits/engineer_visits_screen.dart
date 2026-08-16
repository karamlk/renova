import 'package:engineer_app/extras/theme.dart';
import 'package:engineer_app/models/site_visit_model.dart';
import 'package:engineer_app/providers/auth_provider.dart';
import 'package:engineer_app/providers/engineer/visits_provider.dart';
import 'package:engineer_app/providers/engineer/no_show_warnings_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EngineerVisitsScreen extends StatelessWidget {
  const EngineerVisitsScreen({super.key});

  Future<void> _refresh(BuildContext context) async {
    final token = context.read<AuthProvider>().token;
    if (token == null) return;

    final error = await context.read<VisitsProvider>().fetchVisits(token);
    if (error != null && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
    }
  }
  Future<void> _respond(
    BuildContext context,
    SiteVisitModel visit,
    bool accepted,
  ) async {
    final token = context.read<AuthProvider>().token;
    if (token == null) return;
    final error = await context.read<VisitsProvider>().respond(
      token,
      visit,
      accepted,
    );
    if (context.mounted)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error ?? 'تم تحديث حالة الزيارة.')),
      );
  }

  Future<void> _reportNoShow(
    BuildContext context,
    SiteVisitModel visit,
    String reportedRole,
  ) async {
    final token = context.read<AuthProvider>().token;
    if (token == null) return;

    final warningsProvider = context.read<NoShowWarningsProvider>();
    final error = await warningsProvider.report(
      token,
      siteVisitId: visit.id,
      reportedRole: reportedRole,
    );
    if (!context.mounted) return;
    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
      return;
    }

    final warning = warningsProvider.lastCreatedWarning;
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('تم تسجيل التحذير'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(warningsProvider.lastMessage ?? 'تم تسجيل التحذير بنجاح'),
            const SizedBox(height: 12),
            Text("رقم التحذير: ${warning?.id ?? '—'}"),
            Text(
              "السبب: ${warning?.reason ?? 'عدم الحضور إلى الزيارة الميدانية'}",
            ),
            Text(
              "الدور المبلّغ عنه: ${warning?.reportedRoleLabel ?? (reportedRole == 'user' ? 'المستفيد' : 'المتعهد')}",
            ),
            Text("التاريخ: ${warning?.createdAt ?? '—'}"),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('حسنًا'),
          ),
        ],
      ),
    );
  }

  void _showReportDialog(BuildContext context, SiteVisitModel visit) {
    var reportedRole = 'user';
    showDialog<void>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (_, setDialogState) => AlertDialog(
          title: const Text('الإبلاغ عن غياب'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('حدد الطرف الذي لم يحضر الزيارة:'),
              RadioListTile<String>(
                value: 'user',
                groupValue: reportedRole,
                title: const Text('المستفيد'),
                onChanged: (value) => setDialogState(
                  () => reportedRole = value ?? 'user',
                ),
              ),
              RadioListTile<String>(
                value: 'contractor',
                groupValue: reportedRole,
                title: const Text('المتعهد'),
                onChanged: (value) => setDialogState(
                  () => reportedRole = value ?? 'contractor',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('إلغاء'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                _reportNoShow(context, visit, reportedRole);
              },
              child: const Text('تسجيل التحذير'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('الزيارات الميدانية')),
    body: RefreshIndicator(
      onRefresh: () => _refresh(context),
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
        const Text(
          'الزيارات المسندة إليك',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: primarycolor2,
          ),
        ),
        const SizedBox(height: 10),
        ...context.watch<VisitsProvider>().visits.map(
          (visit) => _card(context, visit),
        ),
        ],
      ),
    ),
  );
  Widget _card(BuildContext context, SiteVisitModel visit) => Card(
    child: Padding(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            visit.title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text('المستفيد: ${visit.user}'),
          Text('الموقع: ${visit.location}'),
          Text('المتعهد: ${visit.contractor}'),
          Text('الموعد: ${visit.day} • ${visit.startTime} - ${visit.endTime}'),
          if (visit.status == 'بانتظار الموافقة')
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => _respond(context, visit, false),
                      child: const Text('رفض الزيارة'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primarycolor2,
                        foregroundColor: primarycolor1,
                      ),
                      onPressed: () => _respond(context, visit, true),
                      child: const Text('قبول الزيارة'),
                    ),
                  ),
                ],
              ),
            ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: OutlinedButton.icon(
              onPressed: () => _showReportDialog(context, visit),
              icon: const Icon(Icons.warning_amber_outlined),
              label: const Text('الإبلاغ عن غياب'),
            ),
          ),
        ],
      ),
    ),
  );
}
