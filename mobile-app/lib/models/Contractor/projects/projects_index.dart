class Project {
  final int id;
  final String status;
  final String progress;
  final int constructionFormId;
  final ProjectPerson user;
  final ProjectPerson engineer;
  final String totalCost;

  Project({
    required this.id,
    required this.status,
    required this.progress,
    required this.constructionFormId,
    required this.user,
    required this.engineer,
    required this.totalCost,
  });

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      id: json['id'],
      status: json['status'],
      progress: json['progress'],
      constructionFormId: json['construction_form_id'],
      user: ProjectPerson.fromJson(json['user']),
      engineer: ProjectPerson.fromJson(json['engineer']),
      totalCost: json['total_cost'],
    );
  }
}

class ProjectPerson {
  final int id;
  final String name;

  ProjectPerson({required this.id, required this.name});

  factory ProjectPerson.fromJson(Map<String, dynamic> json) {
    return ProjectPerson(id: json['id'], name: json['name']);
  }
}
