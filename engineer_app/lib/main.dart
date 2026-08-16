import 'package:engineer_app/providers/auth_provider.dart';
import 'package:engineer_app/providers/engineer/projects_provider.dart';
import 'package:engineer_app/providers/engineer/forms_provider.dart';
import 'package:engineer_app/providers/engineer/visits_provider.dart';
import 'package:engineer_app/providers/engineer/no_show_warnings_provider.dart';
import 'package:engineer_app/providers/engineer/profile_provider.dart';
import 'package:engineer_app/providers/navigation_provider.dart';
import 'package:engineer_app/providers/theme_provider.dart';
import 'package:engineer_app/screens/Auth/login_screen.dart';
import 'package:engineer_app/screens/Engineer/home_screens/home_main_engineer.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'extras/theme.dart';

void main() {
  runApp(const EngineerApp());
}

class EngineerApp extends StatelessWidget {
  const EngineerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => NavigationProvider()),
        ChangeNotifierProvider(create: (_) => ProjectsProvider()),
        ChangeNotifierProvider(create: (_) => FormsProvider()),
        ChangeNotifierProvider(create: (_) => VisitsProvider()),
        ChangeNotifierProvider(create: (_) => NoShowWarningsProvider()),
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()..load()),
      ],
      child: const _EngineerMaterialApp(),
    );
  }
}

class _EngineerMaterialApp extends StatelessWidget {
  const _EngineerMaterialApp();

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    return MaterialApp(
      title: 'منصة المهندس',
      debugShowCheckedModeBanner: false,
      locale: const Locale('ar'),
      builder: (context, child) =>
          Directionality(textDirection: TextDirection.rtl, child: child!),
      themeMode: themeProvider.themeMode,
      theme: _lightTheme(),
      darkTheme: _darkTheme(),
      home: Consumer<AuthProvider>(
        builder: (context, auth, _) =>
            auth.isLoggedIn ? const HomeMainEngineer() : const LoginScreen(),
      ),
    );
  }

  ThemeData _lightTheme() => ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: const Color(0xfff0f1f3),
    textTheme: GoogleFonts.tajawalTextTheme(),
    primaryTextTheme: GoogleFonts.tajawalTextTheme(),
    colorScheme: ColorScheme.fromSeed(
      seedColor: primarycolor2,
    ).copyWith(primary: primarycolor2, secondary: primarycolor1),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xfff0f1f3),
      foregroundColor: primarycolor2,
      elevation: 0,
    ),
  );

  ThemeData _darkTheme() => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xff171a20),
    textTheme: GoogleFonts.tajawalTextTheme(ThemeData.dark().textTheme),
    primaryTextTheme: GoogleFonts.tajawalTextTheme(ThemeData.dark().textTheme),
    colorScheme: ColorScheme.fromSeed(
      brightness: Brightness.dark,
      seedColor: primarycolor1,
    ).copyWith(primary: primarycolor1, secondary: primarycolor1),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xff171a20),
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    cardTheme: const CardThemeData(color: Color(0xff242a33)),
    inputDecorationTheme: const InputDecorationTheme(
      filled: true,
      fillColor: Color(0xff242a33),
    ),
  );
}
