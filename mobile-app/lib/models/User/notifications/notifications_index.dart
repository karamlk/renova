class NotificationItem {
  final int id;
  final int userId;
  final String title;
  final String message;
  final bool isRead;
  final String type;
  final String targetPath;
  final int relatedId;
  final String createdAt;
  final String updatedAt;
  final String? deletedAt;

  NotificationItem({
    this.id = 0,
    this.userId = 0,
    this.title = '',
    this.message = '',
    this.isRead = false,
    this.type = '',
    this.targetPath = '',
    this.relatedId = 0,
    this.createdAt = '',
    this.updatedAt = '',
    this.deletedAt,
  });

  factory NotificationItem.fromJson(Map<String, dynamic> json) {
    return NotificationItem(
      id: json['id'] as int? ?? 0,
      userId: json['user_id'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      message: json['message'] as String? ?? '',
      isRead: json['is_read'] as bool? ?? false,
      type: json['type'] as String? ?? '',
      targetPath: json['target_path'] as String? ?? '',
      relatedId: json['related_id'] as int? ?? 0,
      createdAt: json['created_at'] as String? ?? '',
      updatedAt: json['updated_at'] as String? ?? '',
      deletedAt: json['deleted_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'title': title,
      'message': message,
      'is_read': isRead,
      'type': type,
      'target_path': targetPath,
      'related_id': relatedId,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'deleted_at': deletedAt,
    };
  }
}
