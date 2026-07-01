import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:renove_provider/models/Contractor/contractor_data_models.dart';
import 'package:renove_provider/providers/Contractor/contractor_provider.dart';

class ScheduleScreenContractor extends StatefulWidget {
  const ScheduleScreenContractor({super.key});
  @override
  State<ScheduleScreenContractor> createState() =>
      _ScheduleScreenContractorState();
}

class _ScheduleScreenContractorState extends State<ScheduleScreenContractor> {
  static const days = {
    'sunday': 'الأحد',
    'monday': 'الإثنين',
    'tuesday': 'الثلاثاء',
    'wednesday': 'الأربعاء',
    'thursday': 'الخميس',
    'friday': 'الجمعة',
    'saturday': 'السبت',
  };
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<ContractorProvider>().fetchSchedules());
  }

  @override
  Widget build(BuildContext context) {
    final p = context.watch<ContractorProvider>();
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: p.fetchSchedules,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text(
              'جدول الدوام الأسبوعي',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            const Text('أضف الأوقات التي تناسبك للزيارات الميدانية'),
            const SizedBox(height: 18),
            if (p.isLoadingSchedules && p.schedules.isEmpty)
              const Padding(
                padding: EdgeInsets.all(40),
                child: Center(child: CircularProgressIndicator()),
              )
            else if (p.schedules.isEmpty)
              const Padding(
                padding: EdgeInsets.all(40),
                child: Center(child: Text('لم تضف أوقات دوام بعد')),
              )
            else
              ...p.schedules.map((s) => _scheduleCard(context, s)),
            if (p.errorMessage != null)
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  p.errorMessage!,
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: p.isSaving ? null : () => _edit(context),
        icon: const Icon(Icons.add),
        label: const Text('إضافة وقت'),
      ),
    );
  }

  Widget _scheduleCard(BuildContext context, ContractorSchedule s) => Card(
    child: ListTile(
      leading: const CircleAvatar(child: Icon(Icons.schedule)),
      title: Text(
        days[s.day] ?? s.day,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text('${s.date}\n${s.startTime} - ${s.endTime}'),
      isThreeLine: true,
      trailing: PopupMenuButton<String>(
        onSelected: (v) {
          if (v == 'edit')
            _edit(context, s);
          else
            _delete(context, s);
        },
        itemBuilder: (_) => const [
          PopupMenuItem(value: 'edit', child: Text('تعديل')),
          PopupMenuItem(value: 'delete', child: Text('حذف')),
        ],
      ),
    ),
  );

  Future<void> _delete(BuildContext context, ContractorSchedule s) async {
    final yes =
        await showDialog<bool>(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('حذف الموعد؟'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('إلغاء'),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('حذف'),
              ),
            ],
          ),
        ) ??
        false;
    if (yes) await context.read<ContractorProvider>().deleteSchedule(s.id);
  }

  Future<void> _edit(BuildContext context, [ContractorSchedule? value]) async {
    String day = value?.day ?? 'sunday';
    TimeOfDay start =
        _parse(value?.startTime) ?? const TimeOfDay(hour: 8, minute: 0);
    TimeOfDay end =
        _parse(value?.endTime) ?? const TimeOfDay(hour: 16, minute: 0);
    await showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (_, setDialog) => AlertDialog(
          title: Text(value == null ? 'إضافة وقت' : 'تعديل الوقت'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                initialValue: day,
                decoration: const InputDecoration(labelText: 'اليوم'),
                items: days.entries
                    .map(
                      (e) =>
                          DropdownMenuItem(value: e.key, child: Text(e.value)),
                    )
                    .toList(),
                onChanged: (v) => setDialog(() => day = v!),
              ),
              ListTile(
                title: const Text('وقت البداية'),
                trailing: Text(_apiTime(start)),
                onTap: () async {
                  final t = await showTimePicker(
                    context: dialogContext,
                    initialTime: start,
                  );
                  if (t != null) setDialog(() => start = t);
                },
              ),
              ListTile(
                title: const Text('وقت النهاية'),
                trailing: Text(_apiTime(end)),
                onTap: () async {
                  final t = await showTimePicker(
                    context: dialogContext,
                    initialTime: end,
                  );
                  if (t != null) setDialog(() => end = t);
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('إلغاء'),
            ),
            FilledButton(
              onPressed: () async {
                final nav = Navigator.of(dialogContext);
                final ok = await context
                    .read<ContractorProvider>()
                    .saveSchedule(
                      id: value?.id,
                      day: day,
                      startTime: _apiTime(start),
                      endTime: _apiTime(end),
                    );
                if (ok) nav.pop();
              },
              child: const Text('حفظ'),
            ),
          ],
        ),
      ),
    );
  }

  String _apiTime(TimeOfDay t) {
    final h = t.hourOfPeriod == 0 ? 12 : t.hourOfPeriod;
    return '${h.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')} ${t.period == DayPeriod.am ? 'AM' : 'PM'}';
  }

  TimeOfDay? _parse(String? text) {
    if (text == null || text.isEmpty) return null;
    final m = RegExp(
      r'(\d+):(\d+)\s*(AM|PM)',
      caseSensitive: false,
    ).firstMatch(text);
    if (m == null) return null;
    var h = int.parse(m.group(1)!);
    if (m.group(3)!.toUpperCase() == 'PM' && h != 12) h += 12;
    if (m.group(3)!.toUpperCase() == 'AM' && h == 12) h = 0;
    return TimeOfDay(hour: h, minute: int.parse(m.group(2)!));
  }
}
