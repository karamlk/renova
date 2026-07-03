import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:renove_provider/extras/link.dart';
import 'package:renove_provider/extras/shared_preferneces.dart';
import 'package:renove_provider/models/User/Profile/edit_profile_model.dart';

class EditProfileProvider extends ChangeNotifier {
  bool isLoading = false;

  File? image;

  void setImage(File img) {
    image = img;
    notifyListeners();
  }

  Future<http.Response?> updateProfile(EditProfileModel profile, File? image) async {
    isLoading = true;
    notifyListeners();

    try {
      String? token = await getPrefs('token');

      var request = http.MultipartRequest('POST', Uri.parse('$link/api/user/profile/update'));

      request.headers.addAll({"Authorization": "Bearer $token", "Accept": "application/json"});

      request.fields["first_name"] = profile.firstName;
      request.fields["last_name"] = profile.lastName;
      request.fields["location"] = profile.location;
      request.fields["phone"] = profile.phone;

      if (image != null) {
        request.files.add(await http.MultipartFile.fromPath("image", image.path));
      }

      final streamed = await request.send();

      return await http.Response.fromStream(streamed);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
