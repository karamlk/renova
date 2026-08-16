import 'package:engineer_app/extras/theme.dart';
import 'package:engineer_app/models/project_model.dart';
import 'package:engineer_app/providers/auth_provider.dart';
import 'package:engineer_app/providers/engineer/projects_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProjectDetailsScreen extends StatefulWidget {
  const ProjectDetailsScreen({super.key, required this.project});

  final ProjectModel project;

  @override
  State<ProjectDetailsScreen> createState() => _ProjectDetailsScreenState();
}

class _ProjectDetailsScreenState extends State<ProjectDetailsScreen> {
  ProjectModel get project => widget.project;

  Future<void> _refresh() async {
    final token = context.read<AuthProvider>().token;
    if (token == null) return;
    await context.read<ProjectsProvider>().fetchTasks(token, project);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final token = context.read<AuthProvider>().token;
      if (token != null) {
        context.read<ProjectsProvider>().fetchTasks(token, project);
      }
    });
  }

  Future<void> _showTaskSheet({TaskModel? task}) async {
    final titleController = TextEditingController(text: task?.title);
    final descriptionController = TextEditingController(text: task?.description);
    final percentageController = TextEditingController(
      text: task?.percentage.toString(),
    );

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (sheetContext) {
        return Padding(
          padding: EdgeInsets.fromLTRB(
            20,
            20,
            20,
            MediaQuery.of(sheetContext).viewInsets.bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                task == null ? 'إضافة مهمة جديدة' : 'تعديل المهمة',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'عنوان المهمة',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: descriptionController,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: 'الوصف',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: percentageController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'النسبة المئوية',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primarycolor2,
                  foregroundColor: primarycolor1,
                ),
                onPressed: () => _saveTask(
                  sheetContext: sheetContext,
                  task: task,
                  title: titleController.text,
                  description: descriptionController.text,
                  percentage: percentageController.text,
                ),
                child: Text(task == null ? 'إضافة المهمة' : 'حفظ التعديلات'),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _saveTask({
    required BuildContext sheetContext,
    required TaskModel? task,
    required String title,
    required String description,
    required String percentage,
  }) async {
    final value = double.tryParse(percentage);
    if (title.trim().isEmpty || value == null || value <= 0) return;

    final token = context.read<AuthProvider>().token;
    if (token == null) return;

    final provider = context.read<ProjectsProvider>();
    final error = task == null
        ? await provider.createRemoteTask(
            token,
            project,
            title.trim(),
            description.trim().isEmpty ? null : description.trim(),
            value,
          )
        : await provider.updateRemoteTask(
            token,
            project,
            task,
            title.trim(),
            description.trim().isEmpty ? null : description.trim(),
            value,
          );

    if (sheetContext.mounted) Navigator.pop(sheetContext);
    if (mounted && error != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
    }
  }

  Future<void> _completeTask(TaskModel task) async {
    if (task.isCompleted) return;
    final token = context.read<AuthProvider>().token;
    if (token == null) return;

    final error = await context.read<ProjectsProvider>().toggleRemoteTask(
      token,
      project,
      task,
    );
    if (mounted && error != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
    }
  }

  Future<void> _deleteTask(TaskModel task) async {
    final token = context.read<AuthProvider>().token;
    if (token == null) return;

    final error = await context.read<ProjectsProvider>().deleteRemoteTask(
      token,
      project,
      task,
    );
    if (mounted && error != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
    }
  }

  @override
  Widget build(BuildContext context) {
    context.watch<ProjectsProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('تفاصيل المشروع')),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: primarycolor2,
        foregroundColor: primarycolor1,
        onPressed: _showTaskSheet,
        icon: const Icon(Icons.add),
        label: const Text('إضافة مهمة'),
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
          _infoRow('المستفيد', project.beneficiary),
          _infoRow('المتعهد', project.contractor),
          _infoRow('الحالة', project.status),
          Row(
            children: [
              const Text('نسبة الإنجاز', style: TextStyle(fontWeight: FontWeight.bold)),
              const Spacer(),
              Text('${project.progress.toStringAsFixed(0)}%'),
            ],
          ),
          const SizedBox(height: 7),
          LinearProgressIndicator(value: project.progress / 100, minHeight: 8),
          const SizedBox(height: 22),
          const Text(
            'تقسيم المشروع والمهام',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          ...project.tasks.map(_taskCard),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: softSurface,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
            const Spacer(),
            Text(value),
          ],
        ),
      ),
    );
  }

  Widget _taskCard(TaskModel task) {
    return Card(
      child: CheckboxListTile(
        value: task.isCompleted,
        onChanged: (_) => _completeTask(task),
        title: Text(task.title),
        subtitle: Text(
          '${task.description ?? 'لا يوجد وصف'} • ${task.percentage.toStringAsFixed(0)}%',
        ),
        secondary: PopupMenuButton<String>(
          onSelected: (choice) {
            if (choice == 'edit') {
              _showTaskSheet(task: task);
            } else {
              _deleteTask(task);
            }
          },
          itemBuilder: (_) => const [
            PopupMenuItem(value: 'edit', child: Text('تعديل')),
            PopupMenuItem(value: 'delete', child: Text('حذف')),
          ],
        ),
      ),
    );
  }
}
