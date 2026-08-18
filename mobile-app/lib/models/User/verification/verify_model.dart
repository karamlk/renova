import 'dart:io';

class Verify {
  final String foundationName;
  final String description;
  final String registrationNumber;
  final List<File> documents;

  Verify({
    required this.foundationName,
    required this.description,
    required this.registrationNumber,
    required this.documents,
  });
}
