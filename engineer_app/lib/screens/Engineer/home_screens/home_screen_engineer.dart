import 'package:engineer_app/extras/theme.dart';
import 'package:engineer_app/providers/auth_provider.dart';
import 'package:engineer_app/providers/engineer/forms_provider.dart';
import 'package:engineer_app/providers/engineer/projects_provider.dart';
import 'package:engineer_app/providers/engineer/visits_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreenEngineer extends StatefulWidget {
  const HomeScreenEngineer({super.key});

  @override
  State<HomeScreenEngineer> createState() => _HomeScreenEngineerState();
}

class _HomeScreenEngineerState extends State<HomeScreenEngineer> {
  Future<void> _refresh() async {
    final token = context.read<AuthProvider>().token;
    if (token == null) return;

    await Future.wait([
      context.read<ProjectsProvider>().fetchProjects(token),
      context.read<FormsProvider>().fetchForms(token),
      context.read<VisitsProvider>().fetchVisits(token),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final projects = context.watch<ProjectsProvider>().projects;
    final forms = context.watch<FormsProvider>().forms;
    final visits = context.watch<VisitsProvider>().visits;
    return RefreshIndicator(
      onRefresh: _refresh,
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
        const Text(
          'مرحباً، أحمد',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: primarycolor2,
          ),
        ),
        const Text(
          'لوحة متابعة أعمالك الهندسية',
          style: TextStyle(color: Colors.black54),
        ),
        const SizedBox(height: 20),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: 1.6,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          children: [
            _counter(
              'زيارات بانتظار الرد',
              visits
                  .where((visit) => visit.status == 'بانتظار الموافقة')
                  .length
                  .toString(),
              Icons.event_available_outlined,
            ),
            _counter(
              'استمارات للتدقيق',
              forms
                  .where((form) => form.status == 'بانتظار المراجعة')
                  .length
                  .toString(),
              Icons.fact_check_outlined,
            ),
            _counter(
              'مشاريع نشطة',
              projects
                  .where((project) => project.status == 'نشط')
                  .length
                  .toString(),
              Icons.work_outline,
            ),
            _counter(
              'مشاريع مكتملة',
              projects
                  .where((project) => project.status == 'مكتمل')
                  .length
                  .toString(),
              Icons.task_alt_outlined,
            ),
          ],
        ),
        const SizedBox(height: 26),
        const Text(
          'آخر المشاريع',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
        ),
        const SizedBox(height: 8),
        ...projects.map(
          (project) => Card(
            child: ListTile(
              leading: const CircleAvatar(
                backgroundColor: primarycolor2,
                child: Icon(Icons.apartment, color: primarycolor1),
              ),
              title: Text(
                'المستفيد: ${project.beneficiary}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                'المتعهد: ${project.contractor} • ${project.status}',
              ),
              trailing: Text('${project.progress.toStringAsFixed(0)}%'),
            ),
          ),
        ),
        ],
      ),
    );
  }

  Widget _counter(String title, String value, IconData icon) => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: primarycolor1),
        const SizedBox(height: 7),
        Text(
          value,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: primarycolor2,
          ),
        ),
        Text(title, style: const TextStyle(fontSize: 11)),
      ],
    ),
  );
}
