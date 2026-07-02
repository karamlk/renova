import 'package:flutter/material.dart';
import 'package:renove_provider/extras/theme.dart';

class HomeScreenContractor extends StatelessWidget {
  const HomeScreenContractor({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        foregroundColor: primarycolor1,
        backgroundColor: primarycolor2,

        isExtended: true,

        onPressed: () {
          showDialog(context: context, fullscreenDialog: true, builder: (context) => AlertDialog());
        },
        child: Icon(Icons.add, size: 40),
      ),
    );
  }
}
