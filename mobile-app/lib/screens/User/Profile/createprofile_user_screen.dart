import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:renove_provider/models/profile_model.dart';
import 'package:renove_provider/providers/User/create_profile_provider.dart';
import 'package:renove_provider/screens/User/home_screens/home_main_user.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController firstNameController = TextEditingController();

  final TextEditingController lastNameController = TextEditingController();

  final TextEditingController locationController = TextEditingController();

  final TextEditingController phonecontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('أكمل إنشاء ملفك الشخصي', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Consumer<CreateProfileProvider>(
                builder: (context, value, child) => Column(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        final picker = ImagePicker();
                        final picked = await picker.pickImage(source: ImageSource.gallery);
                        if (picked != null) {
                          value.setImage(File(picked.path));
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Center(
                          child: CircleAvatar(
                            radius: 100,
                            backgroundImage: value.image != null ? FileImage(value.image!) : null,
                            child: value.image == null
                                ? Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.camera_alt, size: 80),
                                      Text(
                                        'اضغط لاستعراض صورة',
                                        style: TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  )
                                : null,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: Column(
                          spacing: 20,
                          children: [
                            TextField(
                              controller: firstNameController,
                              decoration: InputDecoration(
                                labelText: "الاسم الأول",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                ),
                              ),
                            ),
                            TextField(
                              controller: lastNameController,
                              decoration: InputDecoration(
                                labelText: "اسم العائلة",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                ),
                              ),
                            ),
                            TextField(
                              controller: locationController,
                              decoration: InputDecoration(
                                labelText: "مكان السكن",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                ),
                              ),
                            ),
                            TextField(
                              controller: phonecontroller,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                labelText: "رقم الهاتف ",

                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                ),
                              ),
                            ),
                            SizedBox(height: 15),
                            Consumer<CreateProfileProvider>(
                              builder: (context, value, child) => ElevatedButton(
                                onPressed: value.isLoading
                                    ? null
                                    : () async {
                                        FocusScope.of(context).unfocus();
                                        final scaffold = ScaffoldMessenger.of(context);
                                        final navigator = Navigator.of(context);
                                        final response = await context
                                            .read<CreateProfileProvider>()
                                            .fillProfile(
                                              ProfileModel(
                                                firstName: firstNameController.text,
                                                lastName: lastNameController.text,
                                                location: locationController.text,
                                                phone: phonecontroller.text,
                                              ),
                                              value.image,
                                            );
                                        if (response == null) return;
                                        final result = jsonDecode(response.body);
                                        scaffold.showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              result['message'],
                                              textAlign: TextAlign.right,
                                              textDirection: TextDirection.rtl,
                                            ),
                                            behavior: SnackBarBehavior.floating,
                                          ),
                                        );
                                        if (response.statusCode == 200 ||
                                            response.statusCode == 201) {
                                          navigator.push(
                                            MaterialPageRoute(builder: (context) => HomeMainUser()),
                                          );
                                        }
                                      },

                                style: ElevatedButton.styleFrom(
                                  minimumSize: Size(double.infinity, 60),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  backgroundColor: Color(0xFF3b414c),
                                  foregroundColor: Color(0xFFF59B4A),
                                  disabledBackgroundColor: Color(0xFF3b414c),
                                ),
                                child: value.isLoading
                                    ? CircularProgressIndicator(
                                        strokeWidth: 4,
                                        color: Color(0xFFF59B4A),
                                      )
                                    : Text("حفظ", style: TextStyle(fontWeight: FontWeight.bold)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
