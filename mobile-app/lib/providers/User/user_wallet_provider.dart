import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:renove_provider/extras/link.dart';
import 'package:renove_provider/extras/shared_preferneces.dart';
import 'package:renove_provider/models/Contractor/wallet/wallet_details.dart';
import 'package:renove_provider/models/Contractor/wallet/wallet_index.dart';
import 'package:renove_provider/models/User/wallet/user_wallet_details.dart';
import 'package:renove_provider/models/User/wallet/user_wallet_index.dart';

class UserWalletProvider extends ChangeNotifier {
  bool isLoading = false;
  PaymentUserDetailsModel? paymentDetails;
  UserWalletIndex? wallet;

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
          wallet = UserWalletIndex.fromJson(data[0]);
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
          paymentDetails = PaymentUserDetailsModel.fromJson(data[0]);
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
}
