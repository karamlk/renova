import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:renove_provider/extras/link.dart';
import 'package:renove_provider/extras/shared_preferneces.dart';
import 'package:renove_provider/models/Contractor/post/create_post.dart';
import 'package:renove_provider/models/Contractor/post/show_all_posts_model.dart';

class PostProvider extends ChangeNotifier {
  bool isLoading = false;
  List<File> postImages = [];
  List<ShowAllPostsModel> posts = [];

  String formatDate(String date) {
    String timeStamp = date;
    String dateOnly = timeStamp.split('T')[0];
    return dateOnly;
  }

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

  Future<http.Response?> fetchAllPosts() async {
    isLoading = true;

    notifyListeners();

    try {
      final token = await getPrefs('token');
      final response = await http.get(
        Uri.parse("$link/api/all_posts?"),
        headers: {"Accept": "application/json", "Authorization": "Bearer $token"},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        posts = data
            .map((json) => ShowAllPostsModel.fromJson(json as Map<String, dynamic>))
            .toList();
      }
      return response;
    } catch (e) {
      print(e);
      return null;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<http.Response?> addLke(int id) async {
    final token = await getPrefs('token');
    try {
      final response = await http.post(
        Uri.parse("$link/api/posts/$id/like"),
        headers: {"Accept": "application/json", "Authorization": "Bearer $token"},
      );
      return response;
    } catch (e) {
      print(e);
      return null;
    }
  }
}
