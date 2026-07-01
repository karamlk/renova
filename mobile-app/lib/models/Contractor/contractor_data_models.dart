class ContractorRequest {
  const ContractorRequest({
    required this.id,
    required this.title,
    required this.description,
    required this.location,
    required this.type,
    required this.status,
    required this.imageUrl,
  });
  final int id;
  final String title, description, location, type, status;
  final String? imageUrl;
  factory ContractorRequest.fromJson(Map<String, dynamic> json) {
    final images = json['images'] is List ? json['images'] as List : const [];
    final image = images.isNotEmpty && images.first is Map
        ? Map<String, dynamic>.from(images.first as Map)
        : const <String, dynamic>{};
    return ContractorRequest(
      id: _int(json['id']),
      title: '${json['title'] ?? ''}',
      description: '${json['description'] ?? ''}',
      location: '${json['location'] ?? ''}',
      type: '${json['type'] ?? ''}',
      status: '${json['status'] ?? ''}',
      imageUrl: image['image_url']?.toString() ?? image['image']?.toString(),
    );
  }
}

class ContractorPost {
  const ContractorPost({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.progress,
    required this.imageUrls,
  });
  final int id, progress;
  final String title, description, status;
  final List<String> imageUrls;
  factory ContractorPost.fromJson(Map<String, dynamic> json) {
    final images = json['images'] is List ? json['images'] as List : const [];
    return ContractorPost(
      id: _int(json['id']),
      title: '${json['title'] ?? ''}',
      description: '${json['description'] ?? ''}',
      status: '${json['status'] ?? ''}',
      progress: _int(json['progress']),
      imageUrls: images
          .whereType<Map>()
          .map(
            (e) => e['image_url']?.toString() ?? e['image']?.toString() ?? '',
          )
          .where((e) => e.isNotEmpty)
          .toList(),
    );
  }
}

class ContractorSchedule {
  const ContractorSchedule({
    required this.id,
    required this.day,
    required this.date,
    required this.startTime,
    required this.endTime,
  });
  final int id;
  final String day, date, startTime, endTime;
  factory ContractorSchedule.fromJson(Map<String, dynamic> json) =>
      ContractorSchedule(
        id: _int(json['id']),
        day: '${json['day'] ?? json['day_of_week'] ?? ''}'.toLowerCase(),
        date: '${json['date'] ?? ''}',
        startTime: '${json['start_time'] ?? ''}',
        endTime: '${json['end_time'] ?? ''}',
      );
}

class ContractorVisit {
  const ContractorVisit({
    required this.id,
    required this.title,
    required this.location,
    required this.date,
    required this.startTime,
    required this.endTime,
  });
  final int id;
  final String title, location, date, startTime, endTime;
  factory ContractorVisit.fromJson(Map<String, dynamic> json) {
    final inspection = _map(json['inspection_request']);
    final request = _map(inspection['request']);
    final schedule = _map(json['schedule']);
    return ContractorVisit(
      id: _int(json['id']),
      title: '${request['title'] ?? 'زيارة ميدانية'}',
      location: '${request['location'] ?? ''}',
      date: '${schedule['date'] ?? json['date'] ?? ''}',
      startTime: '${schedule['start_time'] ?? ''}',
      endTime: '${schedule['end_time'] ?? ''}',
    );
  }
}

Map<String, dynamic> _map(dynamic value) =>
    value is Map ? Map<String, dynamic>.from(value) : <String, dynamic>{};
int _int(dynamic value) => value is int ? value : int.tryParse('$value') ?? 0;
