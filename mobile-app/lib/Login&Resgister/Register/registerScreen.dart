import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:renova/Extras/theme.dart';
import 'package:renova/Login&Resgister/Register/registerController.dart';
import 'package:renova/Login&Resgister/Register/verifyScreen.dart';

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
                  Obx(
                    () => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              registercontroller.rolecontroller.text = 'user';
                              registercontroller.selectedrole.value = 'user';
                            },

                            child: Text('مستخدم'),
                            style: ElevatedButton.styleFrom(
                              side: BorderSide(
                                color: registercontroller.selectedrole.value == 'user'
                                    ? primarycolor1
                                    : Colors.black,
                                width: registercontroller.selectedrole.value == "user" ? 2 : 1,
                              ),
                              backgroundColor: registercontroller.selectedrole.value == "user"
                                  ? primarycolor2
                                  : Colors.white,
                              foregroundColor: registercontroller.selectedrole.value == "user"
                                  ? primarycolor1
                                  : primarycolor2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 20),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              registercontroller.rolecontroller.text = 'contractor';
                              registercontroller.selectedrole.value = 'contractor';
                            },
                            child: Text('متعهد'),
                            style: ElevatedButton.styleFrom(
                              foregroundColor: registercontroller.selectedrole.value == "contractor"
                                  ? primarycolor1
                                  : Colors.black,

                              backgroundColor: registercontroller.selectedrole.value == "contractor"
                                  ? primarycolor2
                                  : Colors.white,

                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              side: BorderSide(
                                color: registercontroller.selectedrole.value == 'contractor'
                                    ? primarycolor1
                                    : primarycolor2,
                                width: registercontroller.selectedrole.value == "contractor"
                                    ? 2
                                    : 1,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Obx(
                    () => ElevatedButton(
                      onPressed: registercontroller.isLoading.value
                          ? null
                          : () async {
                              FocusScope.of(context).unfocus();
                              final response = await registercontroller.register();
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
                                Get.to(() => Verifyscreen());
                              } else {
                                String error = result['message'];
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(error),
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                                print(response.body);
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(double.infinity, 60),
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
