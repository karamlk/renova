import 'package:engineer_app/extras/theme.dart';
import 'package:engineer_app/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});
  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final email = TextEditingController();
  final otp = TextEditingController();
  final password = TextEditingController();
  final confirmation = TextEditingController();
  int step = 0;

  @override
  void dispose() {
    email.dispose();
    otp.dispose();
    password.dispose();
    confirmation.dispose();
    super.dispose();
  }

  Future<void> _continue() async {
    final auth = context.read<AuthProvider>();
    final ApiResult result;
    if (step == 0) {
      result = await auth.forgotPassword(email.text);
    } else if (step == 1) {
      result = await auth.verifyResetOtp(otp.text);
    } else {
      result = await auth.resetPassword(password.text, confirmation.text);
    }
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(result.message)));
    if (!result.success) return;
    if (step == 2) {
      Navigator.pop(context);
    } else {
      setState(() => step++);
    }
  }

  @override
  Widget build(BuildContext context) {
    final loading = context.watch<AuthProvider>().isLoading;
    final title = [
      'استعادة كلمة المرور',
      'التحقق من الرمز',
      'كلمة مرور جديدة',
    ][step];
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 35),
            Icon(
              step == 0
                  ? Icons.mail_outline
                  : step == 1
                  ? Icons.password_outlined
                  : Icons.lock_reset,
              color: primarycolor2,
              size: 70,
            ),
            const SizedBox(height: 24),
            Text(
              _helpText,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 28),
            _currentField(),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(54),
                backgroundColor: primarycolor2,
                foregroundColor: primarycolor1,
              ),
              onPressed: loading ? null : _continue,
              child: loading
                  ? const CircularProgressIndicator(color: primarycolor1)
                  : Text(
                      step == 0
                          ? 'إرسال الرمز'
                          : step == 1
                          ? 'تحقق'
                          : 'تغيير كلمة المرور',
                    ),
            ),
            if (step == 1)
              TextButton(
                onPressed: () async {
                  final result = await context.read<AuthProvider>().resendOtp();
                  if (mounted)
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(result.message)));
                },
                child: const Text('إعادة إرسال الرمز'),
              ),
          ],
        ),
      ),
    );
  }

  String get _helpText => step == 0
      ? 'أدخل بريدك الإلكتروني لإرسال رمز التحقق.'
      : step == 1
      ? 'أدخل رمز OTP المكوّن من 6 أرقام.'
      : 'أدخل كلمة المرور الجديدة ثم أكدها.';
  Widget _currentField() {
    if (step == 0)
      return TextField(
        controller: email,
        keyboardType: TextInputType.emailAddress,
        decoration: const InputDecoration(
          labelText: 'البريد الإلكتروني',
          border: OutlineInputBorder(),
        ),
      );
    if (step == 1)
      return TextField(
        controller: otp,
        keyboardType: TextInputType.number,
        maxLength: 6,
        textAlign: TextAlign.center,
        decoration: const InputDecoration(
          labelText: 'رمز التحقق',
          border: OutlineInputBorder(),
        ),
      );
    return Column(
      children: [
        TextField(
          controller: password,
          obscureText: true,
          decoration: const InputDecoration(
            labelText: 'كلمة المرور الجديدة',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: confirmation,
          obscureText: true,
          decoration: const InputDecoration(
            labelText: 'تأكيد كلمة المرور',
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }
}
