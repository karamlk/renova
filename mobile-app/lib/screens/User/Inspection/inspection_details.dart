import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:renove_provider/extras/theme.dart';
import 'package:renove_provider/providers/theme_provider.dart';

class InspectionDetails extends StatefulWidget {
  const InspectionDetails({super.key});

  @override
  State<InspectionDetails> createState() => _InspectionDetailsState();
}

class _InspectionDetailsState extends State<InspectionDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("تفاصيل العرض", style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      // body: RefreshIndicator(
      //   onRefresh: () {},
      //   child: Directionality(
      //     textDirection: TextDirection.rtl,
      //     child: ListView(children: [

      //      Container(
      //               width: double.infinity,
      //               padding: EdgeInsets.all(15),
      //               decoration: BoxDecoration(
      //                 color: context.watch<ThemeProvider>().isDark
      //                     ? primarycolor2
      //                     : Color(0xFFe4e6f2),
      //                 borderRadius: BorderRadius.circular(10),
      //               ),

      //               // child: Text(
      //               //   data['title'],
      //               //   textDirection: TextDirection.rtl,
      //               //   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
      //               // ),
      //             ),
      //             SizedBox(height: 10),
      //   ],
      // ),
      //   ),
      // ),
    );
  }
}
