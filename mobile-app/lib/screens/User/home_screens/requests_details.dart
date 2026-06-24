import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:renove_provider/extras/link.dart';
import 'package:renove_provider/extras/theme.dart';
import 'package:renove_provider/providers/User/construction_index_provider.dart';
import 'package:renove_provider/providers/User/construction_request_provider.dart';
import 'package:renove_provider/providers/User/request_details_provider.dart';
import 'package:renove_provider/providers/theme_provider.dart';
import 'package:renove_provider/screens/User/home_screens/edit_request_dialogue.dart';
import 'package:renove_provider/screens/User/home_screens/photo_view.dart';

class RequestsDetails extends StatefulWidget {
  const RequestsDetails({super.key, required this.id});
  final int id;
  @override
  State<RequestsDetails> createState() => _RequestsDetailsState();
}

class _RequestsDetailsState extends State<RequestsDetails> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<RequestDetailsProvider>().fetchDetails(widget.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('تفاصيل طلب الإعمار', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          PopupMenuButton(
            onSelected: (value) {
              if (value == 'تعديل') {
                final currentData = context.read<RequestDetailsProvider>().details;
                if (currentData != null) {
                  showDialog(
                    context: context,
                    animationStyle: AnimationStyle(
                      curve: Curves.easeInOutCubic,
                      duration: Duration(milliseconds: 200),
                    ),
                    fullscreenDialog: true,
                    builder: (_) => EditRequestDialogue(
                      id: currentData['id'],
                      titlePrefill: currentData['title'],
                      locationPrefill: currentData['location'],
                      typePrefill: currentData['type'],
                      descPrefill: currentData['description'],
                      statusPrefilll: currentData['status'],
                      imagesPrefill: currentData['images'] ?? [],
                    ),
                  );
                }
              } else if (value == 'حذف') {
                showDialog(
                  context: (context),
                  animationStyle: AnimationStyle(
                    curve: Curves.easeInOutCubic,
                    duration: Duration(milliseconds: 200),
                  ),
                  fullscreenDialog: true,
                  builder: (context) => AlertDialog(
                    title: Text(
                      'هل أنت متأكد من حذف الطلب؟',
                      textAlign: TextAlign.right,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    actions: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            style: ElevatedButton.styleFrom(minimumSize: Size(80, 50)),
                            child: Text(
                              'إلغاء',
                              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                          ),
                          Consumer<ConstructionRequestProvider>(
                            builder: (context, value, child) => ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.redAccent,
                                minimumSize: Size(120, 50),
                              ),
                              onPressed: () async {
                                final navigate = Navigator.of(context);
                                final scaffold = ScaffoldMessenger.of(context);
                                final response = await value.deleteRequest(widget.id);
                                if (!mounted) return;
                                if (response == null) return;
                                final data = jsonDecode(response.body);
                                if (response.statusCode == 200 || response.statusCode == 201) {
                                  navigate.pop();

                                  navigate.pop();
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
                                  context.read<ConstructionIndexProvider>().fetchRequestIndex();
                                }
                              },
                              child: value.isDeleteing
                                  ? CircularProgressIndicator(color: Colors.white)
                                  : Text(
                                      'حذف',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }
            },
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                  value: 'تعديل',
                  child: Row(
                    textDirection: TextDirection.rtl,
                    mainAxisAlignment: MainAxisAlignment.start,
                    spacing: 8,
                    children: [Icon(Icons.edit), Text('تعديل')],
                  ),
                ),
                PopupMenuItem(
                  value: "حذف",
                  child: Row(
                    textDirection: TextDirection.rtl,
                    mainAxisAlignment: MainAxisAlignment.start,
                    spacing: 8,
                    children: [Icon(Icons.delete), Text('حذف')],
                  ),
                ),
              ];
            },
          ),
        ],
      ),
      body: Consumer<RequestDetailsProvider>(
        builder: (context, value, child) {
          if (value.isLoading) {
            return Center(child: CircularProgressIndicator(color: primarycolor1));
          }
          final data = value.details;
          if (data == null) {
            return Text('فشل تحميل التفاصيل');
          }
          return RefreshIndicator(
            color: primarycolor1,
            onRefresh: () async {
              context.read<RequestDetailsProvider>().fetchDetails(widget.id);
            },
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: ListView(
                padding: EdgeInsets.all(25),
                children: [
                  Text("العنوان", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: context.watch<ThemeProvider>().isDark
                          ? primarycolor2
                          : Color(0xFFe4e6f2),
                      borderRadius: BorderRadius.circular(10),
                    ),

                    child: Text(
                      data['title'],
                      textDirection: TextDirection.rtl,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ),
                  SizedBox(height: 10),

                  Text("الموقع", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: context.watch<ThemeProvider>().isDark
                          ? primarycolor2
                          : Color(0xFFe4e6f2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      data['location'],
                      textDirection: TextDirection.rtl,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text("النوع", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: context.watch<ThemeProvider>().isDark
                          ? primarycolor2
                          : Color(0xFFe4e6f2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      data['type'],
                      textDirection: TextDirection.rtl,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text("الحالة", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: context.watch<ThemeProvider>().isDark
                          ? primarycolor2
                          : Color(0xFFe4e6f2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      data['status'],
                      textDirection: TextDirection.rtl,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text("الوصف", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                  Container(
                    height: 100,
                    width: double.infinity,
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: context.watch<ThemeProvider>().isDark
                          ? primarycolor2
                          : Color(0xFFe4e6f2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      data['description'],
                      textDirection: TextDirection.rtl,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text("الصور", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    primary: false,
                    itemCount: data['images'].length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      childAspectRatio: 1,
                    ),
                    itemBuilder: (context, index) {
                      final img = data['images'][index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => PhotoView(imageUrl: "$link${img['image_url']}"),
                            ),
                          );
                        },
                        child: CachedNetworkImage(
                          imageUrl: "$link${img['image_url']}",
                          fit: BoxFit.cover,
                          placeholder: (context, url) =>
                              Center(child: CircularProgressIndicator(color: primarycolor1)),
                          errorWidget: (context, url, error) => Icon(Icons.error),
                          fadeInDuration: Duration(milliseconds: 300),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
