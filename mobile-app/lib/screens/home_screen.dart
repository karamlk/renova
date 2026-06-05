import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:renove_provider/extras/theme.dart';
import 'package:renove_provider/providers/navigation_provider.dart';
import 'package:renove_provider/screens/home2_test.dart';
import 'package:renove_provider/screens/home3_test.dart';
import 'package:renove_provider/screens/home_test.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  final List<Widget> pages = const [HomeTab(), Home2Tab(), Home3Tab()];

  @override
  Widget build(BuildContext context) {
    return Consumer<NavigationProvider>(
      builder: (context, nav, child) => Scaffold(
        body: IndexedStack(index: nav.currentIndex, children: pages),
        bottomNavigationBar: NavigationBarTheme(
          data: NavigationBarThemeData(
            overlayColor: WidgetStateProperty.all(Colors.transparent),
            elevation: 0,
            iconTheme: WidgetStateProperty.resolveWith<IconThemeData>((states) {
              if (states.contains(WidgetState.selected)) {
                return IconThemeData(color: primarycolor1);
              }
              return IconThemeData(color: primarycolor2);
            }),
            labelTextStyle: WidgetStateProperty.resolveWith<TextStyle>((states) {
              if (states.contains(WidgetState.selected)) {
                return TextStyle(
                  color: primarycolor1,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ); //
              }
              return TextStyle(color: primarycolor2, fontWeight: FontWeight.bold, fontSize: 14); //
            }),
          ),
          child: NavigationBar(
            selectedIndex: nav.currentIndex,
            onDestinationSelected: (index) {
              context.read<NavigationProvider>().changeIndex(index);
            },
            destinations: [
              NavigationDestination(
                icon: Icon(Icons.home_outlined),
                selectedIcon: Icon(Icons.home),
                label: "Home",
              ),
              NavigationDestination(
                icon: Icon(Icons.person_outline),
                selectedIcon: Icon(Icons.person),
                label: "Profile",
              ),
              NavigationDestination(
                icon: Icon(Icons.settings_outlined),
                selectedIcon: Icon(Icons.settings),
                label: "Settings",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
