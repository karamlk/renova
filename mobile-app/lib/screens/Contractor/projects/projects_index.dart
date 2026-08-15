import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:renove_provider/extras/theme.dart';
import 'package:renove_provider/providers/Contractor/project_provider.dart';
import 'package:renove_provider/providers/theme_provider.dart';
import 'package:renove_provider/screens/Contractor/posts/create_post.dart';
import 'package:renove_provider/screens/Contractor/projects/project_details.dart';

class ProjectsIndex extends StatefulWidget {
  const ProjectsIndex({super.key});

  @override
  State<ProjectsIndex> createState() => _ProjectsIndexState();
}

class _ProjectsIndexState extends State<ProjectsIndex> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProjectProvider>().fetchProjects();
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async => await context.read<ProjectProvider>().fetchProjects(),
      color: primarycolor1,
      child: Scaffold(
        appBar: AppBar(
          title: Text('مشاريعي', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        body: Padding(
          padding: EdgeInsets.all(20),
          child: Consumer<ProjectProvider>(
            builder: (context, value, child) {
              if (value.isLoading) {
                return Center(child: CircularProgressIndicator(color: primarycolor1));
              }
              if (value.projects.isEmpty) {
                return CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),

                  slivers: [
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(
                        child: Text(
                          'لا يوجد أي مشاريع',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: primarycolor1,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }
              return ListView.builder(
                itemCount: value.projects.length,
                itemBuilder: (context, index) {
                  final project = value.projects[index];
                  return Padding(
                    padding: const EdgeInsets.all(5),
                    child: Card(
                      color: context.watch<ThemeProvider>().isDark
                          ? Colors.white10
                          : Colors.grey.shade300,
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          spacing: 10,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  project.engineer.name,
                                  textDirection: TextDirection.rtl,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: primarycolor1,
                                  ),
                                ),
                                Text(
                                  'مهندس المشروع:',
                                  textDirection: TextDirection.rtl,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  project.user.name,
                                  textDirection: TextDirection.rtl,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: primarycolor1,
                                  ),
                                ),
                                Text(
                                  'المتضرر',
                                  textDirection: TextDirection.rtl,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  project.status,
                                  textDirection: TextDirection.rtl,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: primarycolor1,
                                  ),
                                ),
                                Text(
                                  'الحالة',
                                  textDirection: TextDirection.rtl,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Row(
                              children: [
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    minimumSize: Size(120, 50),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    backgroundColor: context.watch<ThemeProvider>().isDark
                                        ? Colors.white30
                                        : primarycolor2,
                                    foregroundColor: primarycolor1,
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => CreateSharedPost(
                                          projectId: project.id,
                                          status: project.status,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    'مشاركة',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: primarycolor1,
                                    ),
                                  ),
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    minimumSize: Size(120, 50),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    backgroundColor: context.watch<ThemeProvider>().isDark
                                        ? Colors.white30
                                        : primarycolor2,
                                    foregroundColor: primarycolor1,
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => ProjectDetailsScreen(id: project.id),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    'التفاصيل',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: primarycolor1,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
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
