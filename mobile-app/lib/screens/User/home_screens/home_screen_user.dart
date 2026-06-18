import 'package:flutter/material.dart';
import 'package:renove_provider/extras/theme.dart';

class HomeMain extends StatelessWidget {
  const HomeMain({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        foregroundColor: primarycolor1,
        backgroundColor: primarycolor2,

        isExtended: true,

        onPressed: () {},
        child: Icon(Icons.add, size: 40),
      ),
    );
  }
}
