import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:renove_provider/providers/profile_provider.dart';
import 'package:renove_provider/providers/show_profile_provider.dart';

class ShowprofileScreen extends StatefulWidget {
  const ShowprofileScreen({super.key});

  @override
  State<ShowprofileScreen> createState() => _ShowprofileScreenState();
}

class _ShowprofileScreenState extends State<ShowprofileScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<ShowprofileProvider>().fetchProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ملفك الشخصي', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Padding(
        padding: const EdgeInsetsGeometry.all(20),
        child: Consumer<ShowprofileProvider>(
          builder: (context, value, child) {
            if (value.isLoading || value.showProfileModel == null) {
              return Center(child: CircularProgressIndicator());
            }
            final profile = value.showProfileModel;
            return SingleChildScrollView(
              child: Column(
                spacing: 10,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Center(
                    child: GestureDetector(
                      child: CircleAvatar(
                        radius: 60,
                        backgroundImage: value.image != null
                            ? FileImage(value.image!)
                            : NetworkImage(profile!.fullImageUrl) as ImageProvider,
                      ),
                      onTap: () async {
                        final picker = ImagePicker();
                        final picked = await picker.pickImage(source: ImageSource.gallery);
                        if (picked != null) {
                          value.setImage(File(picked.path));
                        }
                      },
                    ),
                  ),
                  SizedBox(height: 20),
                  Text('الاسم الأول'),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(profile!.firstName),
                  ),
                  Text('اسم العائلة'),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(profile.lastName),
                  ),
                  Text('البريد الالكتروني'),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(profile.email),
                  ),
                  Text('رقم الهاتف'),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(profile.phone),
                  ),
                  Text('الموقع'),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(profile.location),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
