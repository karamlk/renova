import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/state_manager.dart';
import 'package:renova/Login&Resgister/Login/loginController.dart';
import 'package:renova/Login&Resgister/Register/registerController.dart';
import 'package:renova/Login&Resgister/Register/registerScreen.dart';

class Login extends StatelessWidget {
  Login({super.key});

  final Logincontroller logincontroller = Get.put(Logincontroller());
  @override
  Widget build(BuildContext context) {
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
                      Image.asset("assets/images/icon.jpg", height: 150, width: 500),
                      SizedBox(height: 50),
                      TextField(
                        controller: logincontroller.emailnamecontroller,
                        decoration: InputDecoration(
                          labelText: "البريد الإلكتروني",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      TextField(
                        controller: logincontroller.passwordcontroller,
                        decoration: InputDecoration(
                          labelText: "كلمة المرور",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Obx(
                        () => ElevatedButton(
                          onPressed: logincontroller.isLoading.value
                              ? null
                              : () async {
                                  FocusScope.of(context).unfocus();
                                  final response = await logincontroller.login();
                                  if (response == null) {
                                    print("No response");
                                    return;
                                  }
                                  final result = jsonDecode(response.body);
                                  if (response.statusCode == 200 || response.statusCode == 201) {
                                    String success = result['message'];
                                    ScaffoldMessenger.of(context).showSnackBar(
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
                                    ScaffoldMessenger.of(context).showSnackBar(
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
                          child: logincontroller.isLoading.value
                              ? CircularProgressIndicator(strokeWidth: 4, color: Color(0xFFF59B4A))
                              : Text("تسجيل الدخول", style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          "نسيت كلمة المرور؟",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        style: TextButton.styleFrom(minimumSize: Size(0, 0)),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Text("أو", style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      Get.to(() => Registerscreen());
                    },
                    child: Text("إنشاء حساب جديد", style: TextStyle(fontWeight: FontWeight.bold)),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 60),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      backgroundColor: Color(0xFF3b414c),
                      foregroundColor: Color(0xFFb8bcbf),
                    ),
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
