import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:renove_provider/providers/Contractor/show_profile_provider.dart';
import 'package:renove_provider/screens/Contractor/HomeMainContractor.dart';
import 'package:renove_provider/screens/Contractor/waiting_approval_screen.dart';
import 'package:renove_provider/screens/Contractor/profile/contractor_profile_form_screen.dart';

class ContractorRootScreen extends StatefulWidget {
  const ContractorRootScreen({super.key});

  @override
  State<ContractorRootScreen> createState() => _ContractorRootScreenState();
}

class _ContractorRootScreenState extends State<ContractorRootScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      print("========== FETCH PROFILE ==========");

      await context.read<ContractorShowProfileProvider>().fetchProfile();

      final provider = context.read<ContractorShowProfileProvider>();

      print("Loading : ${provider.isLoading}");
      print("Profile : ${provider.profile}");
      print("Status  : ${provider.profile?.status}");
      print("===================================");
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ContractorShowProfileProvider>();

    print("BUILD");
    print("isLoading = ${provider.isLoading}");
    print("profile = ${provider.profile}");
    print("status = ${provider.profile?.status}");

    if (provider.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (provider.profile == null) {
      return Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.assignment_ind_outlined, size: 72),
                const SizedBox(height: 16),
                Text(
                  provider.errorMessage ??
                      'أكمل بيانات المقاول لإرسالها إلى الإدارة',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 18),
                FilledButton.icon(
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ContractorProfileFormScreen(
                          isFirstSetup: true,
                        ),
                      ),
                    );
                    if (mounted)
                      context
                          .read<ContractorShowProfileProvider>()
                          .fetchProfile();
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('إكمال الملف'),
                ),
                TextButton(
                  onPressed: provider.fetchProfile,
                  child: const Text('إعادة المحاولة'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    if (provider.profile!.status.toLowerCase() == "approved") {
      print("GO TO HOME");
      return const HomeMainContractor();
    }

    print("GO TO WAITING");

    return const WaitingApprovalScreen();
  }
}
