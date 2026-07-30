import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:renove_provider/extras/link.dart';
import 'package:renove_provider/extras/theme.dart';
import 'package:renove_provider/providers/Contractor/Profile/show_profile_provider.dart';
import 'package:renove_provider/providers/theme_provider.dart';
import 'package:renove_provider/screens/Contractor/home_screens/Profile/edit_profile_contractor.dart';
import 'package:renove_provider/skeletons/profile_page_skeleton.dart';

class ShowProfileContractorScreen extends StatefulWidget {
  const ShowProfileContractorScreen({super.key});

  @override
  State<ShowProfileContractorScreen> createState() => _ShowprofileScreenState();
}

class _ShowprofileScreenState extends State<ShowProfileContractorScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ShowContractorProfileProvider>().fetchProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,

          children: [
            Text('ملفك الشخصي', style: TextStyle(fontWeight: FontWeight.bold)),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: primarycolor1,
                backgroundColor: primarycolor2,
              ),
              onPressed: () {
                final profile = context.read<ShowContractorProfileProvider>().showProfileModel;

                if (profile == null) return;

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => EditContractorProfileScreen(profile: profile)),
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                spacing: 5,
                children: [Text("تعديل"), Icon(Icons.edit)],
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            Consumer<ShowContractorProfileProvider>(
              builder: (context, value, child) {
                return Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(80),
                    child: CachedNetworkImage(
                      imageUrl: '$link${value.showProfileModel?.image ?? ""}',
                      width: 160,
                      height: 160,
                      fit: BoxFit.cover,
                      httpHeaders: {'Authorization': 'Bearer ${value.token}', 'Accept': 'image/*'},
                      placeholder: (context, url) =>
                          CircularProgressIndicator(color: primarycolor1),
                      errorWidget: (context, url, error) => Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(80),
                          color: primarycolor2,
                        ),

                        child: Icon(Icons.person, size: 80, color: primarycolor1),
                      ),
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: 20),
            Center(
              widthFactor: 40,
              child: Consumer<ShowContractorProfileProvider>(
                builder: (context, value, child) {
                  return ElevatedButton(
                    onPressed: () async {
                      final picker = ImagePicker();
                      final picked = await picker.pickImage(
                        source: ImageSource.gallery,
                        imageQuality: 50,
                        maxWidth: 400,
                        maxHeight: 400,
                      );
                      if (picked != null) {
                        value.setImage(File(picked.path));
                        await value.updateImage();
                        await value.fetchProfile();
                      }
                    },

                    style: ElevatedButton.styleFrom(
                      foregroundColor: primarycolor1,
                      backgroundColor: primarycolor2,
                    ),
                    child: Text(
                      'اضغط لتحميل صورة جديدة',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  );
                },
              ),
            ),

            SizedBox(height: 20),

            Consumer<ShowContractorProfileProvider>(
              builder: (context, value, child) {
                if (value.isLoading || value.showProfileModel == null) {
                  return ProfilePageSkeleton();
                }

                final profile = value.showProfileModel;

                if (profile == null) {
                  return const Center(
                    child: Column(
                      children: [
                        Icon(Icons.offline_bolt, size: 40),
                        Text('فضل تحميل الملف الشخصي'),
                      ],
                    ),
                  );
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
                        color: context.watch<ThemeProvider>().isDark
                            ? primarycolor2
                            : Color(0xFFe4e6f2),
                      ),
                      child: Text(profile.firstName, textDirection: TextDirection.rtl),
                    ),

                    Text('اسم العائلة'),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: context.watch<ThemeProvider>().isDark
                            ? primarycolor2
                            : Color(0xFFe4e6f2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(profile.lastName, textDirection: TextDirection.rtl),
                    ),

                    Text('البريد الالكتروني'),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: context.watch<ThemeProvider>().isDark
                            ? primarycolor2
                            : Color(0xFFe4e6f2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(profile.email, textDirection: TextDirection.rtl),
                    ),

                    Text('رقم الهاتف'),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: context.watch<ThemeProvider>().isDark
                            ? primarycolor2
                            : Color(0xFFe4e6f2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(profile.phone, textDirection: TextDirection.rtl),
                    ),

                    Text('الموقع'),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: context.watch<ThemeProvider>().isDark
                            ? primarycolor2
                            : Color(0xFFe4e6f2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(profile.location, textDirection: TextDirection.rtl),
                    ),
                    Text('اسم الشركة'),

                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: context.watch<ThemeProvider>().isDark
                            ? primarycolor2
                            : const Color(0xFFe4e6f2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(profile.companyName, textDirection: TextDirection.rtl),
                    ),
                    Text('السجل التجاري'),

                    ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: CachedNetworkImage(
                        imageUrl: '$link${profile.commercialRecord}',
                        httpHeaders: {
                          'Authorization': 'Bearer ${value.token}',
                          'Accept': 'image/*',
                        },
                        height: 220,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        placeholder: (context, url) =>
                            const Center(child: CircularProgressIndicator()),
                        errorWidget: (context, url, error) => Container(
                          height: 220,
                          color: Colors.grey.shade300,
                          child: const Icon(Icons.description, size: 70),
                        ),
                      ),
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
