class NoShowWarningModel {
  NoShowWarningModel({
    required this.id,
    required this.reason,
    required this.description,
    required this.reportedName,
    required this.reportedRole,
    required this.createdAt,
    required this.penaltyApplied,
  });

  final int id;
  final String reason;
  final String description;
  final String reportedName;
  final String reportedRole;
  final String createdAt;
  final bool penaltyApplied;

  String get reportedRoleLabel => switch (reportedRole) {
    'user' => 'المستفيد',
    'contractor' => 'المتعهد',
    'engineer' => 'المهندس',
    _ => reportedRole,
  };

  factory NoShowWarningModel.fromJson(Map<String, dynamic> json) {
    final reported = json['reported'] is Map
        ? Map<String, dynamic>.from(json['reported'] as Map)
        : <String, dynamic>{};
    final role = json['reported_role'] is Map
        ? Map<String, dynamic>.from(json['reported_role'] as Map)
        : <String, dynamic>{};

    return NoShowWarningModel(
      id: int.tryParse(json['id']?.toString() ?? '') ?? 0,
      reason: json['reason']?.toString() ?? 'عدم الحضور إلى الزيارة الميدانية',
      description: json['description']?.toString() ?? '',
      reportedName: reported['name']?.toString() ?? '',
      reportedRole: role['name']?.toString() ??
          json['reported_role']?.toString() ??
          '',
      createdAt: json['created_at']?.toString() ?? '',
      penaltyApplied: json['penalty_applied'] == true ||
          json['penalty_applied'] == 1,
    );
  }
}
