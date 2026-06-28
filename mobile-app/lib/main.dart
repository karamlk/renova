import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:renove_provider/extras/theme.dart';
import 'package:renove_provider/providers/User/Inspection/inspection_provider.dart';
import 'package:renove_provider/providers/User/construction_index_provider.dart';
import 'package:renove_provider/providers/User/construction_request_provider.dart';
import 'package:renove_provider/providers/User/request_details_provider.dart';
import 'package:renove_provider/providers/auth_provider.dart';
import 'package:renove_provider/providers/navigation_provider.dart';
import 'package:renove_provider/providers/User/create_profile_provider.dart';
import 'package:renove_provider/providers/User/show_profile_provider.dart';
import 'package:renove_provider/providers/theme_provider.dart';
import 'package:renove_provider/screens/Auth/login_screen.dart';
import 'package:renove_provider/screens/Contractor/home_screen_contractor.dart';
import 'package:renove_provider/screens/User/home_screens/home_main_user.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final authProvider = AuthProvider();
  await authProvider.loadUser();
  final pref = await SharedPreferences.getInstance();

  final isDark = pref.getBool('darkMode') ?? false;

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: authProvider),
        ChangeNotifierProvider(create: (_) => CreateProfileProvider()),
        ChangeNotifierProvider(create: (_) => NavigationProvider()),
        ChangeNotifierProvider(create: (_) => ShowprofileProvider()),
        ChangeNotifierProvider(create: (_) => ConstructionRequestProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider(isDark: isDark)),
        ChangeNotifierProvider(create: (_) => ConstructionIndexProvider()),
        ChangeNotifierProvider(create: (_) => RequestDetailsProvider()),
        ChangeNotifierProvider(create: (_) => InspectionProvider()),
      ],
      child: MyApp(isDark: isDark),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.isDark});
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, auth, child) => MaterialApp(
        locale: const Locale('ar'),
        debugShowCheckedModeBanner: false,
        themeMode: context.watch<ThemeProvider>().thememode,

        home: auth.isLoggedin
            ? (auth.roleLogin == "user" ? HomeMainUser() : HomeScreenContractor())
            : LoginScreen(),

        theme: ThemeData(
          useMaterial3: true,
          textTheme: GoogleFonts.tajawalTextTheme(),
          primaryTextTheme: GoogleFonts.tajawalTextTheme(),
          colorScheme: ColorScheme.fromSeed(
            seedColor: primarycolor2,
          ).copyWith(primary: primarycolor2, secondary: primarycolor1),
        ),
        darkTheme: ThemeData(
          useMaterial3: true,
          brightness: Brightness.dark,
          textTheme: GoogleFonts.tajawalTextTheme(ThemeData.dark().textTheme),
          primaryTextTheme: GoogleFonts.tajawalTextTheme(ThemeData.dark().textTheme),
          colorScheme: ColorScheme.fromSeed(
            seedColor: primarycolor2,
            brightness: Brightness.dark,
          ).copyWith(primary: primarycolor2, secondary: primarycolor1),
        ),
      ),
    );
  }
}
