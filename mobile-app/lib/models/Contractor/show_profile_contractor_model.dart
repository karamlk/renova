class ShowProfileContractorModel {
  int id;
  int userId;

  String firstName;
  String lastName;

  String? phone;
  String? location;
  String? companyName;

  String? imageUrl;
  String? commercialRecordUrl;

  String email;
  String status;

  ShowProfileContractorModel({
    required this.id,
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.location,
    required this.companyName,
    required this.imageUrl,
    required this.commercialRecordUrl,
    required this.email,
    required this.status,
  });

  factory ShowProfileContractorModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? {};

    final user = data['user'] ?? {};

    return ShowProfileContractorModel(
      id: data['id'] ?? 0,
      userId: data['user_id'] ?? 0,

      firstName: data['first_name'] ?? '',
      lastName: data['last_name'] ?? '',

      phone: data['phone'],
      location: data['location'],
      companyName: data['company_name'],

      imageUrl: _mediaPath(data['image_url'], data['image']),
      commercialRecordUrl: _mediaPath(
        data['commercial_record_url'],
        data['commercial_record'],
      ),

      email: user['email'] ?? '',
      status: user['status'] ?? '',
    );
  }

  static String? _mediaPath(dynamic url, dynamic storedPath) {
    final directUrl = url?.toString();
    if (directUrl != null && directUrl.isNotEmpty) return directUrl;
    final path = storedPath?.toString();
    if (path == null || path.isEmpty) return null;
    return path.startsWith('/') ? path : '/storage/$path';
  }
}
