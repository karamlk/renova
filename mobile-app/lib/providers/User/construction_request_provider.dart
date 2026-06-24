import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:http/http.dart' as http;
import 'package:renove_provider/extras/link.dart';
import 'package:renove_provider/extras/shared_preferneces.dart';
import 'package:renove_provider/models/construction_request_model.dart';

class ConstructionRequestProvider extends ChangeNotifier {
  List<File> images = [];
  bool isLoading = false;
  bool isUpdating = false;
  bool isDeleteing = false;
  String? selectedType;
  final Map<String, String> types = {
    "construction": "إعادة إعمار",
    "restoration": "تصليح",
    "finishing": "ديكور",
  };

  void setType(String? type) {
    selectedType = type;
    notifyListeners();
  }

  void addImages(List<File> files) {
    images.addAll(files);
    notifyListeners();
  }

  void removeImage(int index) {
    images.remove(index);
    notifyListeners();
  }

  void clearImages() {
    images.clear();
    notifyListeners();
  }

  Future<File> compressImage(File file) async {
    final result = await FlutterImageCompress.compressAndGetFile(
      file.path,
      "${file.path}_compressed.jpg",
      quality: 70,
    );
    return File(result!.path);
  }

  Future<http.Response?> createRequest(ConstructionResquestModel model) async {
    isLoading = true;
    notifyListeners();
    try {
      String? token = await getPrefs('token');
      final request = http.MultipartRequest('POST', Uri.parse('$link/api/reconstruction-requests'));
      request.headers['Authorization'] = 'Bearer $token';
      request.headers['Accept'] = 'application/json';
      request.fields.addAll(model.toMap());
      for (var img in images) {
        final compressed = await compressImage(img);
        request.files.add(await http.MultipartFile.fromPath('images[]', compressed.path));
      }
      final streamed = await request.send();
      final response = await http.Response.fromStream(streamed);
      print(response.body);
      return response;
    } catch (e) {
      print(e);
      return null;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<http.Response?> updateRequest(
    int id,
    String title,
    String description,
    String location,
    String type,
    List<dynamic> remainingImages,
  ) async {
    isUpdating = true;
    notifyListeners();
    try {
      final token = await getPrefs('token');
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$link/api/reconstruction-requests/$id'),
      );

      request.headers['Authorization'] = 'Bearer $token';
      request.headers['Accept'] = 'application/json';
      request.fields['title'] = title;
      request.fields['description'] = description;
      request.fields['location'] = location;
      request.fields['type'] = type;
      request.fields['remaining_images'] = jsonEncode(remainingImages);

      for (var file in images) {
        var stream = http.ByteStream(file.openRead());
        var length = await file.length();

        var multipartFile = http.MultipartFile(
          'images[]',
          stream,
          length,
          filename: path.basename(file.path),
        );
        request.files.add(multipartFile);
      }
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);
      return response;
    } catch (e) {
      print(e);
      return null;
    } finally {
      isUpdating = false;
      notifyListeners();
    }
  }

  Future<http.Response?> deleteRequest(int id) async {
    isDeleteing = true;
    notifyListeners();
    try {
      final token = await getPrefs('token');
      final response = await http.delete(
        Uri.parse('$link/api/reconstruction-requests/$id'),
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
          "Content-Type": "application/json",
        },
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        print(response.body);
        print(response.statusCode);
        notifyListeners();
      }
      return response;
    } catch (e) {
      print(e);
      return null;
    } finally {
      isDeleteing = false;
      notifyListeners();
    }
  }
}
