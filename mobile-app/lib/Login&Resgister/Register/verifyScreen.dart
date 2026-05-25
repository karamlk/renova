import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:renova/Extras/theme.dart';
import 'package:renova/Login&Resgister/Register/verifyController.dart';

class Verifyscreen extends StatelessWidget {
  Verifyscreen({super.key});
  final verifycontroller = Get.put(Verifycontroller());

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
                Obx(
                  () => TextField(
                    onChanged: (value) {
                      verifycontroller.otp.value = value;
                    },
                    keyboardType: TextInputType.number,
                    maxLength: 6,

                    controller: verifycontroller.otpcontroller,
                    enabled: !verifycontroller.isexpired.value,

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
                Obx(() {
                  bool isValid =
                      verifycontroller.otp.value.length == 6 && !verifycontroller.isexpired.value;
                  return ElevatedButton(
                    onPressed: isValid
                        ? () async {
                            final response = await verifycontroller.verify();
                            if (response == null) {
                              print('No response');
                            }
                            final error = jsonDecode(response!.body);
                            if (response.statusCode != 200 || response.statusCode != 201) {
                              String message = error['message'];
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    message,
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
                      backgroundColor: isValid ? primarycolor2 : Colors.grey,
                      foregroundColor: isValid ? primarycolor1 : Colors.grey,
                      minimumSize: Size(double.infinity, 60),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),

                    child: verifycontroller.isLoading.value
                        ? CircularProgressIndicator(strokeWidth: 4, color: Color(0xFFF59B4A))
                        : Text('Verify'),
                  );
                }),
                SizedBox(height: 10),
                Obx(
                  () => ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(200, 60),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      backgroundColor: verifycontroller.isexpired.value
                          ? primarycolor2
                          : Colors.grey,
                      foregroundColor: verifycontroller.isexpired.value
                          ? primarycolor1
                          : Colors.grey,
                    ),

                    onPressed: verifycontroller.isexpired.value
                        ? () {
                            verifycontroller.resendOtp();
                          }
                        : null,

                    child: verifycontroller.isexpired.value
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            spacing: 5,
                            children: [
                              Icon(Icons.refresh, fontWeight: FontWeight.bold),
                              Text('Resend'),
                            ],
                          )
                        : Text(verifycontroller.formattedTime),
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
