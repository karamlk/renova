import 'package:engineer_app/models/project_model.dart';
import 'package:engineer_app/providers/auth_provider.dart';
import 'package:engineer_app/providers/engineer/projects_provider.dart';
import 'package:engineer_app/screens/Engineer/project/project_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EngineerProjects extends StatelessWidget {
  const EngineerProjects({super.key});

  Future<void> _refresh(BuildContext context) async {
    final token = context.read<AuthProvider>().token;
    if (token == null) return;

    final error = await context.read<ProjectsProvider>().fetchProjects(token);
    if (error != null && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
    }
  }

  Future<void> _openProject(BuildContext context, ProjectModel project) async {
    await Navigator.push<void>(
      context,
      MaterialPageRoute(builder: (_) => ProjectDetailsScreen(project: project)),
    );
    if (context.mounted) await _refresh(context);
  }

  @override
  Widget build(BuildContext context) {
    final projects = context.watch<ProjectsProvider>().projects;
    return RefreshIndicator(
      onRefresh: () => _refresh(context),
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'مشاريعي',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
          ),
          const SizedBox(height: 12),
          if (projects.isEmpty)
            const Padding(
              padding: EdgeInsets.all(30),
              child: Center(child: Text('لا توجد مشاريع مسندة إليك.')),
            ),
          ...projects.map(
            (project) => _ProjectTile(
              project: project,
              onTap: () => _openProject(context, project),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProjectTile extends StatelessWidget {
  const _ProjectTile({required this.project, required this.onTap});

  final ProjectModel project;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Card(
    child: ListTile(
      title: Text(
        'المستفيد: ${project.beneficiary}',
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text('المتعهد: ${project.contractor}\nالحالة: ${project.status}'),
      isThreeLine: true,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('${project.progress.toStringAsFixed(0)}%'),
          const Icon(Icons.chevron_left),
        ],
      ),
      onTap: onTap,
    ),
  );
}
