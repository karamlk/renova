import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:renove_provider/extras/link.dart';
import 'package:renove_provider/models/Contractor/Profile/create_profile_model.dart';
import 'package:renove_provider/models/Contractor/Profile/edit_profile_model.dart';
import 'package:renove_provider/models/Contractor/Profile/show_profile_model.dart';
import 'package:renove_provider/providers/Contractor/Profile/create_profile_provider.dart';
import 'package:renove_provider/providers/Contractor/Profile/edit_profile_contractor_provider.dart';
import 'package:renove_provider/providers/Contractor/Profile/show_profile_provider.dart';
import 'package:renove_provider/screens/Auth/login_screen.dart';

class EditContractorProfileScreen extends StatefulWidget {
  final ShowContractorProfileModel profile;
  const EditContractorProfileScreen({super.key, required this.profile});

  @override
  State<EditContractorProfileScreen> createState() => _CreateProfileContractorState();
}

class _CreateProfileContractorState extends State<EditContractorProfileScreen> {
  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController locationController;
  late TextEditingController phoneController;
  late TextEditingController companyController;

  @override
  void initState() {
    super.initState();
    firstNameController = TextEditingController(text: widget.profile.firstName);

    lastNameController = TextEditingController(text: widget.profile.lastName);

    locationController = TextEditingController(text: widget.profile.location);

    phoneController = TextEditingController(text: widget.profile.phone);

    companyController = TextEditingController(text: widget.profile.companyName);
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
              child: Consumer<EditContractorProfileProvider>(
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
                            backgroundImage: value.image != null
                                ? FileImage(value.image!)
                                : CachedNetworkImageProvider("$link${widget.profile.image}")
                                      as ImageProvider,
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
                              controller: phoneController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                labelText: "رقم الهاتف ",

                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                ),
                              ),
                            ),
                            TextField(
                              controller: companyController,

                              decoration: InputDecoration(
                                labelText: "اسم الشركة",

                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () async {
                                final picked = await ImagePicker().pickImage(
                                  source: ImageSource.gallery,
                                );

                                if (picked != null) {
                                  value.setCommercialRecord(File(picked.path));
                                }
                              },
                              child: Container(
                                height: 170,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: value.commercialRecord != null
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: Image.file(
                                          value.commercialRecord!,
                                          fit: BoxFit.cover,
                                        ),
                                      )
                                    : CachedNetworkImage(
                                        imageUrl: "$link${widget.profile.commercialRecord}",
                                        fit: BoxFit.cover,
                                      ),
                              ),
                            ),

                            SizedBox(height: 15),
                            Consumer<EditContractorProfileProvider>(
                              builder: (context, value, child) => ElevatedButton(
                                onPressed: value.isLoading
                                    ? null
                                    : () async {
                                        FocusScope.of(context).unfocus();
                                        final scaffold = ScaffoldMessenger.of(context);
                                        final navigator = Navigator.of(context);
                                        final response = await value.updateProfile(
                                          EditContractorProfileModel(
                                            firstName: firstNameController.text,
                                            lastName: lastNameController.text,
                                            location: locationController.text,
                                            phone: phoneController.text,
                                            companyName: companyController.text,
                                          ),
                                          value.image,
                                          value.commercialRecord,
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
                                          await context
                                              .read<ShowContractorProfileProvider>()
                                              .fetchProfile();

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
