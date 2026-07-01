import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:renove_provider/extras/theme.dart';
import 'package:renove_provider/providers/Contractor/contractor_provider.dart';
import 'package:renove_provider/providers/Contractor/show_profile_provider.dart';

class HomeScreenContractor extends StatefulWidget {
  const HomeScreenContractor({super.key});
  @override
  State<HomeScreenContractor> createState() => _HomeScreenContractorState();
}

class _HomeScreenContractorState extends State<HomeScreenContractor> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final id = context.read<ContractorShowProfileProvider>().profile?.userId;
      context.read<ContractorProvider>().loadDashboard(contractorId: id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final data = context.watch<ContractorProvider>(),
        profile = context.watch<ContractorShowProfileProvider>().profile;
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () => data.loadDashboard(contractorId: profile?.userId),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: primarycolor2,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'أهلاً ${profile?.firstName ?? ''} 👋',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    profile?.companyName?.isNotEmpty == true
                        ? profile!.companyName!
                        : 'لوحة إدارة أعمالك',
                    style: const TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'نظرة سريعة',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                _stat(
                  'الطلبات',
                  data.requests.length,
                  Icons.assignment_outlined,
                ),
                const SizedBox(width: 10),
                _stat('أعمالي', data.posts.length, Icons.work_outline),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                _stat('المواعيد', data.schedules.length, Icons.schedule),
                const SizedBox(width: 10),
                _stat(
                  'الزيارات',
                  data.visits.length,
                  Icons.location_on_outlined,
                ),
              ],
            ),
            const SizedBox(height: 22),
            const Text(
              'الزيارات الميدانية',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            if (data.isLoadingVisits && data.visits.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: CircularProgressIndicator(),
                ),
              )
            else if (data.visits.isEmpty)
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: Center(child: Text('لا توجد زيارات مؤكدة حالياً')),
                ),
              )
            else
              ...data.visits
                  .take(4)
                  .map(
                    (v) => Card(
                      child: ListTile(
                        leading: const CircleAvatar(
                          child: Icon(Icons.event_available),
                        ),
                        title: Text(v.title),
                        subtitle: Text(
                          '${v.location}\n${v.date}  ${v.startTime} - ${v.endTime}',
                        ),
                        isThreeLine: true,
                      ),
                    ),
                  ),
            if (data.errorMessage != null)
              Padding(
                padding: const EdgeInsets.all(12),
                child: Text(
                  data.errorMessage!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _stat(String label, int value, IconData icon) => Expanded(
    child: Card(
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            Icon(icon, color: primarycolor2, size: 28),
            const SizedBox(height: 6),
            Text(
              '$value',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Text(label),
          ],
        ),
      ),
    ),
  );
}
