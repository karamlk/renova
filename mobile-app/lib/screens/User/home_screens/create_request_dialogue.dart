import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:renove_provider/extras/theme.dart';
import 'package:renove_provider/models/construction_request_model.dart';
import 'package:renove_provider/providers/User/construction_request_provider.dart';

class CreateRequestDialogue extends StatefulWidget {
  const CreateRequestDialogue({super.key});

  @override
  State<CreateRequestDialogue> createState() => _CreateRequestDialogueState();
}

class _CreateRequestDialogueState extends State<CreateRequestDialogue> {
  final titleController = TextEditingController();
  final descController = TextEditingController();
  final locationController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

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
                    labelStyle: TextStyle(color: primarycolor1),

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
                    labelStyle: TextStyle(color: primarycolor1),
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
                    labelStyle: TextStyle(color: primarycolor1),
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
                      initialValue: provider.selectedType,

                      hint: Text("اختر النوع", style: TextStyle(color: primarycolor1)),

                      isExpanded: true,
                      alignment: AlignmentDirectional.centerStart,
                      decoration: InputDecoration(
                        hintStyle: TextStyle(color: primarycolor1),

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
                            child: Text(
                              entry.value,
                              textDirection: TextDirection.rtl,
                              style: TextStyle(color: primarycolor1),
                            ),
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
                          print("Picked: ${picked.length}");
                          if (picked.isNotEmpty) {
                            value.addImages(picked.map((e) => File(e.path)).toList());
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          backgroundColor: primarycolor2,
                          foregroundColor: Color(0xFFF59B4A),
                          disabledBackgroundColor: Color(0xFF3b414c),
                        ),
                        child: Text('استعرض الصور'),
                      ),
                      Wrap(
                        children: value.images
                            .map(
                              (e) => Padding(
                                padding: EdgeInsets.all(5),
                                child: Image.file(e, width: 60, height: 60),
                              ),
                            )
                            .toList(),
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
                            final model = ConstructionResquestModel(
                              title: titleController.text,
                              description: descController.text,
                              location: locationController.text,
                              type: value.selectedType!,
                            );
                            final response = await context
                                .read<ConstructionRequestProvider>()
                                .createRequest(model);
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
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      backgroundColor: primarycolor2,
                      foregroundColor: Color(0xFFF59B4A),
                      disabledBackgroundColor: Color(0xFF3b414c),
                    ),
                    child: value.isLoading
                        ? CircularProgressIndicator(color: primarycolor1)
                        : Text('إدخال', style: TextStyle(fontWeight: FontWeight.bold)),
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
