class ShowInspectionRequestModel {
  final int id;
  final int inspectionRequestId;
  final int scheduleId;
  final int? engineerId;
  final String status;
  final int contractorId;
  final RequestInfo request;
  final ScheduleInfo schedule;

  ShowInspectionRequestModel({
    required this.id,
    required this.inspectionRequestId,
    required this.scheduleId,
    required this.engineerId,
    required this.status,
    required this.request,
    required this.schedule,
    required this.contractorId,
  });

  factory ShowInspectionRequestModel.fromJson(Map<String, dynamic> json) {
    return ShowInspectionRequestModel(
      id: json['id'],
      inspectionRequestId: json['inspection_request_id'],
      scheduleId: json['schedule_id'],
      engineerId: json['engineer_id'],
      status: json['status'],
      request: RequestInfo.fromJson(json['inspection_request']['request']),
      schedule: ScheduleInfo.fromJson(json['schedule']),
      contractorId: json['inspection_request']['contractor_id'],
    );
  }
}

class RequestInfo {
  final int id;
  final String title;
  final String description;
  final String location;
  final String type;
  final String status;

  RequestInfo({
    required this.id,
    required this.title,
    required this.description,
    required this.location,
    required this.type,
    required this.status,
  });

  factory RequestInfo.fromJson(Map<String, dynamic> json) {
    return RequestInfo(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      location: json['location'],
      type: json['type'],
      status: json['status'],
    );
  }
}

class ScheduleInfo {
  final int id;
  final String day;
  final String startTime;
  final String endTime;

  ScheduleInfo({
    required this.id,
    required this.day,
    required this.startTime,
    required this.endTime,
  });

  factory ScheduleInfo.fromJson(Map<String, dynamic> json) {
    return ScheduleInfo(
      id: json['id'],
      day: json['day_of_week'],
      startTime: json['start_time'],
      endTime: json['end_time'],
    );
  }
}
