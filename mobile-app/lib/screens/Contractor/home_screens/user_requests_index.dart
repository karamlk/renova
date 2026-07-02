import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:renove_provider/extras/theme.dart';
import 'package:renove_provider/providers/Contractor/user_requests_provider.dart';
import 'package:renove_provider/screens/Contractor/home_screens/UserRequestsDetails/user_requests_details.dart';

class UserRequestsIndex extends StatefulWidget {
  const UserRequestsIndex({super.key});

  @override
  State<UserRequestsIndex> createState() => _UserRequestsIndexState();
}

class _UserRequestsIndexState extends State<UserRequestsIndex> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ContractorRequestsProvider>().fetchRequests();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  "طلبات المستخدمين",
                  style: TextStyle(fontWeight: FontWeight.bold, color: primarycolor1),
                ),
              ),
              Divider(color: primarycolor1, height: 5),
            ],
          ),
        ),
      ),
      body: Consumer<ContractorRequestsProvider>(
        builder: (context, value, child) {
          if (value.isLoading) {
            return Center(child: CircularProgressIndicator(color: primarycolor1));
          }
          if (value.requests.isEmpty) {
            return Center(
              child: Text(
                'لا يوجد طلبات من المستخدمين',
                style: TextStyle(color: primarycolor1, fontWeight: FontWeight.bold, fontSize: 16),
              ),
            );
          }
          return RefreshIndicator(
            onRefresh: value.fetchRequests,
            color: primarycolor1,
            child: ListView.builder(
              itemCount: value.requests.length,
              itemBuilder: (context, index) {
                final request = value.requests[index];
                return Padding(
                  padding: EdgeInsets.all(10),
                  child: Card(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        spacing: 10,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                request.title,
                                style: TextStyle(color: primarycolor1, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "العنوان:",
                                textDirection: TextDirection.rtl,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                request.description,
                                style: TextStyle(color: primarycolor1, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "الوصف:",
                                textDirection: TextDirection.rtl,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          SizedBox(height: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                request.location,
                                style: TextStyle(color: primarycolor1, fontWeight: FontWeight.bold),
                              ),
                              Row(
                                spacing: 5,
                                children: [
                                  Text(
                                    "الموقع:",
                                    textDirection: TextDirection.rtl,
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Icon(Icons.location_on, color: primarycolor1),
                                ],
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                request.user.name,
                                style: TextStyle(color: primarycolor1, fontWeight: FontWeight.bold),
                              ),
                              Row(
                                spacing: 5,
                                children: [
                                  Text(
                                    "المستخدم:",
                                    textDirection: TextDirection.rtl,
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Icon(Icons.location_on, color: primarycolor1),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 5),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => UserRequestsDetails(request: request),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size(double.infinity, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              backgroundColor: Colors.white30,
                              foregroundColor: primarycolor1,
                            ),

                            child: Text(
                              "عرض التفاصيل",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
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
