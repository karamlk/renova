class NotificationDetailsResponse {
  final String message;
  final NotificationDetailsModel data;

  NotificationDetailsResponse({required this.message, required this.data});

  factory NotificationDetailsResponse.fromJson(Map<String, dynamic> json) {
    return NotificationDetailsResponse(
      message: json['message'] ?? '',
      data: NotificationDetailsModel.fromJson(json['data']),
    );
  }
}

class NotificationDetailsModel {
  final int id;
  final int userId;
  final String title;
  final String message;
  final bool isRead;
  final String type;
  final String targetPath;
  final int relatedId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;

  NotificationDetailsModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.message,
    required this.isRead,
    required this.type,
    required this.targetPath,
    required this.relatedId,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  factory NotificationDetailsModel.fromJson(Map<String, dynamic> json) {
    return NotificationDetailsModel(
      id: json['id'] ?? 0,
      userId: json['user_id'] ?? 0,
      title: json['title'] ?? '',
      message: json['message'] ?? '',
      isRead: json['is_read'] ?? false,
      type: json['type'] ?? '',
      targetPath: json['target_path'] ?? '',
      relatedId: json['related_id'] ?? 0,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      deletedAt: json['deleted_at'] != null ? DateTime.parse(json['deleted_at']) : null,
    );
  }
}
