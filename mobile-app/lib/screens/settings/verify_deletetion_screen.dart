import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:renove_provider/extras/theme.dart';
import 'package:renove_provider/providers/auth_provider.dart';
import 'package:renove_provider/screens/Auth/login_screen.dart';

class VerifyDeletetionScreen extends StatefulWidget {
  const VerifyDeletetionScreen({super.key});

  @override
  State<VerifyDeletetionScreen> createState() => _VerifyDeletetionScreenState();
}

class _VerifyDeletetionScreenState extends State<VerifyDeletetionScreen> {
  final TextEditingController deletion = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Verification', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                SizedBox(height: 200),
                Consumer<AuthProvider>(
                  builder: (context, value, child) => TextField(
                    onChanged: (value) {
                      context.read<AuthProvider>().setOtp(value);
                    },
                    keyboardType: TextInputType.number,
                    maxLength: 6,

                    controller: deletion,
                    enabled: !value.isDeleting,

                    decoration: InputDecoration(
                      labelText: 'OTP',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      counterText: '',
                    ),
                  ),
                ),

                SizedBox(height: 20),

                Consumer<AuthProvider>(
                  builder: (context, value, child) => ElevatedButton(
                    onPressed: (value.isValidDelete && !value.isDeleting)
                        ? () async {
                            final scaffold = ScaffoldMessenger.of(context);
                            final navigator = Navigator.of(context);
                            final response = await context.read<AuthProvider>().confirmDeletion(
                              value.otp,
                            );
                            if (response == null) return;
                            final data = jsonDecode(response.body);
                            if (response.statusCode == 200 || response.statusCode == 201) {
                              scaffold.showSnackBar(
                                SnackBar(
                                  content: Text(
                                    data['message'],
                                    textAlign: TextAlign.right,
                                    textDirection: TextDirection.rtl,
                                  ),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                              navigator.pushAndRemoveUntil(
                                MaterialPageRoute(builder: (context) => LoginScreen()),
                                (route) => false,
                              );
                            } else {
                              scaffold.showSnackBar(
                                SnackBar(
                                  content: Text(
                                    data['message'],
                                    textAlign: TextAlign.right,
                                    textDirection: TextDirection.rtl,
                                  ),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            }
                          }
                        : null,

                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 60),

                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      backgroundColor: primarycolor2,
                      foregroundColor: primarycolor1,
                    ),

                    child: value.isDeleting
                        ? CircularProgressIndicator(strokeWidth: 4, color: Color(0xFFF59B4A))
                        : Text('Verify', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),

                SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
