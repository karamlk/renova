import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:renove_provider/extras/link.dart';
import 'package:renove_provider/extras/theme.dart';
import 'package:renove_provider/models/Contractor/user_requests_model.dart';
import 'package:renove_provider/providers/theme_provider.dart';
import 'package:renove_provider/screens/Contractor/home_screens/UserRequestsDetails/photo_view_contractor.dart';

class UserRequestsDetails extends StatelessWidget {
  final ContractorRequestModel request;
  const UserRequestsDetails({super.key, required this.request});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("تفاصيل الطلب", style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: ListView(
        padding: EdgeInsets.all(10),
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text("العنوان", style: TextStyle(fontSize: 18)),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: context.watch<ThemeProvider>().isDark
                        ? primarycolor2
                        : Color(0xFFe4e6f2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    request.title,
                    textDirection: TextDirection.rtl,
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                SizedBox(height: 10),
                Text("الوصف", style: TextStyle(fontSize: 18)),
                Container(
                  width: double.infinity,
                  height: 100,
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: context.watch<ThemeProvider>().isDark
                        ? primarycolor2
                        : Color(0xFFe4e6f2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    request.description,
                    textDirection: TextDirection.rtl,
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                SizedBox(height: 10),
                Text("الموقع", style: TextStyle(fontSize: 18)),
                Container(
                  width: double.infinity,

                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: context.watch<ThemeProvider>().isDark
                        ? primarycolor2
                        : Color(0xFFe4e6f2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    request.location,
                    textDirection: TextDirection.rtl,
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                SizedBox(height: 10),
                Text("النوع", style: TextStyle(fontSize: 18)),
                Container(
                  width: double.infinity,

                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: context.watch<ThemeProvider>().isDark
                        ? primarycolor2
                        : Color(0xFFe4e6f2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    request.type,
                    textDirection: TextDirection.rtl,
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                SizedBox(height: 10),
                Text("المستخدم", style: TextStyle(fontSize: 18)),
                Container(
                  width: double.infinity,

                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: context.watch<ThemeProvider>().isDark
                        ? primarycolor2
                        : Color(0xFFe4e6f2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    request.user.name,
                    textDirection: TextDirection.rtl,
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                SizedBox(height: 10),
                Text("بريد المستخدم الإلكتروني", style: TextStyle(fontSize: 18)),
                Container(
                  width: double.infinity,

                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: context.watch<ThemeProvider>().isDark
                        ? primarycolor2
                        : Color(0xFFe4e6f2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    request.user.email,
                    textDirection: TextDirection.rtl,
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
          ),

          if (request.images.isNotEmpty)
            CarouselSlider.builder(
              itemCount: request.images.length,
              options: CarouselOptions(
                enableInfiniteScroll: false,

                height: 250,
                enlargeCenterPage: true,
                viewportFraction: 0.60,
                autoPlay: false,
              ),
              itemBuilder: (context, index, realIndex) {
                final image = request.images[index];
                return ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PhotoViewContractor(imageUrl: image.imageUrl),
                        ),
                      );
                    },
                    child: CachedNetworkImage(
                      imageUrl: image.imageUrl,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      placeholder: (context, url) =>
                          Center(child: CircularProgressIndicator(color: primarycolor1)),
                      errorWidget: (context, url, error) => Icon(Icons.broken_image, size: 50),
                    ),
                  ),
                );
              },
            ),
          SizedBox(height: 60),
        ],
      ),
    );
  }
}
