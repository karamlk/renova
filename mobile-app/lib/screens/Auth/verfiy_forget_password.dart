import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:renove_provider/extras/theme.dart';
import 'package:renove_provider/providers/auth_provider.dart';
import 'package:renove_provider/screens/Auth/reset_password.dart';

class VerfiyForgetPassword extends StatefulWidget {
  const VerfiyForgetPassword({super.key, required this.email});
  final String email;

  @override
  State<VerfiyForgetPassword> createState() => VerfiyForgetPasswordState();
}

class VerfiyForgetPasswordState extends State<VerfiyForgetPassword> {
  final TextEditingController verifycontroller = TextEditingController();

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

                    controller: verifycontroller,
                    enabled: !value.isVerifying,

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
                    onPressed: (verifycontroller.text.length == 6 && !value.isVerifying)
                        ? () async {
                            FocusScope.of(context).unfocus();
                            final scaffold = ScaffoldMessenger.of(context);
                            final navigator = Navigator.of(context);
                            final response = await context.read<AuthProvider>().verifyTemp(
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
                              navigator.push(
                                MaterialPageRoute(
                                  builder: (context) => ResetPassword(emailReset: widget.email),
                                ),
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
                      backgroundColor: primarycolor2,
                      foregroundColor: primarycolor1,

                      minimumSize: Size(double.infinity, 60),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),

                    child: value.isVerifying
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
