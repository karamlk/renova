import 'package:flutter/material.dart';

class ResetPassword extends StatefulWidget {
  ResetPassword({super.key, required this.emailReset});
  final TextEditingController emailcontroller = TextEditingController();
  final String emailReset;

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  late TextEditingController emailcontroller;
  final TextEditingController passwordcontroller = TextEditingController();
  final TextEditingController repeatedpasswordcontroller = TextEditingController();
  @override
  void initState() {
    super.initState();

    emailcontroller = TextEditingController(text: widget.emailReset);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('إعادة تعيين كلمة المرور', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Padding(
          padding: EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              spacing: 15,
              children: [
                Text(
                  'أدخل كلمة مرور جديدة ثم أعد تسجيل الدخول مرة أخرى',
                  style: TextStyle(fontSize: 20),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 80),
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: TextField(
                    controller: emailcontroller,
                    decoration: InputDecoration(
                      enabled: false,
                      labelText: "البريد الإلكتروني",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                    ),
                  ),
                ),
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: "كلمة المرور الجديدة",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                    ),
                  ),
                ),
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: "كلمة المرور مرة أخرى",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {},

                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 60),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    backgroundColor: Color(0xFF3b414c),
                    foregroundColor: Color(0xFFF59B4A),
                    disabledBackgroundColor: Color(0xFF3b414c),
                  ),
                  child: Text('موافق'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
