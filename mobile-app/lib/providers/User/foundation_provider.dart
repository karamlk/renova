import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:renove_provider/extras/link.dart';
import 'package:renove_provider/extras/shared_preferneces.dart';
import 'package:renove_provider/extras/theme.dart';
import 'package:renove_provider/models/User/verification/campaign_details.dart';
import 'package:renove_provider/models/User/verification/campaign_index.dart';
import 'package:renove_provider/models/User/verification/donation_model.dart';
import 'package:renove_provider/models/User/verification/verify_model.dart';
import 'package:renove_provider/providers/theme_provider.dart';

class FoundationProvider extends ChangeNotifier {
  bool isLoading = false;
  bool isLoadingDetails = true;
  List<File> selectedFiles = [];
  List<File> selectedImages = [];
  final ImagePicker picker = ImagePicker();
  final TextEditingController fromDateController = TextEditingController();
  final TextEditingController toDateController = TextEditingController();
  DateTime? selectedDate;
  CampaignIndex? campaignIndex;
  List<CampaignData> get campaigns => campaignIndex?.data ?? [];
  CampaignDataDetails? selectedCampaignDetails;
  bool isDeleting = false;
  Future<void> pickFiles() async {
    final result = await FilePicker.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      selectedFiles.addAll(result.paths.where((path) => path != null).map((path) => File(path!)));

      notifyListeners();
    }
  }

  Future<void> pickImages() async {
    final result = await FilePicker.pickFiles(allowMultiple: true, type: FileType.image);

    if (result != null) {
      final newImages = result.paths.whereType<String>().map((e) => File(e)).toList();

      selectedImages.addAll(newImages);

      notifyListeners();
    }
  }

  void removeFile(int index) {
    selectedFiles.removeAt(index);
    notifyListeners();
  }

  void removeImage(int index) {
    selectedImages.removeAt(index);
    notifyListeners();
  }

  void clearFiles() {
    selectedFiles.clear();
    notifyListeners();
  }

  void clearImages() {
    selectedImages.clear();
    notifyListeners();
  }

  Future<http.Response?> verifyFoundation({required Verify verify}) async {
    isLoading = true;
    notifyListeners();

    try {
      final token = await getPrefs("token");

      final request = http.MultipartRequest("POST", Uri.parse("$link/api/foundation/verification"));

      request.headers.addAll({"Accept": "application/json", "Authorization": "Bearer $token"});

      // Text fields
      request.fields["foundation_name"] = verify.foundationName;
      request.fields["description"] = verify.description;
      request.fields["registration_number"] = verify.registrationNumber;

      // Documents
      for (File document in verify.documents) {
        request.files.add(await http.MultipartFile.fromPath("documents[]", document.path));
      }

      final streamedResponse = await request.send();

      final response = await http.Response.fromStream(streamedResponse);

      return response;
    } catch (e) {
      debugPrint("verifyFoundation error: $e");
      return null;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> selectFromDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: context.read<ThemeProvider>().isDark
                    ? primarycolor1
                    : primarycolor2,
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      selectedDate = picked;
      // Format with leading zeros for month/day (e.g., 2026/08/18)
      String formattedMonth = picked.month.toString().padLeft(2, '0');
      String formattedDay = picked.day.toString().padLeft(2, '0');

      fromDateController.text = "${picked.year}/$formattedMonth/$formattedDay";
      notifyListeners();
    }
  }

  Future<void> selectToDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: context.read<ThemeProvider>().isDark
                    ? primarycolor1
                    : primarycolor2,
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      selectedDate = picked;
      // Format with leading zeros for month/day (e.g., 2026/08/18)
      String formattedMonth = picked.month.toString().padLeft(2, '0');
      String formattedDay = picked.day.toString().padLeft(2, '0');

      toDateController.text = "${picked.year}/$formattedMonth/$formattedDay";
      notifyListeners();
    }
  }

  @override
  void dispose() {
    fromDateController.dispose();
    toDateController.dispose();
    super.dispose();
  }

  Future<http.Response?> createCampaign(DonationCampaign campaign) async {
    isLoading = true;
    notifyListeners();

    try {
      final token = await getPrefs("token");
      final uri = Uri.parse("$link/api/foundation/donation-campaigns");

      // Initialize MultipartRequest for POST request
      var request = http.MultipartRequest('POST', uri);

      // Add Headers
      request.headers.addAll({'Accept': 'application/json', 'Authorization': 'Bearer $token'});

      // Add Text Fields
      request.fields.addAll(campaign.toMap());

      // Add File Array (images[])
      for (File imageFile in campaign.images) {
        var multipartFile = await http.MultipartFile.fromPath('images[]', imageFile.path);
        request.files.add(multipartFile);
      }

      // Send Request
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      return response;
    } catch (e) {
      debugPrint("Error creating donation campaign: $e");
      return null;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<http.Response?> fetchDonationCampaigns() async {
    isLoading = true;

    notifyListeners();

    try {
      final token = await getPrefs("token");
      final uri = Uri.parse("$link/api/foundation/donation-campaigns");

      final response = await http.get(
        uri,
        headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        campaignIndex = CampaignIndex.fromJson(jsonResponse);
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

  Future<http.Response?> fetchCampaignDetails(int campaignId) async {
    isLoadingDetails = true;

    notifyListeners();

    try {
      final token = await getPrefs("token");
      final uri = Uri.parse("$link/api/foundation/donation-campaigns/$campaignId");

      final response = await http.get(
        uri,
        headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        final campaignDetails = CampaignDetails.fromJson(jsonResponse);
        selectedCampaignDetails = campaignDetails.data;
      }
      return response;
    } catch (e) {
      print(e);
      return null;
    } finally {
      isLoadingDetails = false;
      notifyListeners();
    }
  }

  Future<http.Response?> delete(int id) async {
    isDeleting = true;
    notifyListeners();
    try {
      final token = await getPrefs("token");
      final uri = Uri.parse("$link/api/foundation/donation-campaigns/$id");

      final response = await http.delete(
        uri,
        headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
      );

      return response;
    } catch (e) {
      print(e);
      return null;
    } finally {
      isDeleting = false;
      notifyListeners();
    }
  }
}
