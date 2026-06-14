import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:renove_provider/extras/theme.dart';
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ShowprofileProvider>().fetchImage();
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
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            Consumer<ShowprofileProvider>(
              builder: (context, value, child) {
                if (value.isLoading || value.showProfileModel == null) {
                  return Center(child: CircularProgressIndicator());
                }

                final profile = value.showProfileModel;

                if (profile == null) {
                  return const Center(child: CircularProgressIndicator());
                }

                return CircleAvatar(
                  radius: 80,
                  backgroundImage: value.image != null
                      ? FileImage(value.image!)
                      : (value.imagebytes != null ? MemoryImage(value.imagebytes!) : null)
                            as ImageProvider?,
                  child: value.image == null && value.imagebytes == null
                      ? Icon(Icons.person, size: 60)
                      : null,
                );
              },
            ),
            SizedBox(height: 20),
            Center(
              widthFactor: 40,
              child: Consumer<ShowprofileProvider>(
                builder: (context, value, child) {
                  return ElevatedButton(
                    onPressed: () async {
                      final picker = ImagePicker();
                      final picked = await picker.pickImage(source: ImageSource.gallery);
                      if (picked != null) {
                        value.setImage(File(picked.path));
                        await value.updateImage();
                      }
                    },

                    style: ElevatedButton.styleFrom(
                      foregroundColor: primarycolor1,
                      backgroundColor: primarycolor2,
                    ),
                    child: Text('Click to upload new image'),
                  );
                },
              ),
            ),

            SizedBox(height: 20),

            Consumer<ShowprofileProvider>(
              builder: (context, value, child) {
                if (value.isLoading || value.showProfileModel == null) {
                  return Center(child: CircularProgressIndicator());
                }

                final profile = value.showProfileModel;

                if (profile == null) {
                  return const Center(child: CircularProgressIndicator());
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  spacing: 5,
                  children: [
                    Text('الاسم الأول'),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Color(0xFFe4e6f2),
                      ),
                      child: Text(profile.firstName, textDirection: TextDirection.rtl),
                    ),

                    Text('اسم العائلة'),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Color(0xFFe4e6f2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(profile.lastName, textDirection: TextDirection.rtl),
                    ),

                    Text('البريد الالكتروني'),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Color(0xFFe4e6f2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(profile.email, textDirection: TextDirection.rtl),
                    ),

                    Text('رقم الهاتف'),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Color(0xFFe4e6f2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(profile.phone, textDirection: TextDirection.rtl),
                    ),

                    Text('الموقع'),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Color(0xFFe4e6f2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(profile.location, textDirection: TextDirection.rtl),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
