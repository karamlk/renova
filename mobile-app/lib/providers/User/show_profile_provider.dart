import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:renove_provider/extras/link.dart';
import 'package:renove_provider/extras/shared_preferneces.dart';
import 'dart:async';
import 'package:renove_provider/models/show_profile_model.dart';
import 'package:renove_provider/screens/Contractor/HomeMainContractor.dart';

class ShowprofileProvider extends ChangeNotifier {
  ShowProfileModel? showProfileModel;
  bool isLoading = false;
  File? image;
  Uint8List? imagebytes;
  bool isImageLoading = false;
  String? token;

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
        Uri.parse('$link/api/user/profile'),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
      );
      final data = jsonDecode(response.body);
      print(data);

      showProfileModel = ShowProfileModel.fromJson(data);
    } catch (e) {
      print(e);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchImage() async {
    try {
      String? token = await getPrefs('token');
      final response = await http.get(
        Uri.parse('$link${showProfileModel!.image}'),
        headers: {"Authorization": "Bearer $token"},
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        imagebytes = response.bodyBytes;
        notifyListeners();
        print(response.body);
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> updateImage() async {
    isImageLoading = true;
    notifyListeners();

    try {
      String? token = await getPrefs('token');
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$link/api/user/profile/update'),
      );
      request.headers['Authorization'] = 'Bearer $token';
      request.headers['Accept'] = 'application/json';
      request.files.add(
        await http.MultipartFile.fromPath('image', image!.path),
      );
      final respone = await request.send();
      final res = await http.Response.fromStream(respone);

      if (res.statusCode == 200 || res.statusCode == 201) {
        print(res.statusCode);
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
      isImageLoading = false;
      notifyListeners();
    }
  }

  void startStatusAutoCheck(BuildContext context) {
    _statusTimer?.cancel();

    _statusTimer = Timer.periodic(const Duration(seconds: 5), (timer) async {
      await fetchProfile();

      if ((showProfileModel as dynamic?)?.status == "approved") {
        timer.cancel();

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const HomeMainContractor()),
          (route) => false,
        );
      }
    });
  }

  void stopStatusAutoCheck() {
    _statusTimer?.cancel();
    _statusTimer = null;
  }

  Timer? _statusTimer;
}
