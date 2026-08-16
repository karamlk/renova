import 'package:engineer_app/extras/theme.dart';
import 'package:engineer_app/models/engineer_form_model.dart';
import 'package:engineer_app/providers/auth_provider.dart';
import 'package:engineer_app/providers/engineer/forms_provider.dart';
import 'package:engineer_app/screens/Engineer/audit/engineer_form_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuditIndexScreen extends StatelessWidget {
  const AuditIndexScreen({super.key});

  Future<void> _refresh(BuildContext context) async {
    final token = context.read<AuthProvider>().token;
    if (token == null) return;

    final error = await context.read<FormsProvider>().fetchForms(token);
    if (error != null && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
    }
  }

  Future<void> _openDetails(
    BuildContext context,
    EngineerFormModel form,
  ) async {
    final wasReviewed = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => EngineerFormDetailsScreen(form: form),
      ),
    );

    if (wasReviewed == true && context.mounted) {
      await _refresh(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final forms = context.watch<FormsProvider>().forms;

    return RefreshIndicator(
      onRefresh: () => _refresh(context),
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'تدقيق الاستمارات',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22,
              color: primarycolor2,
            ),
          ),
          const SizedBox(height: 5),
          const Text('الاستمارات المسندة إليك للمراجعة'),
          const SizedBox(height: 12),
          if (forms.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(30),
                child: Text('لا توجد استمارات بانتظار المراجعة.'),
              ),
            ),
          ...forms.map((form) => _formCard(context, form)),
        ],
      ),
    );
  }

  Widget _formCard(BuildContext context, EngineerFormModel form) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => _openDetails(context, form),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const CircleAvatar(
                    backgroundColor: primarycolor2,
                    child: Icon(
                      Icons.description_outlined,
                      color: primarycolor1,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'استمارة رقم #${form.id}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Text(form.status, style: const TextStyle(fontSize: 11)),
                ],
              ),
              const SizedBox(height: 10),
              Text('المستفيد: ${form.beneficiary}'),
              Text('المتعهد: ${form.contractor}'),
              Text(
                'إجمالي التكلفة: ${form.totalCost.toStringAsFixed(0)} ل.س',
              ),
              Text('تاريخ الإنشاء: ${form.createdAt}'),
              const SizedBox(height: 8),
              const Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text('عرض التفاصيل والتدقيق'),
                  SizedBox(width: 4),
                  Icon(Icons.chevron_left),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
