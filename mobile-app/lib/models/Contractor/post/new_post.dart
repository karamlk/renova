class NewPost {
  final int id;
  String title;
  String status;

  NewPost({required this.id, required this.title, required this.status});

  factory NewPost.fromJson(Map<String, dynamic> json) {
    return NewPost(id: json['id'] as int, title: json['title'] as String, status: json['status']);
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'title': title, 'status': status};
  }
}
