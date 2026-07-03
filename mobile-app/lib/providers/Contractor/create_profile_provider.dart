import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:renove_provider/extras/link.dart';
import 'package:renove_provider/extras/shared_preferneces.dart';
import 'package:renove_provider/models/Contractor/create_profile_model.dart';

class CreateContractorProfileProvider extends ChangeNotifier {
  bool isLoading = false;

  File? image;
  File? commercialRecord;

  void setImage(File img) {
    image = img;
    notifyListeners();
  }

  void setCommercialRecord(File img) {
    commercialRecord = img;
    notifyListeners();
  }

  Future<http.Response?> fillProfile(
    ContractorProfileModel profile,
    File? image,
    File? commercialRecord,
  ) async {
    isLoading = true;
    notifyListeners();

    try {
      String? token = await getPrefs('token');

      var request = http.MultipartRequest('POST', Uri.parse('$link/api/contractor/profile'));

      request.headers.addAll({"Accept": "application/json", "Authorization": "Bearer $token"});

      request.fields['first_name'] = profile.firstName;
      request.fields['last_name'] = profile.lastName;
      request.fields['location'] = profile.location;
      request.fields['phone'] = profile.phone;
      request.fields['company_name'] = profile.companyName;

      if (image != null) {
        request.files.add(await http.MultipartFile.fromPath('image', image.path));
      }

      if (commercialRecord != null) {
        request.files.add(
          await http.MultipartFile.fromPath('commercial_record', commercialRecord.path),
        );
      }

      final streamedResponse = await request.send();

      return await http.Response.fromStream(streamedResponse);
    } catch (e) {
      print(e);
      return null;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
