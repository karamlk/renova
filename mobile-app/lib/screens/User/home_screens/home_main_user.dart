import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:renove_provider/extras/theme.dart';
import 'package:renove_provider/providers/navigation_provider.dart';
import 'package:renove_provider/providers/theme_provider.dart';
import 'package:renove_provider/screens/User/home_screens/contractors_requests_user.dart';
import 'package:renove_provider/screens/User/home_screens/inspection_index_screen.dart';

import 'package:renove_provider/screens/User/home_screens/requests_index_list.dart';
import 'package:renove_provider/screens/User/home_screens/my_projects_user.dart';
import 'package:renove_provider/screens/User/home_screens/home_screen_user.dart';
import 'package:renove_provider/screens/settings/settings.dart';
import 'package:renove_provider/screens/User/Profile/show_profile_screen.dart';

class HomeMainUser extends StatelessWidget {
  const HomeMainUser({super.key});
  final List<Widget> pages = const [
    HomeScreenUser(),
    RequestsIndexList(),
    InspectionIndexScreen(),
    ContractorsRequests(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 70,
        leading: IconButton(
          iconSize: 30,
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => Settings()));
          },
          icon: Icon(
            Icons.settings,
            color: context.watch<ThemeProvider>().isDark ? Colors.white : primarycolor2,
          ),
        ),

        elevation: 10,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: IconButton(
              iconSize: 30,
              onPressed: () {
                Navigator.of(
                  context,
                ).push(MaterialPageRoute(builder: (context) => ShowprofileScreen()));
              },
              icon: Icon(Icons.person_rounded),
              color: context.watch<ThemeProvider>().isDark ? Colors.white : primarycolor2,
            ),
          ),
        ],
      ),
      body: Consumer<NavigationProvider>(
        builder: (context, nav, child) => IndexedStack(index: nav.currentIndex, children: pages),
      ),
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          overlayColor: WidgetStateProperty.all(Colors.transparent),
          elevation: 0,
          iconTheme: WidgetStateProperty.resolveWith<IconThemeData>((states) {
            if (states.contains(WidgetState.selected)) {
              return IconThemeData(color: primarycolor1);
            }
            return IconThemeData(
              color: context.watch<ThemeProvider>().isDark ? Colors.white : primarycolor2,
            );
          }),
          labelTextStyle: WidgetStateProperty.resolveWith<TextStyle>((states) {
            if (states.contains(WidgetState.selected)) {
              return GoogleFonts.tajawal(
                color: primarycolor1,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ); //
            }
            return TextStyle(
              color: context.watch<ThemeProvider>().isDark ? Colors.white : primarycolor2,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ); //
          }),
        ),
        child: Consumer<NavigationProvider>(
          builder: (context, nav, child) => NavigationBar(
            selectedIndex: nav.currentIndex,
            onDestinationSelected: (index) {
              context.read<NavigationProvider>().changeIndex(index);
            },
            destinations: [
              NavigationDestination(
                icon: Icon(Icons.home_outlined),
                selectedIcon: Icon(Icons.home),
                label: "الرئيسية",
              ),
              NavigationDestination(
                icon: Icon(Icons.request_page_outlined),
                selectedIcon: Icon(Icons.request_page),
                label: "الطلبات المرسلة",
              ),
              NavigationDestination(
                icon: Icon(Icons.work_outline),
                selectedIcon: Icon(Icons.work),
                label: "العروض",
              ),
              NavigationDestination(
                icon: Icon(Icons.grid_3x3_outlined),
                selectedIcon: Icon(Icons.request_page_outlined),
                label: "العروض",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
