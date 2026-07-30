import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:renove_provider/extras/link.dart';
import 'package:renove_provider/extras/shared_preferneces.dart';
import 'package:renove_provider/models/Contractor/construction%20forms/create_construction_form.dart';

class InspectionFormProvider extends ChangeNotifier {
  bool isLoading = false;

  File? pdfFile;

  final List<MaterialModel> materials = [];

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
}
