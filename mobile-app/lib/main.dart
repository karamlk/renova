import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:renove_provider/extras/theme.dart';
import 'package:renove_provider/providers/auth_provider.dart';
import 'package:renove_provider/providers/navigation_provider.dart';
import 'package:renove_provider/providers/profile_provider.dart';
import 'package:renove_provider/screens/home_screen.dart';
import 'package:renove_provider/screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final authProvider = AuthProvider();
  await authProvider.loadUser();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: authProvider),
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
        ChangeNotifierProvider(create: (_) => NavigationProvider()),
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
        debugShowCheckedModeBanner: false,
        home: auth.isLoggedin ? HomeScreen() : LoginScreen(),
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: primarycolor2, // 👈 your accent color
          ).copyWith(primary: primarycolor2, secondary: primarycolor1),
        ),
      ),
    );
  }
}
