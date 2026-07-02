class ContractorRequestModel {
  final int id;
  final int userId;
  final String title;
  final String description;
  final String location;
  final String type;
  final String status;

  final UserModel user;
  final List<RequestImage> images;

  ContractorRequestModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.location,
    required this.type,
    required this.status,
    required this.user,
    required this.images,
  });

  factory ContractorRequestModel.fromJson(Map<String, dynamic> json) {
    return ContractorRequestModel(
      id: json['id'],
      userId: json['user_id'],
      title: json['title'],
      description: json['description'],
      location: json['location'],
      type: json['type'],
      status: json['status'],
      user: UserModel.fromJson(json['user']),
      images: (json['images'] as List).map((e) => RequestImage.fromJson(e)).toList(),
    );
  }
}

class UserModel {
  final int id;
  final String name;
  final String email;

  UserModel({required this.id, required this.name, required this.email});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(id: json['id'], name: json['name'], email: json['email']);
  }
}

class RequestImage {
  final int id;
  final String imageUrl;

  RequestImage({required this.id, required this.imageUrl});

  factory RequestImage.fromJson(Map<String, dynamic> json) {
    return RequestImage(id: json['id'], imageUrl: json['full_image_url']);
  }
}
