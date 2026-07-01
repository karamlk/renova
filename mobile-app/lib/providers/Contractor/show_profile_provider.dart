import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:renove_provider/extras/link.dart';
import 'package:renove_provider/extras/shared_preferneces.dart';

import 'package:renove_provider/models/Contractor/show_profile_contractor_model.dart';

class ContractorShowProfileProvider extends ChangeNotifier {
  ShowProfileContractorModel? profile;

  bool isLoading = false;
  bool isSaving = false;
  String? errorMessage;

  XFile? image;
  Uint8List? imageBytes;

  bool isImageLoading = false;

  String? token;

  void setImage(XFile img) {
    image = img;
    notifyListeners();
  }

  String resolveMediaUrl(String? path) {
    if (path == null || path.trim().isEmpty) return '';
    final value = path.trim();
    if (value.startsWith('http://') || value.startsWith('https://')) {
      return value;
    }
    return '$link${value.startsWith('/') ? value : '/storage/$value'}';
  }

  /// =========================
  /// FETCH PROFILE (FIXED)
  /// =========================
  Future<void> fetchProfile() async {
    isLoading = true;
    notifyListeners();

    try {
      token = await getPrefs('token');

      final response = await http.get(
        Uri.parse('$link/api/contractor/profile'),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 404) {
        profile = null;
        errorMessage = null;
        return;
      }
      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw Exception(_message(response));
      }

      final decoded = jsonDecode(response.body);

      /// 🔴 حماية من null
      final data = decoded['data'];

      if (data == null) {
        profile = null;
        return;
      }

      profile = ShowProfileContractorModel.fromJson(decoded);
      await fetchImage();
    } catch (e) {
      errorMessage = e.toString().replaceFirst('Exception: ', '');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> saveProfile({
    required String firstName,
    required String lastName,
    required String phone,
    required String location,
    required String companyName,
    XFile? avatar,
    XFile? commercialRecord,
  }) async {
    isSaving = true;
    errorMessage = null;
    notifyListeners();
    try {
      token = await getPrefs('token');
      final creating = profile == null;
      final endpoint = creating
          ? '/api/contractor/profile'
          : '/api/contractor/profile/update';
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('$link$endpoint'),
      );
      request.headers.addAll({
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      });
      request.fields.addAll({
        'first_name': firstName,
        'last_name': lastName,
        'phone': phone,
        'location': location,
        'company_name': companyName,
      });
      if (avatar != null) {
        request.files.add(
          http.MultipartFile.fromBytes(
            'image',
            await avatar.readAsBytes(),
            filename: avatar.name,
          ),
        );
      }
      if (commercialRecord != null) {
        request.files.add(
          http.MultipartFile.fromBytes(
            'commercial_record',
            await commercialRecord.readAsBytes(),
            filename: commercialRecord.name,
          ),
        );
      }
      if (creating && commercialRecord == null)
        throw Exception('صورة السجل التجاري مطلوبة');
      final response = await http.Response.fromStream(await request.send());
      if (response.statusCode < 200 || response.statusCode >= 300)
        throw Exception(_message(response));

      final decoded = jsonDecode(response.body);
      if (decoded is Map && decoded['data'] is Map) {
        final data = Map<String, dynamic>.from(decoded['data'] as Map);
        final current = profile;
        data['user'] = data['user'] is Map
            ? data['user']
            : {
                'email': current?.email ?? '',
                'status': current?.status.isNotEmpty == true
                    ? current!.status
                    : 'pending',
              };
        profile = ShowProfileContractorModel.fromJson({'data': data});
      }
      if (avatar != null) imageBytes = await avatar.readAsBytes();
      image = avatar;
      return true;
    } catch (e) {
      errorMessage = e.toString().replaceFirst('Exception: ', '');
      return false;
    } finally {
      isSaving = false;
      notifyListeners();
    }
  }

  String _message(http.Response response) {
    try {
      final decoded = jsonDecode(response.body);
      if (decoded is Map && decoded['message'] != null)
        return '${decoded['message']}';
      if (decoded is Map && decoded['errors'] is Map) {
        return (decoded['errors'] as Map).values
            .expand((e) => e is List ? e : [e])
            .join('\n');
      }
    } catch (_) {}
    return 'تعذر تنفيذ العملية (${response.statusCode})';
  }

  /// =========================
  /// FETCH IMAGE (SAFE)
  /// =========================
  Future<void> fetchImage() async {
    isImageLoading = true;
    imageBytes = null;
    notifyListeners();
    try {
      final imageUrl = resolveMediaUrl(profile?.imageUrl);
      if (imageUrl.isEmpty) return;

      token = await getPrefs('token');

      final response = await http.get(
        Uri.parse(imageUrl),
        headers: {"Accept": "image/*", "Authorization": "Bearer $token"},
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        imageBytes = response.bodyBytes;
      }
    } catch (_) {
      imageBytes = null;
    } finally {
      isImageLoading = false;
      notifyListeners();
    }
  }
}
