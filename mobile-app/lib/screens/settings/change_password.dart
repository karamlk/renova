import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:renove_provider/extras/theme.dart';
import 'package:renove_provider/models/change_password_model.dart';
import 'package:renove_provider/providers/auth_provider.dart';

class ChangePassword extends StatefulWidget {
  ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final TextEditingController oldpasswordcontroller = TextEditingController();

  final TextEditingController newpasswordcontroller = TextEditingController();

  final TextEditingController repeatedpasswordcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('تغييير كلمة المرور')),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 25,
              children: [
                SizedBox(height: 20),

                Text(
                  'قم بإدخال كلمة المرور ثم إنشاء كلمة مرور جديدة.',

                  style: TextStyle(fontSize: 20),
                  textAlign: TextAlign.center,
                  textDirection: TextDirection.rtl,
                ),

                Text(
                  'لا يجب أن تكون كلمة المرور الجديدة أقل من 8 أرقام أو أحرف',

                  style: TextStyle(fontSize: 20),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: TextField(
                    controller: oldpasswordcontroller,
                    textDirection: TextDirection.rtl,

                    decoration: InputDecoration(
                      labelText: 'كلمة المرور القديمة',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                    ),
                  ),
                ),
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: TextField(
                    controller: newpasswordcontroller,
                    textDirection: TextDirection.rtl,

                    decoration: InputDecoration(
                      labelText: 'كلمة المرور الجديدة',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                    ),
                  ),
                ),
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: TextField(
                    controller: repeatedpasswordcontroller,
                    textDirection: TextDirection.rtl,

                    decoration: InputDecoration(
                      labelText: 'أدخل كلمة المرور الجديدة مرة أخرى',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                    ),
                  ),
                ),
                Consumer<AuthProvider>(
                  builder: (context, value, child) => ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      minimumSize: Size(double.infinity, 60),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      backgroundColor: primarycolor2,
                      foregroundColor: primarycolor1,
                    ),
                    onPressed: () async {
                      final scaffold = ScaffoldMessenger.of(context);
                      final navigate = Navigator.of(context);
                      FocusScope.of(context).unfocus();
                      final response = await context.read<AuthProvider>().changePassword(
                        oldpasswordcontroller.text,
                        newpasswordcontroller.text,
                        repeatedpasswordcontroller.text,
                      );

                      if (response == null) {
                        print("No response");
                        return;
                      }
                      final result = jsonDecode(response.body);
                      String message = result['message'];
                      if (response.statusCode == 200 || response.statusCode == 201) {
                        navigate.pop();
                        scaffold.showSnackBar(
                          SnackBar(
                            content: Text(
                              style: TextStyle(color: Colors.black),
                              message,
                              textAlign: TextAlign.right,
                              textDirection: TextDirection.rtl,
                            ),
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: Colors.greenAccent,
                          ),
                        );
                      } else {
                        SnackBar(
                          content: Text(
                            style: TextStyle(color: Colors.white),
                            message,
                            textAlign: TextAlign.right,
                            textDirection: TextDirection.rtl,
                          ),
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: Colors.redAccent,
                        );
                      }
                    },

                    child: value.isChanging
                        ? CircularProgressIndicator(strokeWidth: 4, color: primarycolor1)
                        : Text('موافق'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
