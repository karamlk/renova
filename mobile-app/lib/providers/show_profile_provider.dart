import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:renove_provider/extras/link.dart';
import 'package:renove_provider/extras/shared_preferneces.dart';
import 'package:renove_provider/models/profile_model.dart';
import 'package:renove_provider/models/show_profile_model.dart';

class ShowprofileProvider extends ChangeNotifier {
  ShowProfileModel? showProfileModel;
  bool isLoading = false;
  File? image;

  void setImage(File img) {
    image = img;
    notifyListeners();
  }

  Future<void> fetchProfile() async {
    isLoading = true;
    notifyListeners();

    try {
      String? token = await getPrefs('token');
      final response = await http.get(
        Uri.parse('$link/api/user/profile'),
        headers: {"Accept": "application/json", "Authorization": "Bearer $token"},
      );
      final data = jsonDecode(response.body);
      print(data);
      //print(data['data']['profile']);

      showProfileModel = ShowProfileModel.fromJson(data);
    } catch (e) {
      print(e);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateImage() async {
    isLoading = true;
    notifyListeners();

    try {
      String? token = await getPrefs('token');
      var request = http.MultipartRequest('POST', Uri.parse('$link/api/profile/image'));
      request.headers['Authorization'] = 'Bearer $token';
      request.headers['Accept'] = 'application/json';
      request.files.add(await http.MultipartFile.fromPath('image', image!.path));
      final respone = await request.send();
      final res = await http.Response.fromStream(respone);
      final data = jsonDecode(res.body);

      if (res.statusCode == 200 || res.statusCode == 201) {
        showProfileModel = ShowProfileModel(
          firstName: showProfileModel!.firstName,
          lastName: showProfileModel!.lastName,
          email: showProfileModel!.email,
          phone: showProfileModel!.phone,
          location: showProfileModel!.location,
          image: showProfileModel!.image,
        );
        image = null;
      }
    } catch (e) {
      print(e);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
