import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:renove_provider/extras/theme.dart';
import 'package:renove_provider/models/register_model.dart';
import 'package:renove_provider/providers/auth_provider.dart';
import 'package:renove_provider/screens/verify_screen.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});
  final TextEditingController namecontroller = TextEditingController();
  final TextEditingController emailcontroller = TextEditingController();
  final TextEditingController passwordcontroller = TextEditingController();
  final TextEditingController passwordconfirmcontroller = TextEditingController();
  final TextEditingController rolecontroller = TextEditingController();

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
                    controller: namecontroller,
                    decoration: InputDecoration(
                      labelText: "الاسم",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                    ),
                  ),
                  TextField(
                    controller: emailcontroller,
                    decoration: InputDecoration(
                      labelText: "البريد الالكتروني",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                    ),
                  ),
                  TextField(
                    controller: passwordcontroller,
                    decoration: InputDecoration(
                      labelText: "كلمة المرور",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                    ),
                  ),
                  TextField(
                    controller: passwordconfirmcontroller,
                    decoration: InputDecoration(
                      labelText: "كلمة المرور مرة أخرى",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                    ),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Consumer<AuthProvider>(
                          builder: (context, provider, child) => ElevatedButton(
                            onPressed: () {
                              rolecontroller.text = 'user';
                              context.read<AuthProvider>().setRole('user');
                            },
                            style: ElevatedButton.styleFrom(
                              side: BorderSide(
                                color: provider.selectedrole == 'user'
                                    ? primarycolor1
                                    : Colors.black,
                                width: provider.selectedrole == "user" ? 2 : 1,
                              ),
                              backgroundColor: provider.selectedrole == "user"
                                  ? primarycolor2
                                  : Colors.white,
                              foregroundColor: provider.selectedrole == "user"
                                  ? primarycolor1
                                  : primarycolor2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),

                            child: Text('مستخدم'),
                          ),
                        ),
                      ),
                      SizedBox(width: 20),
                      Expanded(
                        child: Consumer<AuthProvider>(
                          builder: (context, provider, child) => ElevatedButton(
                            onPressed: () {
                              rolecontroller.text = 'contractor';
                              context.read<AuthProvider>().setRole('contractor');
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: provider.selectedrole == "contractor"
                                  ? primarycolor1
                                  : Colors.black,

                              backgroundColor: provider.selectedrole == "contractor"
                                  ? primarycolor2
                                  : Colors.white,

                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              side: BorderSide(
                                color: provider.selectedrole == 'contractor'
                                    ? primarycolor1
                                    : primarycolor2,
                                width: provider.selectedrole == "contractor" ? 2 : 1,
                              ),
                            ),
                            child: Text('متعهد'),
                          ),
                        ),
                      ),
                    ],
                  ),

                  Consumer<AuthProvider>(
                    builder: (context, value, child) => ElevatedButton(
                      onPressed: value.isLoading
                          ? null
                          : () async {
                              FocusScope.of(context).unfocus();
                              final navigator = Navigator.of(context);
                              final scaffold = ScaffoldMessenger.of(context);
                              final response = await context.read<AuthProvider>().register(
                                RegisterModel(
                                  name: namecontroller.text,
                                  email: emailcontroller.text,
                                  password: passwordcontroller.text,
                                  passwordconfirmation: passwordconfirmcontroller.text,
                                  role: rolecontroller.text,
                                ),
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

                                navigator.push(
                                  MaterialPageRoute(
                                    builder: (context) => Verifyscreen(email: emailcontroller.text),
                                  ),
                                );
                              } else {
                                String error = result['message'];
                                scaffold.showSnackBar(
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
                      child: value.isLoading
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
