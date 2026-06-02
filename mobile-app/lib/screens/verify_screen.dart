import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:renove_provider/extras/theme.dart';
import 'package:renove_provider/providers/auth_provider.dart';

class Verifyscreen extends StatefulWidget {
  Verifyscreen({super.key, required this.email});
  final String email;

  @override
  State<Verifyscreen> createState() => _VerifyscreenState();
}

class _VerifyscreenState extends State<Verifyscreen> {
  final TextEditingController verifycontroller = TextEditingController();
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<AuthProvider>().startTimer();
    });
  }

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
                    enabled: !value.isExpired,

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
                    onPressed: (value.isValid && !value.isExpired && !value.isVerifying)
                        ? () async {
                            final scaffold = ScaffoldMessenger.of(context);
                            final response = await context.read<AuthProvider>().verify(value.otp);
                            if (response == null) return;
                            final data = jsonDecode(response.body);
                            if (response.statusCode != 200 || response.statusCode != 201) {
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
                      backgroundColor: value.isValid ? primarycolor2 : Colors.white,
                      foregroundColor: value.isValid ? primarycolor1 : Colors.white,
                      minimumSize: Size(double.infinity, 60),

                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),

                    child: value.isVerifying
                        ? CircularProgressIndicator(strokeWidth: 4, color: Color(0xFFF59B4A))
                        : Text('Verify'),
                  ),
                ),

                SizedBox(height: 10),

                Consumer<AuthProvider>(
                  builder: (context, resend, child) => ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(200, 60),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      backgroundColor: resend.isExpired ? primarycolor2 : Colors.grey,
                      foregroundColor: resend.isExpired ? primarycolor1 : Colors.white,
                    ),

                    onPressed: resend.isExpired && !resend.isResending
                        ? () async {
                            final scaffold = ScaffoldMessenger.of(context);
                            final response = await context.read<AuthProvider>().resendOtp(
                              widget.email,
                            );
                            verifycontroller.clear();
                            if (response == null) return;
                            final result = jsonDecode(response.body);
                            scaffold.showSnackBar(SnackBar(content: Text(result['message'])));
                          }
                        : null,

                    child: resend.isExpired
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            spacing: 5,
                            children: [
                              Icon(Icons.refresh, fontWeight: FontWeight.bold),
                              Text('Resend'),
                            ],
                          )
                        : Text(resend.formattedTime),
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
