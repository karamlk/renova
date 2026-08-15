import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:renove_provider/extras/link.dart';
import 'package:renove_provider/extras/shared_preferneces.dart';
import 'package:renove_provider/models/Contractor/post/create_post.dart';

class PostProvider extends ChangeNotifier {
  bool isLoading = false;
  List<File> postImages = [];

  Future<http.Response?> createPost({required PostModel post, required List<File> images}) async {
    isLoading = true;
    notifyListeners();

    try {
      final token = await getPrefs("token");

      final request = http.MultipartRequest("POST", Uri.parse("$link/api/contractor/posts"));

      request.headers.addAll({"Accept": "application/json", "Authorization": "Bearer $token"});

      request.fields["title"] = post.title;

      request.fields["status"] = post.status;

      request.fields["project_id"] = post.projectId.toString();

      request.fields["description"] = post.description;

      for (final image in images) {
        request.files.add(await http.MultipartFile.fromPath("images[]", image.path));
      }

      final streamedResponse = await request.send();

      return await http.Response.fromStream(streamedResponse);
    } catch (e) {
      debugPrint(e.toString());
      return null;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> pickPostImages() async {
    final result = await FilePicker.pickFiles(allowMultiple: true, type: FileType.image);

    if (result != null) {
      final newImages = result.paths.whereType<String>().map((e) => File(e)).toList();

      postImages.addAll(newImages);

      notifyListeners();
    }
  }

  void removeImage(int index) {
    postImages.removeAt(index);
    notifyListeners();
  }

  // Reset images after submitting
  void clearImages() {
    postImages.clear();
    notifyListeners();
  }
}
