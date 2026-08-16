class TaskModel {
  TaskModel({
    required this.id,
    required this.title,
    this.description,
    required this.percentage,
    this.isCompleted = false,
  });
  final int id;
  String title;
  String? description;
  double percentage;
  bool isCompleted;
}

class ProjectModel {
  ProjectModel({
    required this.id,
    required this.beneficiary,
    required this.contractor,
    required this.status,
    required this.progress,
    this.totalCost = 0,
    required this.tasks,
  });
  final int id;
  final String beneficiary;
  final String contractor;
  String status;
  double progress;
  double totalCost;
  final List<TaskModel> tasks;
}
