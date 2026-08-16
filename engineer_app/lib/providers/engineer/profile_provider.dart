import 'dart:convert';
import 'dart:io';
import 'package:engineer_app/extras/api_config.dart';
import 'package:engineer_app/models/engineer_profile_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProfileProvider extends ChangeNotifier {
  EngineerProfileModel? profile;
  bool isLoading = false, isSaving = false;
  Future<String?> fetch(String token) async {
    isLoading = true;
    notifyListeners();
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/engineer/profile'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      final body = _body(response);
      if (response.statusCode >= 200 && response.statusCode < 300) {
        profile = EngineerProfileModel.fromJson(
          Map<String, dynamic>.from(body['data'] as Map),
        );
        return null;
      }
      return body['message']?.toString() ?? 'تعذر تحميل الملف الشخصي.';
    } catch (_) {
      return 'تعذر الاتصال بالخادم المحلي.';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<String?> update(
    String token,
    Map<String, String> fields, {
    File? image,
    File? syndicateCardImage,
    File? certificateFile,
  }) async {
    isSaving = true;
    notifyListeners();
    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('${ApiConfig.baseUrl}/engineer/profile'),
      );
      request.headers.addAll({
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      });
      request.fields.addAll(fields);
      if (image != null)
        request.files.add(
          await http.MultipartFile.fromPath('image', image.path),
        );
      if (syndicateCardImage != null)
        request.files.add(
          await http.MultipartFile.fromPath(
            'syndicate_card_image',
            syndicateCardImage.path,
          ),
        );
      if (certificateFile != null)
        request.files.add(
          await http.MultipartFile.fromPath(
            'certificate_file',
            certificateFile.path,
          ),
        );
      final streamed = await request.send();
      final response = await http.Response.fromStream(streamed);
      final body = _body(response);
      if (response.statusCode >= 200 && response.statusCode < 300) {
        profile = EngineerProfileModel.fromJson(
          Map<String, dynamic>.from(body['data'] as Map),
        );
        return null;
      }
      final errors = body['errors'];
      if (errors is Map)
        return errors.values
            .map((v) => v is List ? v.first.toString() : v.toString())
            .join('\n');
      return body['message']?.toString() ?? 'تعذر تحديث الملف الشخصي.';
    } catch (_) {
      return 'تعذر الاتصال بالخادم المحلي.';
    } finally {
      isSaving = false;
      notifyListeners();
    }
  }

  Map<String, dynamic> _body(http.Response response) {
    try {
      return Map<String, dynamic>.from(jsonDecode(response.body) as Map);
    } catch (_) {
      return {};
    }
  }
}
