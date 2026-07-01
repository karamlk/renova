import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:renove_provider/providers/Contractor/show_profile_provider.dart';
import 'package:renove_provider/extras/theme.dart';

class WaitingApprovalScreen extends StatelessWidget {
  const WaitingApprovalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.hourglass_top_rounded,
                  size: 120,
                  color: primarycolor1,
                ),

                const SizedBox(height: 30),

                const Text(
                  "تم إرسال طلبك بنجاح",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 15),

                Text(
                  "تم إرسال طلب انضمامك كمتعهد إلى الإدارة.\nسيتم مراجعة بياناتك والموافقة عليها في أقرب وقت ممكن.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                    height: 1.7,
                  ),
                ),

                const SizedBox(height: 40),

                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: primarycolor1.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.info_outline),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text("سيصلك إشعار فور الموافقة على حسابك."),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton.icon(
                    onPressed: () => context
                        .read<ContractorShowProfileProvider>()
                        .fetchProfile(),
                    icon: const Icon(Icons.refresh),
                    label: const Text("تحديث الحالة"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
