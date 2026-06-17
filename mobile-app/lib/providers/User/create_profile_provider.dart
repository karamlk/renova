import 'dart:io';
import 'package:flutter/material.dart';
import 'package:renove_provider/Extras/link.dart';
import 'package:renove_provider/extras/shared_preferneces.dart';
import 'package:renove_provider/models/profile_model.dart';
import 'package:http/http.dart' as http;

class CreateProfileProvider extends ChangeNotifier {
  bool isLoading = false;
  File? image;

  void setImage(File img) {
    image = img;
    notifyListeners();
  }

  Future<http.Response?> fillProfile(ProfileModel profile, File? image) async {
    isLoading = true;
    notifyListeners();

    try {
      String? token = await getPrefs('token');
      var request = http.MultipartRequest('POST', Uri.parse('$link/api/user/profile'));
      request.headers.addAll({"Accept": "application/json", "Authorization": "Bearer $token"});
      request.fields['first_name'] = profile.firstName;
      request.fields['last_name'] = profile.lastName;
      request.fields['location'] = profile.location;
      request.fields['phone'] = profile.phone;

      if (image != null) {
        request.files.add(await http.MultipartFile.fromPath('image', image.path));
      }
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      return response;
    } catch (e) {
      print(e);
      return null;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
