import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:renove_provider/extras/theme.dart';
import 'package:renove_provider/providers/User/construction_index_provider.dart';
import 'package:renove_provider/providers/theme_provider.dart';

class RequestsIndexList extends StatefulWidget {
  const RequestsIndexList({super.key});

  @override
  State<RequestsIndexList> createState() => _RequestsIndexListState();
}

class _RequestsIndexListState extends State<RequestsIndexList> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ConstructionIndexProvider>().fetchRequestIndex();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Align(
          alignment: Alignment.centerRight,
          child: Text(
            "طلبات الإعمار",
            style: TextStyle(fontWeight: FontWeight.bold, color: primarycolor1),
          ),
        ),
      ),
      body: Consumer<ConstructionIndexProvider>(
        builder: (context, value, child) {
          if (value.requestsIndex.isEmpty) {
            return Padding(
              padding: const EdgeInsets.all(20),
              child: Center(
                child: Text(
                  'لا يوجد أي طلبات',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: primarycolor1),
                ),
              ),
            );
          }
          if (value.isLoading) {
            return Center(child: CircularProgressIndicator(color: primarycolor1));
          }
          return Padding(
            padding: const EdgeInsets.all(15),
            child: ListView.builder(
              itemCount: value.requestsIndex.length,
              itemBuilder: (context, index) {
                final req = value.requestsIndex[index];
                return Padding(
                  padding: const EdgeInsets.all(5),
                  child: Card(
                    color: context.watch<ThemeProvider>().isDark
                        ? primarycolor2
                        : Colors.grey.shade300,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),

                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            onPressed: () {},
                            style: ButtonStyle(
                              backgroundColor: null,
                              iconColor: WidgetStatePropertyAll(Colors.grey),
                            ),
                            icon: Icon(Icons.arrow_circle_left, size: 60),
                          ),
                          Column(
                            spacing: 5,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'عنوان الطلب: ${req.title}',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              ),

                              Row(
                                spacing: 5,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [Text(req.location), Icon(Icons.location_on_outlined)],
                              ),

                              Row(
                                spacing: 14,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text("الحالة: ${req.status}", textDirection: TextDirection.rtl),
                                  Icon(Icons.arrow_upward),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
