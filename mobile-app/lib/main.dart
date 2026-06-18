import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:renove_provider/extras/theme.dart';
import 'package:renove_provider/providers/auth_provider.dart';
import 'package:renove_provider/providers/navigation_provider.dart';
import 'package:renove_provider/providers/User/create_profile_provider.dart';
import 'package:renove_provider/providers/User/show_profile_provider.dart';
import 'package:renove_provider/screens/Auth/login_screen.dart';
import 'package:renove_provider/screens/Contractor/home_screen_contractor.dart';
import 'package:renove_provider/screens/User/home_screens/home_main_user.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final authProvider = AuthProvider();
  await authProvider.loadUser();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: authProvider),
        ChangeNotifierProvider(create: (_) => CreateProfileProvider()),
        ChangeNotifierProvider(create: (_) => NavigationProvider()),
        ChangeNotifierProvider(create: (_) => ShowprofileProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, auth, child) => MaterialApp(
        locale: const Locale('ar'),
        debugShowCheckedModeBanner: false,
        home: auth.isLoggedin
            ? (auth.roleLogin == "user" ? HomeMainUser() : HomeScreenContractor())
            : LoginScreen(),

        theme: ThemeData(
          useMaterial3: true,
          textTheme: GoogleFonts.cairoTextTheme(),
          primaryTextTheme: GoogleFonts.cairoTextTheme(),
          colorScheme: ColorScheme.fromSeed(
            seedColor: primarycolor2,
          ).copyWith(primary: primarycolor2, secondary: primarycolor1),
        ),
      ),
    );
  }
}
