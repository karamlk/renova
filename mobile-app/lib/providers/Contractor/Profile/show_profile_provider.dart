import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:renove_provider/extras/link.dart';
import 'package:renove_provider/extras/shared_preferneces.dart';
import 'package:renove_provider/models/Contractor/Profile/show_profile_model.dart';

class ShowContractorProfileProvider extends ChangeNotifier {
  ShowContractorProfileModel? showProfileModel;

  bool isLoading = false;
  bool isImageLoading = false;

  String? token;

  File? image;

  void setImage(File img) {
    image = img;
    notifyListeners();
  }

  Future<void> fetchProfile() async {
    isLoading = true;
    notifyListeners();

    try {
      token = await getPrefs('token');

      final response = await http.get(
        Uri.parse('$link/api/contractor/profile'),
        headers: {"Accept": "application/json", "Authorization": "Bearer $token"},
      );

      final data = jsonDecode(response.body);

      showProfileModel = ShowContractorProfileModel.fromJson(data);
      print('RESPONSE CODE IS : ${response.statusCode}');
    } catch (e) {
      print(e);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateImage() async {
    isImageLoading = true;
    notifyListeners();

    try {
      token = await getPrefs('token');

      var request = http.MultipartRequest('POST', Uri.parse('$link/api/contractor/profile/update'));

      request.headers['Authorization'] = 'Bearer $token';
      request.headers['Accept'] = 'application/json';

      request.files.add(await http.MultipartFile.fromPath('image', image!.path));

      await request.send();

      image = null;

      await fetchProfile();
    } catch (e) {
      print(e);
    } finally {
      isImageLoading = false;
      notifyListeners();
    }
  }
}
