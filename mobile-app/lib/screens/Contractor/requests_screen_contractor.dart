import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:renove_provider/models/Contractor/contractor_data_models.dart';
import 'package:renove_provider/providers/Contractor/contractor_provider.dart';

class RequestsScreenContractor extends StatefulWidget {
  const RequestsScreenContractor({super.key});
  @override
  State<RequestsScreenContractor> createState() =>
      _RequestsScreenContractorState();
}

class _RequestsScreenContractorState extends State<RequestsScreenContractor> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<ContractorProvider>().fetchRequests());
  }

  @override
  Widget build(BuildContext context) {
    final p = context.watch<ContractorProvider>();
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: p.fetchRequests,
        child: CustomScrollView(
          slivers: [
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(16, 20, 16, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'الطلبات المتاحة',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text('استعرض طلبات الإعمار واطلب زيارة ميدانية'),
                  ],
                ),
              ),
            ),
            if (p.isLoadingRequests && p.requests.isEmpty)
              const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator()),
              )
            else if (p.errorMessage != null && p.requests.isEmpty)
              SliverFillRemaining(
                child: _Message(
                  message: p.errorMessage!,
                  onRetry: p.fetchRequests,
                ),
              )
            else if (p.requests.isEmpty)
              const SliverFillRemaining(
                child: _Message(message: 'لا توجد طلبات متاحة حالياً'),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverList.builder(
                  itemCount: p.requests.length,
                  itemBuilder: (_, i) => _RequestCard(request: p.requests[i]),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _RequestCard extends StatelessWidget {
  const _RequestCard({required this.request});
  final ContractorRequest request;
  @override
  Widget build(BuildContext context) {
    final p = context.watch<ContractorProvider>();
    final url = p.imageUrl(request.imageUrl);
    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (url.isNotEmpty)
            Image.network(
              url,
              height: 160,
              width: double.infinity,
              fit: BoxFit.cover,
              webHtmlElementStrategy: WebHtmlElementStrategy.prefer,
              errorBuilder: (_, __, ___) => const SizedBox(
                height: 110,
                child: Center(child: Icon(Icons.image_not_supported_outlined)),
              ),
            )
          else
            const SizedBox(
              height: 90,
              child: Center(child: Icon(Icons.construction, size: 42)),
            ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  request.title,
                  style: const TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  request.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 12,
                  runSpacing: 6,
                  children: [
                    _info(Icons.location_on_outlined, request.location),
                    _info(Icons.category_outlined, _type(request.type)),
                    _info(Icons.info_outline, request.status),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: p.isSaving
                        ? null
                        : () async {
                            final ok = await context
                                .read<ContractorProvider>()
                                .requestInspection(request.id);
                            if (!context.mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  ok
                                      ? 'تم إرسال طلب الزيارة'
                                      : (p.errorMessage ?? 'تعذر إرسال الطلب'),
                                ),
                              ),
                            );
                          },
                    icon: const Icon(Icons.location_searching),
                    label: const Text('طلب زيارة ميدانية'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _info(IconData icon, String value) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(icon, size: 18),
      const SizedBox(width: 4),
      Text(value.isEmpty ? 'غير محدد' : value),
    ],
  );
  String _type(String value) =>
      const {
        'construction': 'إعادة إعمار',
        'restoration': 'ترميم',
        'finishing': 'إكساء',
      }[value] ??
      value;
}

class _Message extends StatelessWidget {
  const _Message({required this.message, this.onRetry});
  final String message;
  final Future<void> Function()? onRetry;
  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.inbox_outlined, size: 60),
          const SizedBox(height: 12),
          Text(message, textAlign: TextAlign.center),
          if (onRetry != null)
            TextButton(onPressed: onRetry, child: const Text('إعادة المحاولة')),
        ],
      ),
    ),
  );
}
