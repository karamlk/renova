import 'package:engineer_app/extras/theme.dart';
import 'package:engineer_app/providers/auth_provider.dart';
import 'package:engineer_app/screens/Auth/forgot_password_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController(),
      passwordController = TextEditingController();
  bool obscurePassword = true;
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    final result = await context.read<AuthProvider>().login(
      emailController.text,
      passwordController.text,
    );
    if (mounted && !result.success)
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(result.message)));
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: () => FocusScope.of(context).unfocus(),
    child: Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 100),
              Image.asset(
                'assets/images/logo1.png',
                width: 190,
                height: 190,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 28),
              const Text(
                'منصة المهندس',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                  color: primarycolor2,
                ),
              ),
              const SizedBox(height: 42),
              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: _decoration(
                  'البريد الإلكتروني',
                  Icons.email_outlined,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: passwordController,
                obscureText: obscurePassword,
                decoration: _decoration('كلمة المرور', Icons.lock_outline)
                    .copyWith(
                      suffixIcon: IconButton(
                        icon: Icon(
                          obscurePassword
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                        ),
                        onPressed: () =>
                            setState(() => obscurePassword = !obscurePassword),
                      ),
                    ),
              ),
              const SizedBox(height: 20),
              Consumer<AuthProvider>(
                builder: (_, auth, _) => ElevatedButton(
                  onPressed: auth.isLoading ? null : _login,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 60),
                    backgroundColor: primarycolor2,
                    foregroundColor: primarycolor1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: auth.isLoading
                      ? const CircularProgressIndicator(color: primarycolor1)
                      : const Text(
                          'تسجيل الدخول',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ForgotPasswordScreen(),
                  ),
                ),
                child: const Text(
                  'نسيت كلمة المرور؟',
                  style: TextStyle(
                    color: primarycolor2,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
  InputDecoration _decoration(String label, IconData icon) => InputDecoration(
    labelText: label,
    prefixIcon: Icon(icon),
    labelStyle: const TextStyle(color: primarycolor2),
    border: const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(10)),
    ),
  );
}
