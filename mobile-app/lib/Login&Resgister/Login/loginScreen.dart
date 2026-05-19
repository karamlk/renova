import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:renova/Login&Resgister/Register/registerScreen.dart';

class Login extends StatelessWidget {
  Login({super.key});

  final TextEditingController emailnamecontroller = TextEditingController();
  final TextEditingController passwordcontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: const Color(0XFFFEFCFF),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Column(
                  children: [
                    SizedBox(height: 100),
                    Image.asset("assets/images/icon.jpg", height: 150, width: 500),
                    SizedBox(height: 50),
                    TextField(
                      controller: emailnamecontroller,
                      decoration: InputDecoration(
                        labelText: "Enter your Email",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      controller: emailnamecontroller,
                      decoration: InputDecoration(
                        labelText: "Enter your Password",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {},

                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        backgroundColor: Color(0xFF3b414c),
                        foregroundColor: Color(0xFFF59B4A),
                      ),
                      child: Text("Login"),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Text("Forget Password?"),
                      style: TextButton.styleFrom(minimumSize: Size(0, 0)),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Text("OR", style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    Get.to(() => Registerscreen());
                  },
                  child: Text("Make new account"),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    backgroundColor: Color(0xFF3b414c),
                    foregroundColor: Color(0xFFb8bcbf),
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
