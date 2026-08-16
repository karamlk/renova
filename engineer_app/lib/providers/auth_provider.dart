import 'dart:convert';
import 'package:engineer_app/extras/api_config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiResult {
  const ApiResult(this.success, this.message);
  final bool success;
  final String message;
}

class AuthProvider extends ChangeNotifier {
  bool isLoading = false, isLoggedIn = false;
  String? token, resetToken, resetEmail;
  AuthProvider() {
    loadSession();
  }
  Map<String, String> get _headers => {
    'Accept': 'application/json',
    'Content-Type': 'application/json',
  };
  Future<void> loadSession() async {
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    isLoggedIn = token != null && token!.isNotEmpty;
    notifyListeners();
  }

  Future<ApiResult> login(String email, String password) async {
    isLoading = true;
    notifyListeners();
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/login'),
        headers: _headers,
        body: jsonEncode({'email': email.trim(), 'password': password}),
      );
      final body = _body(response);
      if (response.statusCode >= 200 && response.statusCode < 300) {
        if (body['role'] != 'engineer')
          return const ApiResult(false, 'هذا الحساب ليس حساب مهندس.');
        token = body['token']?.toString();
        if (token == null || token!.isEmpty)
          return const ApiResult(false, 'لم يتم استلام رمز الدخول.');
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token!);
        isLoggedIn = true;
        return ApiResult(
          true,
          body['message']?.toString() ?? 'تم تسجيل الدخول بنجاح.',
        );
      }
      return ApiResult(
        false,
        body['message']?.toString() ?? 'تعذر تسجيل الدخول.',
      );
    } catch (_) {
      return const ApiResult(false, 'تعذر الاتصال بالخادم المحلي.');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<ApiResult> forgotPassword(String email) async {
    isLoading = true;
    notifyListeners();
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/password/forgot'),
        headers: _headers,
        body: jsonEncode({'email': email.trim()}),
      );
      final body = _body(response);
      if (response.statusCode >= 200 && response.statusCode < 300) {
        resetToken = body['temp_token']?.toString();
        resetEmail = email.trim();
        return ApiResult(
          resetToken == null ? false : true,
          body['message']?.toString() ?? 'تم إرسال الرمز.',
        );
      }
      return ApiResult(
        false,
        body['message']?.toString() ?? 'تعذر إرسال الرمز.',
      );
    } catch (_) {
      return const ApiResult(false, 'تعذر الاتصال بالخادم المحلي.');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<ApiResult> verifyResetOtp(String otp) async {
    if (resetToken == null)
      return const ApiResult(false, 'ابدأ بإرسال الرمز أولاً.');
    isLoading = true;
    notifyListeners();
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/otp/verify'),
        headers: {..._headers, 'Authorization': 'Bearer $resetToken'},
        body: jsonEncode({'otp': otp}),
      );
      final body = _body(response);
      return ApiResult(
        response.statusCode >= 200 && response.statusCode < 300,
        body['message']?.toString() ?? 'تعذر التحقق من الرمز.',
      );
    } catch (_) {
      return const ApiResult(false, 'تعذر الاتصال بالخادم المحلي.');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<ApiResult> resendOtp() async {
    if (resetToken == null)
      return const ApiResult(false, 'رمز الاستعادة غير متوفر.');
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/otp/resend'),
        headers: {..._headers, 'Authorization': 'Bearer $resetToken'},
      );
      final body = _body(response);
      return ApiResult(
        response.statusCode >= 200 && response.statusCode < 300,
        body['message']?.toString() ?? 'تعذر إعادة الإرسال.',
      );
    } catch (_) {
      return const ApiResult(false, 'تعذر الاتصال بالخادم المحلي.');
    }
  }

  Future<ApiResult> resetPassword(String password, String confirmation) async {
    if (resetEmail == null)
      return const ApiResult(false, 'البريد الإلكتروني غير متوفر.');
    isLoading = true;
    notifyListeners();
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/password/reset'),
        headers: _headers,
        body: jsonEncode({
          'email': resetEmail,
          'password': password,
          'password_confirmation': confirmation,
        }),
      );
      final body = _body(response);
      if (response.statusCode >= 200 && response.statusCode < 300) {
        resetToken = null;
        return ApiResult(
          true,
          body['message']?.toString() ?? 'تم تغيير كلمة المرور.',
        );
      }
      return ApiResult(
        false,
        body['message']?.toString() ?? 'تعذر تغيير كلمة المرور.',
      );
    } catch (_) {
      return const ApiResult(false, 'تعذر الاتصال بالخادم المحلي.');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    if (token != null) {
      try {
        await http.post(
          Uri.parse('${ApiConfig.baseUrl}/logout'),
          headers: {..._headers, 'Authorization': 'Bearer $token'},
        );
      } catch (_) {}
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    token = null;
    isLoggedIn = false;
    notifyListeners();
  }

  Map<String, dynamic> _body(http.Response response) {
    try {
      return Map<String, dynamic>.from(jsonDecode(response.body) as Map);
    } catch (_) {
      return {};
    }
  }
}
