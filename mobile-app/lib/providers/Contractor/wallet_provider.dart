import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:renove_provider/extras/link.dart';
import 'package:renove_provider/extras/shared_preferneces.dart';
import 'package:renove_provider/models/Contractor/wallet/engineers_list.dart';
import 'package:renove_provider/models/Contractor/wallet/wallet_details.dart';
import 'package:renove_provider/models/Contractor/wallet/wallet_index.dart';

class WalletProvider extends ChangeNotifier {
  bool isLoading = false;
  bool isTransfer = false;
  PaymentDetailsModel? paymentDetails;
  WalletModel? wallet;
  List<EngineerModel> engineers = [];

  Future<void> fetchWallet() async {
    isLoading = true;

    notifyListeners();

    try {
      final token = await getPrefs("token");

      final response = await http.get(
        Uri.parse("$link/api/wallet"),
        headers: {"Accept": "application/json", "Authorization": "Bearer $token"},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        if (data.isNotEmpty) {
          wallet = WalletModel.fromJson(data[0]);
        }
      }
    } catch (e) {
      print(e);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<http.Response?> fetchPaymentDetails(int id) async {
    isLoading = true;

    notifyListeners();

    try {
      final token = await getPrefs("token");

      final response = await http.get(
        Uri.parse("$link/api/payments/$id"),
        headers: {"Accept": "application/json", "Authorization": "Bearer $token"},
      );
      print(response.statusCode);
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        if (data.isNotEmpty) {
          paymentDetails = PaymentDetailsModel.fromJson(data[0]);
        }
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

  Future<http.Response?> fetchEngineers() async {
    isLoading = true;

    notifyListeners();

    try {
      final token = await getPrefs("token");
      final response = await http.get(
        headers: {"Accept": "application/json", "Authorization": "Bearer $token"},
        Uri.parse('$link/api/wallet/contractor-engineers'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        engineers = data.map((item) => EngineerModel.fromJson(item)).toList();
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

  Future<http.Response?> transferMoney(String cardNubmer, String amount, String desciption) async {
    isTransfer = true;
    notifyListeners();
    try {
      final token = await getPrefs("token");
      final response = await http.post(
        headers: {"Accept": "application/json", "Authorization": "Bearer $token"},
        Uri.parse('$link/api/wallet/transfer'),
        body: {'card_number': cardNubmer, 'amount': amount, 'description': desciption},
      );
      return response;
    } catch (e) {
      print(e);
      return null;
    } finally {
      isTransfer = false;
      notifyListeners();
    }
  }
}
