import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';

import 'package:renove_provider/extras/link.dart';
import 'package:renove_provider/extras/theme.dart';
import 'package:renove_provider/models/Contractor/post/show_post_details.dart';
import 'package:renove_provider/providers/Contractor/post_provider.dart';
import 'package:renove_provider/providers/theme_provider.dart';
import 'package:renove_provider/screens/Contractor/posts/new_post.dart';

class HomeScreenContractor extends StatefulWidget {
  const HomeScreenContractor({super.key});

  @override
  State<HomeScreenContractor> createState() => _HomeScreenContractorState();
}

class _HomeScreenContractorState extends State<HomeScreenContractor> {
  bool isLikes = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PostProvider>().fetchAllPosts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async => await context.read<PostProvider>().fetchAllPosts(),
      color: primarycolor1,

      child: Scaffold(
        floatingActionButton: FloatingActionButton.extended(
          foregroundColor: primarycolor1,
          backgroundColor: primarycolor2,

          isExtended: true,

          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => NewPost()));
          },
          label: Text('منشور جديد', style: TextStyle(fontWeight: FontWeight.bold)),
          icon: Icon(Icons.add),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: Consumer<PostProvider>(
            builder: (context, value, child) {
              if (value.isLoading) {
                return Center(child: CircularProgressIndicator(color: primarycolor1));
              }
              return ListView.builder(
                padding: EdgeInsets.only(
                  left: 10,
                  top: 10,
                  right: 10,
                  bottom: kFloatingActionButtonMargin + 72, // Clears standard FAB height + margin
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
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    value.formatDate(post.createdAt ?? "لا يوجد تاريخ"),
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      minimumSize: Size(double.minPositive, 20),
                                      backgroundColor: context.watch<ThemeProvider>().isDark
                                          ? primarycolor2
                                          : primarycolor2,
                                      foregroundColor: context.watch<ThemeProvider>().isDark
                                          ? primarycolor1
                                          : primarycolor1,

                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                    ),
                                    onPressed: () {},
                                    child: Text(post.user!.contractorProfile!.firstName),
                                  ),
                                ],
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
                              Consumer<PostProvider>(
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
                                          Icons.arrow_upward_rounded,
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
