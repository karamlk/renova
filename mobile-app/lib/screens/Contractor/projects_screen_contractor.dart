import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:renove_provider/models/Contractor/contractor_data_models.dart';
import 'package:renove_provider/providers/Contractor/contractor_provider.dart';
import 'package:renove_provider/providers/Contractor/show_profile_provider.dart';
import 'package:renove_provider/screens/Contractor/add_post_screen.dart';

class ProjectsScreenContractor extends StatefulWidget {
  const ProjectsScreenContractor({super.key});
  @override
  State<ProjectsScreenContractor> createState() =>
      _ProjectsScreenContractorState();
}

class _ProjectsScreenContractorState extends State<ProjectsScreenContractor> {
  int? get contractorId =>
      context.read<ContractorShowProfileProvider>().profile?.userId;
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final id = contractorId;
      if (id != null) context.read<ContractorProvider>().fetchPosts(id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final p = context.watch<ContractorProvider>(), id = contractorId;
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () => id == null ? Future.value() : p.fetchPosts(id),
        child: CustomScrollView(
          slivers: [
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(16, 20, 16, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'معرض أعمالي',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text('وثّق المشاريع المكتملة والجارية ليراها العملاء'),
                  ],
                ),
              ),
            ),
            if (p.isLoadingPosts && p.posts.isEmpty)
              const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator()),
              )
            else if (p.posts.isEmpty)
              const SliverFillRemaining(
                child: Center(child: Text('لا توجد أعمال منشورة بعد')),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverGrid.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: .72,
                  ),
                  itemCount: p.posts.length,
                  itemBuilder: (_, i) => _PostCard(post: p.posts[i]),
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: id == null
          ? null
          : FloatingActionButton.extended(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => AddPostScreen(contractorId: id),
                ),
              ),
              icon: const Icon(Icons.add),
              label: const Text('إضافة عمل'),
            ),
    );
  }
}

class _PostCard extends StatelessWidget {
  const _PostCard({required this.post});
  final ContractorPost post;
  @override
  Widget build(BuildContext context) {
    final p = context.read<ContractorProvider>();
    final url = post.imageUrls.isEmpty ? '' : p.imageUrl(post.imageUrls.first);
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: url.isEmpty
                ? const Center(child: Icon(Icons.home_repair_service, size: 45))
                : Image.network(
                    url,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    webHtmlElementStrategy: WebHtmlElementStrategy.prefer,
                    errorBuilder: (_, __, ___) =>
                        const Center(child: Icon(Icons.broken_image_outlined)),
                  ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 8, 10, 4),
            child: Text(
              post.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: LinearProgressIndicator(value: post.progress / 100),
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Text(
                  post.status == 'completed' ? 'مكتمل' : '${post.progress}%',
                ),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.delete_outline),
                onPressed: () async {
                  final yes =
                      await showDialog<bool>(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: const Text('حذف هذا العمل؟'),
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
                  if (yes) p.deletePost(post.id);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
