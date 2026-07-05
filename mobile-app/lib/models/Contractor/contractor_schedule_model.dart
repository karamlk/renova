class ContractorScheduleModel {
  final int id;
  final String date;
  final String day;
  final String startTime;
  final String endTime;

  ContractorScheduleModel({
    required this.id,
    required this.date,
    required this.day,
    required this.startTime,
    required this.endTime,
  });

  factory ContractorScheduleModel.fromJson(Map<String, dynamic> json) {
    return ContractorScheduleModel(
      id: json['id'],
      date: json['date'],
      day: json['day'],
      startTime: json['start_time'],
      endTime: json['end_time'],
    );
  }
}
