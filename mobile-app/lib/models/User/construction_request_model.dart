class ConstructionResquestModel {
  final String title;
  final String description;
  final String location;
  final String type;

  ConstructionResquestModel({
    required this.title,
    required this.description,
    required this.location,
    required this.type,
  });

  Map<String, String> toMap() {
    return {'title': title, 'description': description, 'location': location, 'type': type};
  }
}
