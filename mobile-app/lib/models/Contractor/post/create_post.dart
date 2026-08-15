class PostModel {
  final String title;
  final String status;
  final int projectId;
  final String description;

  PostModel({
    required this.title,
    required this.status,
    required this.projectId,
    required this.description,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      title: json['title'] ?? '',
      status: json['status'] ?? '',
      projectId: json['project_id'] ?? 0,
      description: json['description'] ?? '',
    );
  }
}
