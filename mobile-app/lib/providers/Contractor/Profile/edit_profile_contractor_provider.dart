import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:renove_provider/extras/link.dart';
import 'package:renove_provider/extras/shared_preferneces.dart';
import 'package:renove_provider/models/Contractor/Profile/edit_profile_model.dart';

class EditContractorProfileProvider extends ChangeNotifier {
  bool isLoading = false;

  File? image;
  File? commercialRecord;

  void setImage(File file) {
    image = file;
    notifyListeners();
  }

  void setCommercialRecord(File file) {
    commercialRecord = file;
    notifyListeners();
  }

  Future<http.Response?> updateProfile(
    EditContractorProfileModel profile,
    File? image,
    File? commercialRecord,
  ) async {
    isLoading = true;
    notifyListeners();

    try {
      final token = await getPrefs("token");

      var request = http.MultipartRequest("POST", Uri.parse("$link/api/contractor/profile/update"));

      request.headers.addAll({"Authorization": "Bearer $token", "Accept": "application/json"});

      request.fields["first_name"] = profile.firstName;
      request.fields["last_name"] = profile.lastName;
      request.fields["location"] = profile.location;
      request.fields["phone"] = profile.phone;
      request.fields["company_name"] = profile.companyName;

      if (image != null) {
        request.files.add(await http.MultipartFile.fromPath("image", image.path));
      }

      if (commercialRecord != null) {
        request.files.add(
          await http.MultipartFile.fromPath("commercial_record", commercialRecord.path),
        );
      }

      final streamed = await request.send();
      return await http.Response.fromStream(streamed);
    } catch (e) {
      print(e);
      return null;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
