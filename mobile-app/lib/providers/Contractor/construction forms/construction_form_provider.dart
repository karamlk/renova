import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:renove_provider/extras/link.dart';
import 'package:renove_provider/extras/shared_preferneces.dart';
import 'package:renove_provider/models/Contractor/construction%20forms/create_construction_form.dart';
import 'package:renove_provider/models/Contractor/construction%20forms/forms_index.dart';
import 'package:renove_provider/models/Contractor/construction%20forms/rejected_forms.dart';
import 'package:url_launcher/url_launcher.dart';

class InspectionFormProvider extends ChangeNotifier {
  bool isLoading = false;

  File? pdfFile;
  ConstructionFormDetails? formDetails;
  List<RejectedForms> rejected = [];

  bool isDetailsLoading = false;

  final List<MaterialModel> materials = [];
  List<ConstructionFormDetails> forms = [];

  bool isFormsLoading = false;

  Future<void> pickPdf() async {
    final result = await FilePicker.pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);

    if (result != null) {
      pdfFile = File(result.files.single.path!);
      notifyListeners();
    }
  }

  void removePdf() {
    pdfFile = null;
    notifyListeners();
  }

  void addMaterial(MaterialModel material) {
    materials.add(material);
    notifyListeners();
  }

  void removeMaterial(int index) {
    materials.removeAt(index);
    notifyListeners();
  }

  void clearMaterials() {
    materials.clear();
    notifyListeners();
  }

  Future<http.Response?> submitInspection(InspectionFormModel form) async {
    isLoading = true;
    notifyListeners();

    try {
      final token = await getPrefs("token");

      var request = http.MultipartRequest("POST", Uri.parse("$link/api/construction-forms"));

      request.headers.addAll({"Accept": "application/json", "Authorization": "Bearer $token"});

      request.fields["reconstruction_request_id"] = form.reconstructionRequestId.toString();

      request.fields["contractor_id"] = form.contractorId.toString();

      request.fields["engineer_id"] = form.engineerId.toString();

      request.fields["building_description"] = form.buildingDescription;

      request.fields["warranty_period"] = form.warrantyPeriod;

      request.fields["execution_duration"] = form.executionDuration;

      request.fields["materials_cost"] = form.materialsCost.toString();

      request.fields["labor_cost"] = form.laborCost.toString();

      request.fields["profit"] = form.profit.toString();

      request.fields["materials"] = jsonEncode(form.materials.map((e) => e.toJson()).toList());

      if (pdfFile != null) {
        request.files.add(await http.MultipartFile.fromPath("pdf_file", pdfFile!.path));
      }

      final streamed = await request.send();

      return await http.Response.fromStream(streamed);
    } catch (e) {
      debugPrint(e.toString());
      return null;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void reset() {
    pdfFile = null;
    materials.clear();
    notifyListeners();
  }

  Future<http.Response?> fetchForms() async {
    isFormsLoading = true;
    notifyListeners();

    try {
      final token = await getPrefs("token");

      final response = await http.get(
        Uri.parse("$link/api/construction-forms"),
        headers: {"Accept": "application/json", "Authorization": "Bearer $token"},
      );

      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);

        forms = data.map((e) => ConstructionFormDetails.fromJson(e)).toList();
      }
      return response;
    } catch (e) {
      debugPrint(e.toString());
      return null;
    } finally {
      isFormsLoading = false;
      notifyListeners();
    }
  }

  Future<http.Response?> fetchFormDetails(int id) async {
    isDetailsLoading = true;
    notifyListeners();

    try {
      final token = await getPrefs("token");

      final response = await http.get(
        Uri.parse("$link/api/construction-forms/$id"),
        headers: {"Accept": "application/json", "Authorization": "Bearer $token"},
      );

      if (response.statusCode == 200) {
        formDetails = ConstructionFormDetails.fromJson(jsonDecode(response.body));
      }
      return response;
    } catch (e) {
      debugPrint(e.toString());
      return null;
    } finally {
      isDetailsLoading = false;
      notifyListeners();
    }
  }

  Future<http.Response?> updateInspection({
    required int id,
    required InspectionFormModel form,
  }) async {
    isLoading = true;
    notifyListeners();

    try {
      final token = await getPrefs("token");

      final request = http.MultipartRequest("POST", Uri.parse("$link/api/construction-forms/$id"));

      request.headers.addAll({"Accept": "application/json", "Authorization": "Bearer $token"});

      request.fields["reconstruction_request_id"] = form.reconstructionRequestId.toString();

      request.fields["contractor_id"] = form.contractorId.toString();

      request.fields["engineer_id"] = form.engineerId.toString();

      request.fields["building_description"] = form.buildingDescription;

      request.fields["warranty_period"] = form.warrantyPeriod;

      request.fields["execution_duration"] = form.executionDuration;

      request.fields["materials_cost"] = form.materialsCost.toString();

      request.fields["labor_cost"] = form.laborCost.toString();

      request.fields["profit"] = form.profit.toString();

      request.fields["materials"] = jsonEncode(form.materials.map((e) => e.toJson()).toList());

      if (pdfFile != null) {
        request.files.add(await http.MultipartFile.fromPath("pdf_file", pdfFile!.path));
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

  Future<http.Response?> deleteForm({required int reconstructionRequestId}) async {
    try {
      final token = await getPrefs("token");

      final response = await http.delete(
        Uri.parse("$link/api/construction-forms/$reconstructionRequestId"),
        headers: {"Accept": "application/json", "Authorization": "Bearer $token"},
      );

      return response;
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  Future<http.Response?> fetchRecjectedForms() async {
    isLoading = true;
    notifyListeners();
    final token = await getPrefs('token');
    try {
      final response = await http.get(
        Uri.parse('$link/api/contractor/forms/rejected'),
        headers: {"Accept": "application/json", "Authorization": "Bearer $token"},
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final List data = jsonDecode(response.body);
        rejected = data.map((e) => RejectedForms.fromJson(e)).toList();
        print(response.body);
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

  Future<void> openPdf(String url) async {
    debugPrint("Opening PDF: $url");
    final uri = Uri.parse(url);

    final success = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!success) {
      throw Exception("Could not launch $url");
    }
  }
}
