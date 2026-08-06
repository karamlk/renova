import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:renove_provider/extras/link.dart';
import 'package:renove_provider/extras/theme.dart';
import 'package:renove_provider/providers/User/Profile/show_profile_provider.dart';
import 'package:renove_provider/providers/auth_provider.dart';
import 'package:renove_provider/providers/theme_provider.dart';
import 'package:renove_provider/screens/Auth/login_screen.dart';
import 'package:renove_provider/screens/User/Profile/show_profile_screen.dart';
import 'package:renove_provider/screens/User/construction%20forms/recieved_forms.dart';
import 'package:renove_provider/screens/settings/change_password.dart';
import 'package:renove_provider/screens/settings/verify_deletetion_screen.dart';
import 'package:renove_provider/skeletons/setiings_page_skeleton.dart';

class HomeMenuUser extends StatefulWidget {
  const HomeMenuUser({super.key});

  @override
  State<HomeMenuUser> createState() => _HomeMenuUserState();
}

class _HomeMenuUserState extends State<HomeMenuUser> {
  late final ExpansibleController expansibleController;
  @override
  void initState() {
    super.initState();
    expansibleController = ExpansibleController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ShowprofileProvider>().fetchProfile();
    });
  }

  @override
  void dispose() {
    expansibleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(top: 20, right: 20, left: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Consumer<ShowprofileProvider>(
                builder: (context, value, child) {
                  final profile = value.showProfileModel;

                  if (value.isLoading) {
                    return const SetiingsPageSkeleton();
                  }
                  if (profile == null) {
                    return Center(
                      child: Column(
                        children: [
                          Icon(Icons.wifi_off_outlined, size: 40),
                          Text('No internet connection'),
                        ],
                      ),
                    );
                  }
                  return ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      elevation: 0,

                      minimumSize: Size(double.infinity, 100),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      backgroundColor: primarycolor2,
                      foregroundColor: primarycolor1,
                    ),

                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(40),
                          child: CachedNetworkImage(
                            imageUrl: '$link${value.showProfileModel?.image ?? ""}',
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                            httpHeaders: {
                              'Authorization': 'Bearer ${value.token}',
                              'Accept': 'image/*',
                            },
                            placeholder: (context, url) => CircularProgressIndicator(),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.person, size: 60),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              profile.firstName,
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                            Text(
                              profile.email,
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                            Text(
                              profile.role,
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
              SizedBox(height: 20),
              Directionality(
                textDirection: TextDirection.rtl,
                child: GridView.count(
                  padding: EdgeInsets.all(10),
                  crossAxisCount: 2,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,

                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,

                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 10,
                        minimumSize: Size(30, 30),

                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        backgroundColor: primarycolor2,
                        foregroundColor: primarycolor1,
                      ),

                      onPressed: () {
                        Navigator.of(
                          context,
                        ).push(MaterialPageRoute(builder: (context) => RecievedForms()));
                      },
                      child: Column(
                        spacing: 20,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.white24,
                            radius: 35,
                            child: Icon(Icons.calendar_month, size: 35, color: primarycolor1),
                          ),
                          Text(
                            'الاستمارات',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Consumer<ThemeProvider>(
                builder: (context, value, child) {
                  return ElevatedButton(
                    onPressed: () => value.toggleTheme(),

                    style: ElevatedButton.styleFrom(
                      elevation: 0,

                      minimumSize: Size(double.infinity, 60),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      backgroundColor: primarycolor2,
                      foregroundColor: primarycolor1,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Transform.flip(
                          flipX: true,
                          child: Switch(
                            value: value.isDark,
                            onChanged: (_) => value.toggleTheme(),
                            focusColor: primarycolor1,
                            activeThumbColor: Colors.white,

                            thumbColor: WidgetStatePropertyAll<Color>(primarycolor1),
                          ),
                        ),
                        Row(
                          spacing: 20,
                          children: [
                            Text(
                              'الوضع الليلي',
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            Icon(Icons.dark_mode_outlined, size: 25),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),

              SizedBox(height: 10),
              Expansible(
                controller: expansibleController,
                headerBuilder: (context, animation) {
                  return ElevatedButton(
                    onPressed: () {
                      if (expansibleController.isExpanded) {
                        expansibleController.collapse();
                      } else {
                        expansibleController.expand();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      elevation: 0,

                      minimumSize: Size(double.infinity, 60),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      backgroundColor: primarycolor2,
                      foregroundColor: primarycolor1,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(Icons.arrow_drop_down_sharp, size: 35),
                        Row(
                          spacing: 20,
                          children: [
                            Text(
                              'إعدادات الحساب',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                            Icon(Icons.account_box_outlined, size: 25),
                          ],
                        ),
                      ],
                    ),
                  );
                },
                bodyBuilder: (context, animation) {
                  return Padding(
                    padding: EdgeInsets.all(8),
                    child: Column(
                      spacing: 10,
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            final scaffold = ScaffoldMessenger.of(context);
                            final navigate = Navigator.of(context);
                            final response = await context.read<AuthProvider>().logout();
                            if (response == null) {
                              print("No response");
                              return;
                            }
                            final result = jsonDecode(response.body);

                            if (response.statusCode == 200 || response.statusCode == 201) {
                              String success = result['message'];
                              navigate.pushAndRemoveUntil(
                                MaterialPageRoute(builder: (context) => LoginScreen()),
                                (Route<dynamic> route) => false,
                              );
                              scaffold.showSnackBar(
                                SnackBar(
                                  content: Text(
                                    success,
                                    textAlign: TextAlign.right,
                                    textDirection: TextDirection.rtl,
                                  ),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            } else {
                              String error = result['message'];
                              scaffold.showSnackBar(
                                SnackBar(
                                  content: Text(
                                    error,
                                    textAlign: TextAlign.right,
                                    textDirection: TextDirection.rtl,
                                  ),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            }
                          },

                          style: ElevatedButton.styleFrom(
                            elevation: 0,

                            minimumSize: Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            backgroundColor: primarycolor2,
                            foregroundColor: primarycolor1,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,

                            children: [
                              Consumer<AuthProvider>(
                                builder: (context, value, child) => value.isLoading
                                    ? CircularProgressIndicator(
                                        strokeWidth: 4,
                                        color: Color(0xFFF59B4A),
                                      )
                                    : SizedBox(width: 5),
                              ),
                              Spacer(),

                              Row(
                                spacing: 20,
                                children: [
                                  Text(
                                    'تسجيل الخروج',
                                    textAlign: TextAlign.right,
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  Icon(Icons.logout),
                                ],
                              ),
                            ],
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text(
                                  "حذف الحساب",
                                  textDirection: TextDirection.rtl,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                content: Text(
                                  'حذف حسابك سيؤدي إلى حذف كل معلوماتك؛ لن تتمكن من استرجاع الحساب',
                                  textDirection: TextDirection.rtl,
                                ),
                                actionsPadding: EdgeInsets.all(20),
                                actions: [
                                  SizedBox(height: 20),

                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },

                                    style: ElevatedButton.styleFrom(
                                      elevation: 0,

                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      minimumSize: Size(120, 50),
                                    ),
                                    child: Text(
                                      'إلغاء',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: primarycolor1,
                                      ),
                                    ),
                                  ),
                                  Consumer<AuthProvider>(
                                    builder: (context, value, child) => ElevatedButton(
                                      onPressed: () async {
                                        final scaffold = ScaffoldMessenger.of(context);
                                        final navigate = Navigator.of(context);
                                        final response = await context
                                            .read<AuthProvider>()
                                            .deleteRequest();
                                        if (response == null) {
                                          return;
                                        }
                                        final result = jsonDecode(response.body);
                                        if (response.statusCode == 200 ||
                                            response.statusCode == 201) {
                                          String success = result['message'];
                                          navigate.pop();
                                          scaffold.showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                success,
                                                textAlign: TextAlign.right,
                                                textDirection: TextDirection.rtl,
                                              ),
                                              behavior: SnackBarBehavior.floating,
                                            ),
                                          );
                                          navigate.push(
                                            MaterialPageRoute(
                                              builder: (context) => VerifyDeletetionScreen(),
                                            ),
                                          );
                                        } else {
                                          String error = result['message'];
                                          scaffold.showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                error,
                                                textAlign: TextAlign.right,
                                                textDirection: TextDirection.rtl,
                                              ),
                                              behavior: SnackBarBehavior.floating,
                                            ),
                                          );
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                        minimumSize: Size(120, 50),
                                        foregroundColor: Colors.white,
                                        backgroundColor: Colors.redAccent,
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                      ),
                                      child: value.isRequesting
                                          ? CircularProgressIndicator(
                                              strokeWidth: 3,
                                              color: Colors.white,
                                            )
                                          : Text(
                                              'حذف',
                                              style: TextStyle(fontWeight: FontWeight.bold),
                                            ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            elevation: 0,

                            minimumSize: Size(200, 50),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            backgroundColor: primarycolor2,
                            foregroundColor: primarycolor1,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Spacer(),
                              Row(
                                spacing: 20,
                                children: [
                                  Text(
                                    'حذف الحساب',
                                    textAlign: TextAlign.right,
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  Icon(Icons.delete),
                                ],
                              ),
                            ],
                          ),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            elevation: 0,

                            minimumSize: Size(200, 50),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            backgroundColor: primarycolor2,
                            foregroundColor: primarycolor1,
                          ),
                          onPressed: () {
                            Navigator.of(
                              context,
                            ).push(MaterialPageRoute(builder: (context) => ChangePassword()));
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,

                            children: [
                              Spacer(),
                              Row(
                                spacing: 20,
                                children: [
                                  Text('تغيير كلمة المرور', style: TextStyle(fontSize: 18)),

                                  Icon(Icons.password),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
