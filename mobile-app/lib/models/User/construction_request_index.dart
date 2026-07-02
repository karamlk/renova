class ConstructionRequestIndex {
  int id;
  String title;
  String decription;
  String location;
  String type;
  String status;

  ConstructionRequestIndex({
    required this.id,
    required this.title,
    required this.decription,
    required this.location,
    required this.type,
    required this.status,
  });

  factory ConstructionRequestIndex.fromJson(Map<String, dynamic> json) {
    return ConstructionRequestIndex(
      id: json['id'],
      title: json['title'],
      decription: json['description'],
      location: json['location'],
      type: json['type'],
      status: json['status'],
    );
  }
}
