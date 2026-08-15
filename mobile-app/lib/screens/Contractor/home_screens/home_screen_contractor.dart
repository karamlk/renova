import 'package:flutter/material.dart';
import 'package:renove_provider/extras/theme.dart';
import 'package:renove_provider/screens/Contractor/posts/create_post.dart';

class HomeScreenContractor extends StatelessWidget {
  const HomeScreenContractor({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        foregroundColor: primarycolor1,
        backgroundColor: primarycolor2,

        isExtended: true,

        onPressed: () {},
        label: Text('منشور جديد', style: TextStyle(fontWeight: FontWeight.bold)),
        icon: Icon(Icons.add),
      ),
    );
  }
}
