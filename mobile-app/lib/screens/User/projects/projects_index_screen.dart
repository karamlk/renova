import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:renove_provider/extras/theme.dart';
import 'package:renove_provider/models/User/projects/projects_index.dart';
import 'package:renove_provider/providers/Contractor/project_provider.dart';
import 'package:renove_provider/providers/User/project_provider_user.dart';
import 'package:renove_provider/providers/theme_provider.dart';
import 'package:renove_provider/screens/Contractor/projects/project_details.dart';
import 'package:renove_provider/screens/User/projects/project_details_screen.dart';

class ProjectsIndexScreen extends StatefulWidget {
  const ProjectsIndexScreen({super.key});

  @override
  State<ProjectsIndexScreen> createState() => _ProjectsIndexScreenState();
}

class _ProjectsIndexScreenState extends State<ProjectsIndexScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProjectProviderUser>().fetchProjects();
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async => await context.read<ProjectProviderUser>().fetchProjects(),
      color: primarycolor1,
      child: Scaffold(
        appBar: AppBar(
          title: Text('مشاريعي', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        body: Padding(
          padding: EdgeInsets.all(20),
          child: Consumer<ProjectProviderUser>(
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
                    padding: EdgeInsets.all(5),
                    child: Card(
                      color: context.watch<ThemeProvider>().isDark
                          ? Colors.white10
                          : Colors.grey.shade300,
                      child: Padding(
                        padding: const EdgeInsets.all(20),
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
                                  project.contractor.name,
                                  textDirection: TextDirection.rtl,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: primarycolor1,
                                  ),
                                ),
                                Text(
                                  'المتعهد',
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
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                minimumSize: Size(double.infinity, 50),
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
                                    builder: (context) =>
                                        ProjectDetailsUserScreen(projectId: project.id),
                                  ),
                                );
                              },
                              child: Text(
                                'التفاصيل',
                                style: TextStyle(fontWeight: FontWeight.bold, color: primarycolor1),
                              ),
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
