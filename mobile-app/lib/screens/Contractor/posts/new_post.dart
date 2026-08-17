import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:renove_provider/extras/theme.dart';
import 'package:renove_provider/models/Contractor/post/create_post.dart';
import 'package:renove_provider/providers/Contractor/post_provider.dart';
import 'package:renove_provider/providers/theme_provider.dart';

class NewPost extends StatefulWidget {
  const NewPost({super.key});

  @override
  State<NewPost> createState() => _NewPostState();
}

class _NewPostState extends State<NewPost> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  String? selectedProject;
  int? projectId;
  String? status;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('منشور جديد', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: ListView(
          padding: EdgeInsets.all(30),
          children: [
            Consumer<PostProvider>(
              builder: (context, value, child) => ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  backgroundColor: context.watch<ThemeProvider>().isDark
                      ? Colors.white30
                      : primarycolor2,
                  foregroundColor: primarycolor1,
                ),
                onPressed: () async {
                  final response = await value.fetchProjectPosts();
                  if (!context.mounted) return;

                  if (response?.statusCode == 200) {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        if (value.newPost.isEmpty) {
                          return Center(
                            child: Text(
                              'لا يوجد أي مشاريع للنشر',
                              style: TextStyle(fontWeight: FontWeight.bold, color: primarycolor1),
                            ),
                          );
                        }
                        return ListView.builder(
                          padding: EdgeInsets.all(30),
                          itemCount: value.newPost.length,
                          itemBuilder: (context, index) {
                            final newpost = value.newPost[index];
                            return Card(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  minimumSize: Size(double.infinity, 60),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  backgroundColor: context.watch<ThemeProvider>().isDark
                                      ? Colors.white30
                                      : primarycolor2,
                                  foregroundColor: primarycolor1,
                                ),
                                onPressed: () {
                                  projectId = newpost.id;
                                  selectedProject = newpost.title;
                                  status = newpost.status;
                                  Navigator.of(context).pop();
                                },
                                child: Text(
                                  newpost.title,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    );
                  }
                },
                child: Text(
                  selectedProject ?? 'اختر مشروعا',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SizedBox(height: 30),
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: "العنوان",
                labelStyle: TextStyle(
                  color: context.read<ThemeProvider>().isDark ? primarycolor1 : primarycolor2,
                ),
                border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
              ),
            ),
            SizedBox(height: 40),
            TextField(
              controller: descriptionController,

              maxLines: 3,
              decoration: InputDecoration(
                alignLabelWithHint: true,
                labelText: "الوصف",
                labelStyle: TextStyle(
                  color: context.read<ThemeProvider>().isDark ? primarycolor1 : primarycolor2,
                ),
                border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
              ),
            ),
            SizedBox(height: 40),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                backgroundColor: context.watch<ThemeProvider>().isDark
                    ? Colors.white30
                    : primarycolor2,
                foregroundColor: primarycolor1,
              ),
              onPressed: () {
                context.read<PostProvider>().pickPostImages();
              },
              child: Row(
                spacing: 10,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.upload),
                  Text("رفع صور", style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            SizedBox(height: 40),
            Consumer<PostProvider>(
              builder: (context, value, child) {
                if (value.postImages.isEmpty) {
                  return const SizedBox.shrink();
                }
                return SizedBox(
                  height: 100,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: value.postImages.length,
                    separatorBuilder: (context, index) => const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      final image = value.postImages[index];
                      return Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(image, width: 100, height: 100, fit: BoxFit.cover),
                          ),
                          Positioned(
                            top: 4,
                            right: 4,
                            child: GestureDetector(
                              onTap: () {
                                value.removeImage(index);
                              },
                              child: Container(
                                padding: const EdgeInsets.all(2),
                                decoration: const BoxDecoration(
                                  color: Colors.redAccent,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.close, color: Colors.white, size: 16),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Consumer<PostProvider>(
            builder: (context, value, child) => ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 60),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                backgroundColor: context.watch<ThemeProvider>().isDark
                    ? Colors.white30
                    : primarycolor2,
                foregroundColor: primarycolor1,
              ),
              onPressed: () async {
                final post = PostModel(
                  title: titleController.text,
                  status: status.toString(),
                  projectId: projectId!.toInt(),
                  description: descriptionController.text,
                );

                final response = await value.createPost(post: post, images: value.postImages);
                if (!context.mounted) return;
                final result = jsonDecode(response!.body);
                final message = result['message'] ?? result['error'];
                print(result);
                if (response.statusCode == 200) {
                  Navigator.of(context).pop();
                  value.clearImages();
                }
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    behavior: SnackBarBehavior.floating,
                    content: Text(
                      message,
                      style: TextStyle(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.right,
                      textDirection: TextDirection.rtl,
                    ),
                  ),
                );
              },

              child: value.isLoading
                  ? CircularProgressIndicator(color: primarycolor1)
                  : Text("مشاركة", style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
        ),
      ),
    );
  }
}
