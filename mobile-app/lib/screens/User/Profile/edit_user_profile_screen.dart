import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:renove_provider/extras/link.dart';
import 'package:renove_provider/models/User/Profile/edit_profile_model.dart';
import 'package:renove_provider/models/User/Profile/profile_model.dart';
import 'package:renove_provider/models/User/Profile/show_profile_model.dart';
import 'package:renove_provider/providers/User/Profile/create_profile_provider.dart';
import 'package:renove_provider/providers/User/Profile/edit_profile_provider.dart';
import 'package:renove_provider/providers/User/Profile/show_profile_provider.dart';
import 'package:renove_provider/screens/User/home_screens/home_main_user.dart';

class EditUserProfileScreen extends StatefulWidget {
  final ShowProfileModel profile;
  const EditUserProfileScreen({super.key, required this.profile});

  @override
  State<EditUserProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<EditUserProfileScreen> {
  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController locationController;
  late TextEditingController phoneController;
  @override
  void initState() {
    super.initState();

    firstNameController = TextEditingController(text: widget.profile.firstName);

    lastNameController = TextEditingController(text: widget.profile.lastName);

    phoneController = TextEditingController(text: widget.profile.phone);

    locationController = TextEditingController(text: widget.profile.location);
  }

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
              child: Consumer<EditProfileProvider>(
                builder: (context, provider, child) => Column(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        final picker = ImagePicker();
                        final picked = await picker.pickImage(source: ImageSource.gallery);
                        if (picked != null) {
                          provider.setImage(File(picked.path));
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Center(
                          child: CircleAvatar(
                            radius: 100,
                            backgroundImage: provider.image != null
                                ? FileImage(provider.image!)
                                : CachedNetworkImageProvider('$link${widget.profile.image}')
                                      as ImageProvider,
                            child: provider.image == null
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
                              controller: phoneController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                labelText: "رقم الهاتف ",

                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                ),
                              ),
                            ),
                            SizedBox(height: 15),
                            Consumer<EditProfileProvider>(
                              builder: (context, value, child) => ElevatedButton(
                                onPressed: value.isLoading
                                    ? null
                                    : () async {
                                        FocusScope.of(context).unfocus();
                                        final scaffold = ScaffoldMessenger.of(context);
                                        final navigator = Navigator.of(context);
                                        final response = await provider.updateProfile(
                                          EditProfileModel(
                                            firstName: firstNameController.text,
                                            lastName: lastNameController.text,
                                            location: locationController.text,
                                            phone: phoneController.text,
                                          ),
                                          provider.image,
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
                                          await context.read<ShowprofileProvider>().fetchProfile();
                                          navigator.pop();
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
