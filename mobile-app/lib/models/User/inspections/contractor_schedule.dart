class ContractorSchedule {
  final int id;
  final String day;
  final String startTime;
  final String endTime;

  ContractorSchedule({
    required this.id,
    required this.day,
    required this.startTime,
    required this.endTime,
  });

  factory ContractorSchedule.fromJson(Map<String, dynamic> json) {
    return ContractorSchedule(
      id: json['id'],
      day: json['day'],
      startTime: json['start_time'],
      endTime: json['end_time'],
    );
  }
}
