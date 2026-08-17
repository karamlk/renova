import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:renove_provider/extras/link.dart';
import 'package:renove_provider/extras/theme.dart';
import 'package:renove_provider/providers/User/posts_user_provider.dart';
import 'package:renove_provider/providers/theme_provider.dart';
import 'package:renove_provider/screens/User/home_screens/create_request_dialogue.dart';

class HomeScreenUser extends StatefulWidget {
  const HomeScreenUser({super.key});

  @override
  State<HomeScreenUser> createState() => _HomeScreenUserState();
}

class _HomeScreenUserState extends State<HomeScreenUser> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PostsUserProvider>().fetchAllPosts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async => await context.read<PostsUserProvider>().fetchAllPosts(),
      color: primarycolor1,
      child: Scaffold(
        floatingActionButton: FloatingActionButton.extended(
          foregroundColor: primarycolor1,
          backgroundColor: primarycolor2,
          label: Text('طلب جديد', style: TextStyle(fontWeight: FontWeight.bold)),
          icon: Icon(Icons.add),

          isExtended: true,

          onPressed: () {
            showDialog(
              context: context,
              fullscreenDialog: true,
              builder: (_) => CreateRequestDialogue(),
            );
          },
        ),
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: Consumer<PostsUserProvider>(
            builder: (context, value, child) {
              return ListView.builder(
                padding: EdgeInsets.only(
                  left: 10,
                  top: 10,
                  right: 10,
                  bottom: kFloatingActionButtonMargin + 72,
                ),
                itemCount: value.posts.length,
                itemBuilder: (context, index) {
                  final post = value.posts[index];
                  return Directionality(
                    textDirection: TextDirection.rtl,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Card(
                        color: context.watch<ThemeProvider>().isDark
                            ? Colors.white10
                            : Colors.grey.shade300,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12), // Adjust corner radius
                          side: BorderSide(
                            color: primarycolor1.withValues(alpha: 0.5), // Border color
                            width: 1, // Border thickness
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    post.title,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: primarycolor1,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Row(
                                    spacing: 2,
                                    children: [
                                      Transform.translate(
                                        offset: const Offset(0, 2.5),
                                        child: Text(
                                          post.status == "active" ? "Active" : "Completed",
                                        ),
                                      ),
                                      Icon(
                                        post.status == "active" ? Icons.circle : Icons.check_circle,
                                        color: post.status == "active"
                                            ? Colors.greenAccent
                                            : Colors.blueAccent,
                                        size: 20,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Text(
                                value.formatDate(post.createdAt ?? "لا يوجد تاريخ"),
                                style: TextStyle(color: Colors.grey),
                              ),
                              SizedBox(height: 10),
                              Text(post.description),
                              SizedBox(height: 10),
                              SizedBox(
                                height: 300,
                                width: 400,

                                child: CarouselSlider.builder(
                                  itemCount: post.images.length,

                                  itemBuilder: (context, index, realIndex) {
                                    final image = post.images[index];

                                    return ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: CachedNetworkImage(
                                        imageUrl: "$link/storage/${image.image}",
                                        width: double.infinity,
                                        height: double.infinity,
                                        fit: BoxFit.cover,

                                        placeholder: (context, url) {
                                          return const Center(child: CircularProgressIndicator());
                                        },

                                        errorWidget: (context, url, error) {
                                          return const Center(
                                            child: Icon(
                                              Icons.broken_image_outlined,
                                              size: 50,
                                              color: Colors.grey,
                                            ),
                                          );
                                        },
                                      ),
                                    );
                                  },

                                  options: CarouselOptions(
                                    height: 300,
                                    viewportFraction: 1.0,
                                    enlargeCenterPage: true,

                                    enableInfiniteScroll: false,

                                    // Swipe
                                    scrollDirection: Axis.horizontal,
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                              Consumer<PostsUserProvider>(
                                builder: (context, value, child) => ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: context.watch<ThemeProvider>().isDark
                                        ? primarycolor2
                                        : primarycolor2,
                                    foregroundColor: context.watch<ThemeProvider>().isDark
                                        ? primarycolor1
                                        : primarycolor1,

                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                  onPressed: () async {
                                    final response = await value.addLike(post.id);

                                    if (response!.statusCode == 200) {
                                      await value.fetchPostDetails(id: post.id);
                                      post.isLiked = value.detail!.isLiked;
                                      post.likesCount = value.detail!.likesCount;
                                    }
                                  },
                                  child: Row(
                                    spacing: 5,
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        post.likesCount.toString(),
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: post.isLiked ? primarycolor1 : Colors.grey,
                                        ),
                                      ),
                                      Transform.translate(
                                        offset: const Offset(0, -2.5),
                                        child: Icon(
                                          color: post.isLiked ? primarycolor1 : Colors.grey,
                                          Icons.favorite,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
