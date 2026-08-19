import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:renove_provider/extras/theme.dart';
import 'package:renove_provider/providers/navigation_provider.dart';
import 'package:renove_provider/providers/theme_provider.dart';
import 'package:renove_provider/screens/Contractor/home_screens/Profile/show_profile_contractor_screen.dart';
import 'package:renove_provider/screens/Contractor/home_screens/contractor_projects.dart';
import 'package:renove_provider/screens/Contractor/home_screens/home_screen_contractor.dart';
import 'package:renove_provider/screens/Contractor/home_screens/home_menu_contractor.dart';
import 'package:renove_provider/screens/Contractor/home_screens/user_requests_index.dart';
import 'package:renove_provider/screens/Contractor/notification/notificaton_page.dart';
import 'package:renove_provider/screens/User/notifications/notifications_index_user.dart';
import 'package:renove_provider/screens/settings/contractor_settings.dart';

class HomeMainContractor extends StatelessWidget {
  const HomeMainContractor({super.key});
  final List<Widget> pages = const [
    HomeScreenContractor(),
    UserRequestsIndex(),
    ContractorProjects(),
    HomwMenuContractor(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 70,

        leading: IconButton(
          iconSize: 30,

          onPressed: () {
            Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (context) => NotificationsIndexUser()));
          },
          icon: Icon(
            Icons.notifications_rounded,
            color: context.watch<ThemeProvider>().isDark ? Colors.white70 : primarycolor2,
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
                ).push(MaterialPageRoute(builder: (context) => ShowProfileContractorScreen()));
              },
              icon: Icon(
                Icons.person_rounded,
                color: context.watch<ThemeProvider>().isDark ? Colors.white70 : primarycolor2,
              ),
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
              color: context.watch<ThemeProvider>().isDark ? Colors.white60 : primarycolor2,
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
            return GoogleFonts.tajawal(
              color: context.watch<ThemeProvider>().isDark ? Colors.white60 : primarycolor2,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            );
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
                label: "الطلبات",
              ),
              NavigationDestination(
                icon: Icon(Icons.work_outline),
                selectedIcon: Icon(Icons.work),
                label: "مشاريعي",
              ),
              NavigationDestination(
                icon: Icon(Icons.grid_view_outlined),
                selectedIcon: Icon(Icons.grid_view_rounded),
                label: "قائمتي",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
