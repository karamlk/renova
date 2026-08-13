import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:renove_provider/extras/link.dart';
import 'package:renove_provider/extras/shared_preferneces.dart';
import 'package:renove_provider/models/User/construction%20forms/received_forms_details.dart';
import 'package:renove_provider/models/User/construction%20forms/recieved_forms.dart';
import 'package:renove_provider/screens/User/construction%20forms/received_forms_details.dart';

class ContrsutionFormsProvider extends ChangeNotifier {
  bool isLoading = false;
  bool isReviewing = false;
  List<RecievedForms> recievedForms = [];
  ReceivedFormDetails? details;
  List<File> complaintImages = [];
  bool isComplaining = false;

  Future<http.Response?> fetchReceivedForms() async {
    isLoading = true;
    notifyListeners();
    try {
      final token = await getPrefs('token');

      final response = await http.get(
        Uri.parse('$link/api/receivedForms'),
        headers: {"Accept": "application/json", "Authorization": "Bearer $token"},
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final List data = jsonDecode(response.body);
        recievedForms = data.map((e) => RecievedForms.fromJson(e)).toList();
      }
      return response;
    } catch (e) {
      print(e);
      return null;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<http.Response?> fetchRecievedDetails(int id) async {
    isLoading = true;

    notifyListeners();
    try {
      final token = await getPrefs('token');
      final response = await http.get(
        Uri.parse('$link/api/showForm/$id'),
        headers: {"Accept": "application/json", "Authorization": "Bearer $token"},
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        details = ReceivedFormDetails.fromJson(jsonDecode(response.body));
      }
      print(response.statusCode);

      return response;
    } catch (e) {
      print(e);
      return null;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<http.Response?> reviewForm({
    required int id,
    required String status,
    String? userNotes,
  }) async {
    isReviewing = true;
    notifyListeners();

    try {
      final token = await getPrefs("token");

      final response = await http.put(
        Uri.parse("$link/api/construction-forms/$id/user-review"),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: jsonEncode({"status": status, "user_notes": userNotes}),
      );
      print("${response.statusCode}: ${response.body}");
      return response;
    } catch (e) {
      print(e);
      return null;
    } finally {
      isReviewing = false;
      notifyListeners();
    }
  }

  Future<http.Response?> verifyReviewOtp({required int id, required String otp}) async {
    isReviewing = true;
    notifyListeners();
    try {
      final token = await getPrefs("token");

      final response = await http.post(
        Uri.parse("$link/api/construction-forms/$id/confirm-payment"),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: jsonEncode({"otp": otp}),
      );
      print(response.body);
      return response;
    } catch (e) {
      print(e);
      return null;
    } finally {
      isReviewing = false;
      notifyListeners();
    }
  }

  Future<void> pickComplaintImages() async {
    final result = await FilePicker.pickFiles(allowMultiple: true, type: FileType.image);

    if (result != null) {
      final newImages = result.paths.whereType<String>().map((e) => File(e)).toList();

      complaintImages.addAll(newImages);

      notifyListeners();
    }
  }

  void clearComplaint() {
    complaintImages.clear();
    notifyListeners();
  }

  void removeComplaintImage(int index) {
    complaintImages.removeAt(index);
    notifyListeners();
  }

  Future<http.Response?> submitComplaint({
    required int constructionFormId,
    required String reason,
    required String description,
  }) async {
    isComplaining = true;
    notifyListeners();
    final token = await getPrefs("token");

    try {
      final request = http.MultipartRequest("POST", Uri.parse("$link/api/complaints"));

      request.headers["Authorization"] = "Bearer $token";
      request.headers["Accept"] = "application/json";

      request.fields["construction_form_id"] = constructionFormId.toString();

      request.fields["reason"] = reason;

      request.fields["description"] = description;

      for (final image in complaintImages) {
        request.files.add(await http.MultipartFile.fromPath("images[]", image.path));
      }

      final streamed = await request.send();

      return await http.Response.fromStream(streamed);
    } catch (e) {
      print(e);
      return null;
    } finally {
      isComplaining = false;
      notifyListeners();
    }
  }
}
