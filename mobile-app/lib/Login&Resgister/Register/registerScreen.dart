import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:renova/Login&Resgister/Register/registerController.dart';

class Registerscreen extends StatelessWidget {
  Registerscreen({super.key});
  final Registercontroller registercontroller = Get.put(Registercontroller());

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("إنشاء حساب جديد", style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        body: Directionality(
          textDirection: TextDirection.rtl,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                spacing: 20,
                children: [
                  SizedBox(height: 20),
                  TextField(
                    controller: registercontroller.namecontroller,
                    decoration: InputDecoration(
                      labelText: "الاسم",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                    ),
                  ),
                  TextField(
                    controller: registercontroller.emailcontroller,
                    decoration: InputDecoration(
                      labelText: "البريد الالكتروني",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                    ),
                  ),
                  TextField(
                    controller: registercontroller.passwordcontroller,
                    decoration: InputDecoration(
                      labelText: "كلمة المرور",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                    ),
                  ),
                  TextField(
                    controller: registercontroller.passwordconfirmcontroller,
                    decoration: InputDecoration(
                      labelText: "كلمة المرور مرة أخرى",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                    ),
                  ),
                  TextField(
                    textDirection: TextDirection.rtl,
                    textAlign: TextAlign.right,
                    controller: registercontroller.rolecontroller,
                    decoration: InputDecoration(
                      labelText: "الدور (مستخدم / متعاقد)",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                    ),
                  ),
                  Obx(
                    () => ElevatedButton(
                      onPressed: registercontroller.isLoading.value
                          ? null
                          : () async {
                              final response = await registercontroller.register();
                              if (response == null) {
                                print('no response');
                                return;
                              }
                              if (response.statusCode == 201 || response.statusCode == 200) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("تم إنشاء حسابك بتجاح")),
                                );
                              } else {
                                print(response.body);
                              }
                            },

                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        backgroundColor: Color(0xFF3b414c),
                        foregroundColor: Color(0xFFF59B4A),
                        disabledBackgroundColor: Color(0xFF3b414c),
                      ),
                      child: registercontroller.isLoading.value
                          ? CircularProgressIndicator(strokeWidth: 4, color: Color(0xFFF59B4A))
                          : Text("إنشاء الحساب", style: TextStyle(fontWeight: FontWeight.bold)),
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
