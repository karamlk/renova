import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:renove_provider/extras/theme.dart';
import 'package:renove_provider/models/Contractor/construction%20forms/create_construction_form.dart';
import 'package:renove_provider/providers/Contractor/construction%20forms/construction_form_provider.dart';

class AddMaterialBottomSheet extends StatefulWidget {
  const AddMaterialBottomSheet({super.key});

  @override
  State<AddMaterialBottomSheet> createState() => _AddMaterialBottomSheetState();
}

class _AddMaterialBottomSheetState extends State<AddMaterialBottomSheet> {
  final nameController = TextEditingController();
  final typeController = TextEditingController();
  final quantityController = TextEditingController();
  final unitController = TextEditingController();
  final priceController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  @override
  void dispose() {
    nameController.dispose();
    typeController.dispose();
    quantityController.dispose();
    unitController.dispose();
    priceController.dispose();
    super.dispose();
  }

  InputDecoration decoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: primarycolor1),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 80,
      ),
      child: SingleChildScrollView(
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "إضافة مادة",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: nameController,
                  decoration: decoration("اسم المادة"),
                  validator: (v) => v == null || v.isEmpty ? "مطلوب" : null,
                ),
                const SizedBox(height: 15),

                TextFormField(
                  controller: typeController,
                  decoration: decoration("نوع المادة"),
                  validator: (v) => v == null || v.isEmpty ? "مطلوب" : null,
                ),

                const SizedBox(height: 15),

                TextFormField(
                  controller: quantityController,
                  keyboardType: TextInputType.number,
                  decoration: decoration("الكمية"),
                  validator: (v) => v == null || v.isEmpty ? "مطلوب" : null,
                ),

                const SizedBox(height: 15),

                TextFormField(
                  controller: unitController,
                  decoration: decoration("الوحدة"),
                  validator: (v) => v == null || v.isEmpty ? "مطلوب" : null,
                ),

                const SizedBox(height: 15),
                TextFormField(
                  controller: priceController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: decoration("سعر الوحدة"),
                  validator: (v) => v == null || v.isEmpty ? "مطلوب" : null,
                ),

                const SizedBox(height: 30),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 60),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    backgroundColor: Color(0xFF3b414c),
                    foregroundColor: Color(0xFFF59B4A),
                    disabledBackgroundColor: Color(0xFF3b414c),
                  ),
                  onPressed: () {
                    if (!formKey.currentState!.validate()) return;
                    context.read<InspectionFormProvider>().addMaterial(
                      MaterialModel(
                        materialName: nameController.text.trim(),
                        materialType: typeController.text.trim(),
                        quantity: int.parse(quantityController.text),
                        unit: unitController.text.trim(),
                        unitPrice: double.parse(priceController.text),
                      ),
                    );
                    Navigator.pop(context);
                  },
                  child: Text('إضافة', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
