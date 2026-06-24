import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:renove_provider/extras/link.dart';
import 'package:renove_provider/extras/theme.dart';

import 'package:renove_provider/providers/User/construction_request_provider.dart';
import 'package:renove_provider/providers/User/request_details_provider.dart';

class EditRequestDialogue extends StatefulWidget {
  const EditRequestDialogue({
    super.key,
    required this.id,
    required this.titlePrefill,
    required this.locationPrefill,
    required this.typePrefill,
    required this.descPrefill,
    required this.statusPrefilll,
    required this.imagesPrefill,
  });
  final int id;
  final String titlePrefill;
  final String locationPrefill;
  final String typePrefill;
  final String statusPrefilll;
  final String descPrefill;
  final List<dynamic> imagesPrefill;

  @override
  State<EditRequestDialogue> createState() => _EditRequestDialogueState();
}

class _EditRequestDialogueState extends State<EditRequestDialogue> {
  late final titleController;
  late final descController;
  late final locationController;
  String? selectedType;
  late List<dynamic> remainingNetworkImages;
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.titlePrefill);
    descController = TextEditingController(text: widget.descPrefill);
    locationController = TextEditingController(text: widget.locationPrefill);
    selectedType = widget.typePrefill;
    remainingNetworkImages = List.from(widget.imagesPrefill);
  }

  @override
  void dispose() {
    // Clean up memory links
    titleController.dispose();
    locationController.dispose();
    descController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('طلب جديد', textDirection: TextDirection.rtl),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            spacing: 20,
            children: [
              Directionality(
                textDirection: TextDirection.rtl,
                child: TextFormField(
                  validator: (value) => value == null || value.isEmpty ? 'يجب إدخال العنوان' : null,
                  controller: titleController,

                  textDirection: TextDirection.rtl,
                  decoration: InputDecoration(
                    labelText: "العنوان",

                    border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                  ),
                ),
              ),
              Directionality(
                textDirection: TextDirection.rtl,
                child: TextFormField(
                  validator: (value) => value == null || value.isEmpty ? 'يجب إدخال الوصف' : null,
                  controller: descController,
                  decoration: InputDecoration(
                    labelText: "الوصف",

                    border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                  ),
                ),
              ),
              Directionality(
                textDirection: TextDirection.rtl,
                child: TextFormField(
                  validator: (value) => value == null || value.isEmpty ? 'يجب إدخال الموقع' : null,
                  controller: locationController,
                  decoration: InputDecoration(
                    labelText: "الموقع",

                    border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                  ),
                ),
              ),
              Consumer<ConstructionRequestProvider>(
                builder: (context, provider, child) {
                  return Directionality(
                    textDirection: TextDirection.rtl,
                    child: DropdownButtonFormField<String>(
                      initialValue: selectedType,
                      hint: Text("اختر النوع"),
                      isExpanded: true,
                      alignment: AlignmentDirectional.centerStart,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                      ),
                      borderRadius: BorderRadius.circular(10),
                      elevation: 0,
                      items: provider.types.entries.map((entry) {
                        return DropdownMenuItem<String>(
                          value: entry.key,
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Text(entry.value, textDirection: TextDirection.rtl),
                          ),
                        );
                      }).toList(),
                      onChanged: (newvalue) {
                        provider.setType(newvalue!);
                      },
                      validator: (value) =>
                          value == null || value.isEmpty ? 'يجب إدخال النوع' : null,
                    ),
                  );
                },
              ),
              Consumer<ConstructionRequestProvider>(
                builder: (context, value, child) {
                  return Column(
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          final picker = ImagePicker();
                          final picked = await picker.pickMultiImage();

                          if (picked.isNotEmpty) {
                            value.addImages(picked.map((e) => File(e.path)).toList());
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          backgroundColor: Color(0xFF3b414c),
                          foregroundColor: Color(0xFFF59B4A),
                          disabledBackgroundColor: Color(0xFF3b414c),
                        ),
                        child: Text('استعرض الصور'),
                      ),
                      SizedBox(height: 10),
                      Directionality(
                        textDirection: TextDirection.rtl,
                        child: Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: [
                            ...remainingNetworkImages.map((img) {
                              return ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: CachedNetworkImage(
                                  imageUrl: "$link${img['image_url']}",
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => SizedBox(
                                    width: 60,
                                    height: 60,
                                    child: CircularProgressIndicator(color: primarycolor1),
                                  ),
                                  errorWidget: (context, url, error) => Icon(Icons.error),
                                ),
                              );
                            }),
                            ...value.images.map((file) {
                              return ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.file(file, width: 60, height: 60, fit: BoxFit.cover),
                              );
                            }),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
              Consumer<ConstructionRequestProvider>(
                builder: (context, value, child) {
                  return ElevatedButton(
                    onPressed: value.isLoading
                        ? null
                        : () async {
                            if (_formKey.currentState!.validate()) {
                              print('All fields passed! Processing upload request...');
                            } else {
                              print('ERROR: Missing fields detected.');
                            }
                            final navigate = Navigator.of(context);
                            final scaffold = ScaffoldMessenger.of(context);

                            final response = await context
                                .read<ConstructionRequestProvider>()
                                .updateRequest(
                                  widget.id,
                                  titleController.text,
                                  descController.text,
                                  locationController.text,
                                  selectedType ?? widget.typePrefill,
                                  remainingNetworkImages,
                                );
                            if (response == null) return;
                            final data = jsonDecode(response.body);

                            if (response.statusCode == 200 || response.statusCode == 201) {
                              navigate.pop();
                              value.clearImages();
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
                              context.read<RequestDetailsProvider>().silentFetchDetails(widget.id);
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      backgroundColor: Color(0xFF3b414c),
                      foregroundColor: Color(0xFFF59B4A),
                      disabledBackgroundColor: Color(0xFF3b414c),
                    ),
                    child: value.isUpdating
                        ? CircularProgressIndicator(color: primarycolor1)
                        : Text('إدخال'),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
