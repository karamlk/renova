import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:renove_provider/providers/auth_provider.dart';
import 'package:renove_provider/screens/register_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailcontroller = TextEditingController();
    final TextEditingController passwordcontroller = TextEditingController();
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: const Color(0XFFFEFCFF),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Column(
                    children: [
                      SizedBox(height: 100),
                      Image.asset("assets/icon.jpg", height: 150, width: 500),
                      SizedBox(height: 50),
                      TextField(
                        controller: emailcontroller,
                        decoration: InputDecoration(
                          labelText: "البريد الإلكتروني",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      TextField(
                        controller: passwordcontroller,
                        decoration: InputDecoration(
                          labelText: "كلمة المرور",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Consumer<AuthProvider>(
                        builder: (context, provider, child) => ElevatedButton(
                          onPressed: provider.isLoading
                              ? null
                              : () async {
                                  FocusScope.of(context).unfocus();
                                  final scaffold = ScaffoldMessenger.of(context);
                                  final response = await context.read<AuthProvider>().login(
                                    emailcontroller.text,
                                    passwordcontroller.text,
                                  );
                                  if (response == null) {
                                    print("No response");
                                    return;
                                  }
                                  final result = jsonDecode(response.body);
                                  if (response.statusCode == 200 || response.statusCode == 201) {
                                    String success = result['message'];
                                    scaffold.showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          success,
                                          textAlign: TextAlign.right,
                                          textDirection: TextDirection.rtl,
                                        ),
                                        behavior: SnackBarBehavior.floating,
                                      ),
                                    );
                                  } else {
                                    String error = result['message'];
                                    scaffold.showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          error,
                                          textAlign: TextAlign.right,
                                          textDirection: TextDirection.rtl,
                                        ),
                                        behavior: SnackBarBehavior.floating,
                                      ),
                                    );
                                  }
                                },

                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(double.infinity, 60),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            backgroundColor: Color(0xFF3b414c),
                            foregroundColor: Color(0xFFF59B4A),
                            disabledBackgroundColor: Color(0xFF3b414c),
                          ),
                          child: provider.isLoading
                              ? CircularProgressIndicator(strokeWidth: 4, color: Color(0xFFF59B4A))
                              : Text("تسجيل الدخول", style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ),

                      TextButton(
                        onPressed: () {},

                        style: TextButton.styleFrom(minimumSize: Size(0, 0)),
                        child: Text(
                          "نسيت كلمة المرور؟",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Text("أو", style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => RegisterScreen()),
                      );
                    },

                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 60),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      backgroundColor: Color(0xFF3b414c),
                      foregroundColor: Color(0xFFb8bcbf),
                    ),
                    child: Text("إنشاء حساب جديد", style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
