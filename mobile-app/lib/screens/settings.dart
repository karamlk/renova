import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:renove_provider/extras/theme.dart';
import 'package:renove_provider/providers/auth_provider.dart';
import 'package:renove_provider/screens/Auth/login_screen.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('الإعدادات'), elevation: 10),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              ElevatedButton(
                onPressed: () async {
                  final scaffold = ScaffoldMessenger.of(context);
                  final navigate = Navigator.of(context);
                  final response = await context.read<AuthProvider>().logout();
                  if (response == null) {
                    print("No response");
                    return;
                  }
                  final result = jsonDecode(response.body);

                  if (response.statusCode == 200 || response.statusCode == 201) {
                    String success = result['message'];
                    navigate.push(MaterialPageRoute(builder: (context) => LoginScreen()));
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
                  elevation: 0,

                  minimumSize: Size(double.infinity, 60),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  backgroundColor: Color(0xFFe4e6f2),
                  foregroundColor: primarycolor1,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,

                  children: [
                    Consumer<AuthProvider>(
                      builder: (context, value, child) => value.isLoading
                          ? CircularProgressIndicator(strokeWidth: 4, color: Color(0xFFF59B4A))
                          : SizedBox(width: 5),
                    ),
                    Spacer(),

                    Row(
                      spacing: 20,
                      children: [
                        Text(
                          'تسجيل الخروج',
                          textAlign: TextAlign.right,
                          style: TextStyle(fontSize: 20),
                        ),
                        Icon(Icons.logout),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
