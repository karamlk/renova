import 'package:engineer_app/extras/theme.dart';
import 'package:engineer_app/providers/auth_provider.dart';
import 'package:engineer_app/providers/theme_provider.dart';
import 'package:engineer_app/screens/Engineer/home_screens/Profile/show_profile_engineer_screen.dart';
import 'package:engineer_app/screens/Engineer/visits/engineer_visits_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EngineerMenu extends StatelessWidget {
  const EngineerMenu({super.key});
  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.all(20),
    children: [
      const Text(
        'قائمتي',
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: primarycolor2,
        ),
      ),
      const SizedBox(height: 12),
      Card(
        child: Column(
          children: [
            ListTile(
              leading: const Icon(Icons.person_outline),
              title: const Text('الملف الشخصي'),
              trailing: const Icon(Icons.chevron_left),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ShowProfileEngineerScreen(),
                ),
              ),
            ),
            const Divider(height: 1),
            Consumer<ThemeProvider>(
              builder: (context, theme, _) => SwitchListTile(
                secondary: Icon(
                  theme.isDarkMode
                      ? Icons.dark_mode_outlined
                      : Icons.light_mode_outlined,
                ),
                title: const Text('الوضع الداكن'),
                value: theme.isDarkMode,
                onChanged: theme.setDarkMode,
              ),
            ),
            const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.event_note_outlined),
              title: const Text('الزيارات الميدانية'),
              trailing: const Icon(Icons.chevron_left),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const EngineerVisitsScreen()),
              ),
            ),
            const Divider(height: 1),
            const ListTile(
              leading: Icon(Icons.notifications_outlined),
              title: Text('الإشعارات'),
            ),
            const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text(
                'تسجيل الخروج',
                style: TextStyle(color: Colors.red),
              ),
              onTap: () => context.read<AuthProvider>().logout(),
            ),
          ],
        ),
      ),
    ],
  );
}
