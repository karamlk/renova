import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:renova/Login&Resgister/Register/registerScreen.dart';

class Login extends StatelessWidget {
  Login({super.key});

  final TextEditingController emailnamecontroller = TextEditingController();
  final TextEditingController passwordcontroller = TextEditingController();
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
                        controller: emailnamecontroller,
                        decoration: InputDecoration(
                          labelText: "البريد الإلكتروني",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      TextField(
                        controller: emailnamecontroller,
                        decoration: InputDecoration(
                          labelText: "كلمة المرور",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {},

                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          backgroundColor: Color(0xFF3b414c),
                          foregroundColor: Color(0xFFF59B4A),
                        ),
                        child: Text("تسجيل الدخول", style: TextStyle(fontWeight: FontWeight.bold)),
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
                      minimumSize: Size(double.infinity, 50),
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
