import 'package:flutter/material.dart';
import 'package:renove_provider/extras/theme.dart';
import 'package:renove_provider/screens/User/home_screens/create_request_dialogue.dart';

class HomeScreenUser extends StatelessWidget {
  const HomeScreenUser({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        foregroundColor: primarycolor1,
        backgroundColor: primarycolor2,

        isExtended: true,

        onPressed: () {
          showDialog(
            context: context,
            fullscreenDialog: true,
            builder: (_) => CreateRequestDialogue(),
          );
        },
        child: Icon(Icons.add, size: 40),
      ),
    );
  }
}
