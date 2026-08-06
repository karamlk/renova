import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:renove_provider/Extras/theme.dart';
import 'package:renove_provider/providers/User/construction%20forms/contrsution_forms_provider.dart';
import 'package:renove_provider/providers/theme_provider.dart';

class ReceivedFormsDetails extends StatefulWidget {
  final int receivedId;
  const ReceivedFormsDetails({super.key, required this.receivedId});

  @override
  State<ReceivedFormsDetails> createState() => _ReceivedFormsDetailsState();
}

class _ReceivedFormsDetailsState extends State<ReceivedFormsDetails> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ContrsutionFormsProvider>().fetchRecievedDetails(widget.receivedId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('تفاصيل الاستمارة', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Consumer<ContrsutionFormsProvider>(
        builder: (context, value, child) {
          if (value.isLoading) {
            return Center(child: CircularProgressIndicator(color: primarycolor1));
          }
          if (value.details == null) {
            return Center(
              child: Text(
                'فشل تحميل التفاصيل',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: primarycolor1),
              ),
            );
          }

          return ListView(
            padding: EdgeInsets.all(25),
            children: [
              Text("وصف البناء", style: TextStyle(fontSize: 18), textAlign: TextAlign.right),
              Container(
                width: double.infinity,

                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: context.watch<ThemeProvider>().isDark ? primarycolor2 : Color(0xFFe4e6f2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  value.details!.buildingDescription,
                  textDirection: TextDirection.rtl,

                  style: TextStyle(fontSize: 18),
                ),
              ),
              SizedBox(height: 10),

              Text("المقاول", style: TextStyle(fontSize: 18), textAlign: TextAlign.right),
              Container(
                width: double.infinity,

                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: context.watch<ThemeProvider>().isDark ? primarycolor2 : Color(0xFFe4e6f2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  value.details!.contractor.name,
                  textDirection: TextDirection.rtl,

                  style: TextStyle(fontSize: 18),
                ),
              ),
              SizedBox(height: 10),
              Text("المهندس", style: TextStyle(fontSize: 18), textAlign: TextAlign.right),
              Container(
                width: double.infinity,

                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: context.watch<ThemeProvider>().isDark ? primarycolor2 : Color(0xFFe4e6f2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  value.details!.engineer.name,
                  textDirection: TextDirection.rtl,

                  style: TextStyle(fontSize: 18),
                ),
              ),
              SizedBox(height: 10),
              Text("المواد", style: TextStyle(fontSize: 18), textAlign: TextAlign.right),
              Container(
                width: double.infinity,

                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: context.watch<ThemeProvider>().isDark ? primarycolor2 : Color(0xFFe4e6f2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  spacing: 40,
                  children: [
                    Column(
                      children: [
                        Text(
                          'الوحدة',
                          style: TextStyle(color: primarycolor1, fontWeight: FontWeight.bold),
                        ),
                        ...value.details!.materials.map((material) => Text(material.unit)),
                      ],
                    ),

                    Column(
                      children: [
                        Text(
                          'الكمية',
                          style: TextStyle(color: primarycolor1, fontWeight: FontWeight.bold),
                        ),
                        ...value.details!.materials.map(
                          (material) => Text(material.quantity.toString()),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          'النوع',
                          style: TextStyle(color: primarycolor1, fontWeight: FontWeight.bold),
                        ),
                        ...value.details!.materials.map((material) => Text(material.materialType)),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'الاسم',
                          style: TextStyle(color: primarycolor1, fontWeight: FontWeight.bold),
                        ),
                        ...value.details!.materials.map((material) => Text(material.materialName)),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Text("سعر الوحدة", style: TextStyle(fontSize: 18), textAlign: TextAlign.right),
              Container(
                width: double.infinity,

                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: context.watch<ThemeProvider>().isDark ? primarycolor2 : Color(0xFFe4e6f2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  spacing: 40,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Column(
                      children: [
                        Text(
                          'السعر الكلي',
                          style: TextStyle(color: primarycolor1, fontWeight: FontWeight.bold),
                        ),
                        ...value.details!.materials.map(
                          (material) => Text(material.totalPrice.toString()),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          'سعر الوحدة',
                          style: TextStyle(color: primarycolor1, fontWeight: FontWeight.bold),
                        ),
                        ...value.details!.materials.map(
                          (material) => Text(material.unitPrice.toString()),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'اسم المادة ',
                          style: TextStyle(color: primarycolor1, fontWeight: FontWeight.bold),
                        ),
                        ...value.details!.materials.map((material) => Text(material.materialName)),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Text("السعر الإجمالي", style: TextStyle(fontSize: 18), textAlign: TextAlign.right),
              Container(
                width: double.infinity,

                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: context.watch<ThemeProvider>().isDark ? primarycolor2 : Color(0xFFe4e6f2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  value.details!.totalCost,
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.center,

                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 10),
              Text("عنوان الطلب", style: TextStyle(fontSize: 18), textAlign: TextAlign.right),
              Container(
                width: double.infinity,

                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: context.watch<ThemeProvider>().isDark ? primarycolor2 : Color(0xFFe4e6f2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  value.details!.reconstructionRequest.title,
                  textDirection: TextDirection.rtl,

                  style: TextStyle(fontSize: 18),
                ),
              ),
              SizedBox(height: 10),
              Text("وصف الطلب", style: TextStyle(fontSize: 18), textAlign: TextAlign.right),
              Container(
                width: double.infinity,

                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: context.watch<ThemeProvider>().isDark ? primarycolor2 : Color(0xFFe4e6f2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  value.details!.reconstructionRequest.description,
                  textDirection: TextDirection.rtl,

                  style: TextStyle(fontSize: 18),
                ),
              ),
              SizedBox(height: 10),
              Text("الموقع", style: TextStyle(fontSize: 18), textAlign: TextAlign.right),
              Container(
                width: double.infinity,

                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: context.watch<ThemeProvider>().isDark ? primarycolor2 : Color(0xFFe4e6f2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  value.details!.reconstructionRequest.location,
                  textDirection: TextDirection.rtl,

                  style: TextStyle(fontSize: 18),
                ),
              ),
              SizedBox(height: 10),
              Text("النوع", style: TextStyle(fontSize: 18), textAlign: TextAlign.right),
              Container(
                width: double.infinity,

                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: context.watch<ThemeProvider>().isDark ? primarycolor2 : Color(0xFFe4e6f2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  value.details!.reconstructionRequest.type,
                  textDirection: TextDirection.rtl,

                  style: TextStyle(fontSize: 18),
                ),
              ),
              SizedBox(height: 40),
            ],
          );
        },
      ),
    );
  }
}
