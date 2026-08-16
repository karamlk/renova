import 'package:engineer_app/extras/theme.dart';
import 'package:engineer_app/providers/auth_provider.dart';
import 'package:engineer_app/providers/engineer/forms_provider.dart';
import 'package:engineer_app/providers/engineer/projects_provider.dart';
import 'package:engineer_app/providers/engineer/visits_provider.dart';
import 'package:engineer_app/providers/navigation_provider.dart';
import 'package:engineer_app/screens/Engineer/audit/audit_index_screen.dart';
import 'package:engineer_app/screens/Engineer/home_screens/Profile/show_profile_engineer_screen.dart';
import 'package:engineer_app/screens/Engineer/home_screens/engineer_menu.dart';
import 'package:engineer_app/screens/Engineer/home_screens/engineer_projects.dart';
import 'package:engineer_app/screens/Engineer/home_screens/home_screen_engineer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeMainEngineer extends StatefulWidget {
  const HomeMainEngineer({super.key});
  @override
  State<HomeMainEngineer> createState() => _HomeMainEngineerState();
}

class _HomeMainEngineerState extends State<HomeMainEngineer> {
  static const pages = [
    HomeScreenEngineer(),
    AuditIndexScreen(),
    EngineerProjects(),
    EngineerMenu(),
  ];
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final token = context.read<AuthProvider>().token;
      if (token == null) return;
      context.read<ProjectsProvider>().fetchProjects(token);
      context.read<FormsProvider>().fetchForms(token);
      context.read<VisitsProvider>().fetchVisits(token);
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      leading: IconButton(
        icon: const Icon(Icons.settings, size: 30),
        onPressed: () {},
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: IconButton(
            icon: const Icon(Icons.person_rounded, size: 30),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const ShowProfileEngineerScreen(),
              ),
            ),
          ),
        ),
      ],
    ),
    body: Consumer<NavigationProvider>(
      builder: (_, nav, _) =>
          IndexedStack(index: nav.currentIndex, children: pages),
    ),
    bottomNavigationBar: Consumer<NavigationProvider>(
      builder: (_, nav, _) => NavigationBarTheme(
        data: NavigationBarThemeData(
          indicatorColor: primarycolor2,
          iconTheme: WidgetStateProperty.resolveWith(
            (states) => IconThemeData(
              color: states.contains(WidgetState.selected)
                  ? primarycolor1
                  : primarycolor2,
            ),
          ),
          labelTextStyle: WidgetStateProperty.all(
            const TextStyle(
              color: primarycolor2,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
        child: NavigationBar(
          selectedIndex: nav.currentIndex,
          onDestinationSelected: nav.changeIndex,
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home),
              label: 'الرئيسية',
            ),
            NavigationDestination(
              icon: Icon(Icons.fact_check_outlined),
              selectedIcon: Icon(Icons.fact_check),
              label: 'التدقيق',
            ),
            NavigationDestination(
              icon: Icon(Icons.work_outline),
              selectedIcon: Icon(Icons.work),
              label: 'مشاريعي',
            ),
            NavigationDestination(
              icon: Icon(Icons.grid_view_outlined),
              selectedIcon: Icon(Icons.grid_view_rounded),
              label: 'قائمتي',
            ),
          ],
        ),
      ),
    ),
  );
}
