import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:renove_provider/extras/link.dart';
import 'package:renove_provider/extras/shared_preferneces.dart';
import 'package:renove_provider/models/User/invoices/invoices_details.dart';
import 'package:renove_provider/models/User/invoices/invoices_index.dart';
import 'package:url_launcher/url_launcher.dart';

class InvoiceProvider extends ChangeNotifier {
  bool isLoading = false;

  List<Invoice> invoices = [];
  InvoiceDetails? details;

  Future<http.Response?> fetchInvoices() async {
    isLoading = true;
    notifyListeners();

    try {
      final token = await getPrefs('token');

      final response = await http.get(
        Uri.parse('$link/api/my-invoices'),
        headers: {"Accept": "application/json", "Authorization": "Bearer $token"},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final List data = jsonDecode(response.body);

        invoices = data.map((e) => Invoice.fromJson(e)).toList();
      }

      return response;
    } catch (e) {
      debugPrint(e.toString());
      return null;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<http.Response?> fetchInvoiceDetails(int id) async {
    isLoading = true;
    notifyListeners();

    try {
      final token = await getPrefs('token');

      final response = await http.get(
        Uri.parse('$link/api/invoice/$id'),
        headers: {"Accept": "application/json", "Authorization": "Bearer $token"},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        details = InvoiceDetails.fromJson(jsonDecode(response.body));
      }

      return response;
    } catch (e) {
      debugPrint(e.toString());
      return null;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void clearDetails() {
    details = null;
    notifyListeners();
  }

  Future<void> openPdf(String url) async {
    final uri = Uri.parse(url);

    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not open PDF');
    }
  }
}
