class SiteVisitModel {
  SiteVisitModel({
    required this.id,
    required this.user,
    required this.title,
    required this.location,
    required this.contractor,
    required this.day,
    required this.startTime,
    required this.endTime,
    required this.status,
  });
  final int id;
  final String user;
  final String title;
  final String location;
  final String contractor;
  final String day;
  final String startTime;
  final String endTime;
  String status;
}
