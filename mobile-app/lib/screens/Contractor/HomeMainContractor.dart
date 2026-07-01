import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:renove_provider/extras/theme.dart';
import 'package:renove_provider/providers/Contractor/contractor_provider.dart';
import 'package:renove_provider/providers/Contractor/show_profile_provider.dart';
import 'package:renove_provider/providers/navigation_provider.dart';
import 'package:renove_provider/providers/theme_provider.dart';
import 'package:renove_provider/screens/Contractor/profile/show_profile_contractor_screen.dart';

import 'package:renove_provider/screens/settings/settings.dart';

import 'package:renove_provider/screens/Contractor/home_screen_contractor.dart';
import 'package:renove_provider/screens/Contractor/requests_screen_contractor.dart';
import 'package:renove_provider/screens/Contractor/projects_screen_contractor.dart';
import 'package:renove_provider/screens/Contractor/schedule_screen_contractor.dart';

class HomeMainContractor extends StatelessWidget {
  const HomeMainContractor({super.key});

  final List<Widget> pages = const [
    HomeScreenContractor(),
    RequestsScreenContractor(),
    ProjectsScreenContractor(),
    ScheduleScreenContractor(),
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
            ).push(MaterialPageRoute(builder: (context) => Settings()));
          },
          icon: Icon(
            Icons.settings,
            color: context.watch<ThemeProvider>().isDark
                ? Colors.white
                : primarycolor2,
          ),
        ),
        elevation: 10,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: IconButton(
              iconSize: 30,
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const ShowProfileContractorScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.person_rounded),
              color: context.watch<ThemeProvider>().isDark
                  ? Colors.white
                  : primarycolor2,
            ),
          ),
        ],
      ),

      body: Consumer<NavigationProvider>(
        builder: (context, nav, child) {
          return IndexedStack(index: nav.currentIndex, children: pages);
        },
      ),

      bottomNavigationBar: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 15,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: NavigationBarTheme(
            data: NavigationBarThemeData(
              backgroundColor: context.watch<ThemeProvider>().isDark
                  ? const Color(0xff1E1E1E)
                  : Colors.white,

              indicatorColor: primarycolor1.withOpacity(0.15),

              height: 72,

              labelTextStyle: WidgetStateProperty.resolveWith<TextStyle>((
                states,
              ) {
                return GoogleFonts.tajawal(
                  fontSize: 12,
                  fontWeight: states.contains(WidgetState.selected)
                      ? FontWeight.bold
                      : FontWeight.w500,
                  color: states.contains(WidgetState.selected)
                      ? primarycolor1
                      : (context.watch<ThemeProvider>().isDark
                            ? Colors.white
                            : primarycolor2),
                );
              }),

              iconTheme: WidgetStateProperty.resolveWith<IconThemeData>((
                states,
              ) {
                return IconThemeData(
                  size: states.contains(WidgetState.selected) ? 28 : 24,
                  color: states.contains(WidgetState.selected)
                      ? primarycolor1
                      : (context.watch<ThemeProvider>().isDark
                            ? Colors.white
                            : primarycolor2),
                );
              }),
            ),

            child: Consumer<NavigationProvider>(
              builder: (context, nav, child) {
                return NavigationBar(
                  selectedIndex: nav.currentIndex,

                  onDestinationSelected: (index) {
                    context.read<NavigationProvider>().changeIndex(index);
                    final contractor = context.read<ContractorProvider>();
                    if (index == 0) {
                      contractor.loadDashboard(
                        contractorId: context
                            .read<ContractorShowProfileProvider>()
                            .profile
                            ?.userId,
                      );
                    } else if (index == 1) {
                      contractor.fetchRequests();
                    } else if (index == 2) {
                      final id = context
                          .read<ContractorShowProfileProvider>()
                          .profile
                          ?.userId;
                      if (id != null) contractor.fetchPosts(id);
                    } else if (index == 3) {
                      contractor.fetchSchedules();
                    }
                  },

                  destinations: const [
                    NavigationDestination(
                      icon: Icon(Icons.home_outlined),
                      selectedIcon: Icon(Icons.home),
                      label: "الرئيسية",
                    ),

                    NavigationDestination(
                      icon: Icon(Icons.assignment_outlined),
                      selectedIcon: Icon(Icons.assignment),
                      label: "الطلبات",
                    ),

                    NavigationDestination(
                      icon: Icon(Icons.work_outline),
                      selectedIcon: Icon(Icons.work),
                      label: "أعمالي",
                    ),

                    NavigationDestination(
                      icon: Icon(Icons.calendar_month_outlined),
                      selectedIcon: Icon(Icons.calendar_month),
                      label: "الدوام",
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
