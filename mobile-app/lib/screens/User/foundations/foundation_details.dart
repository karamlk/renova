import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:renove_provider/Extras/theme.dart';
import 'package:renove_provider/extras/link.dart';
import 'package:renove_provider/providers/User/foundation_provider.dart';
import 'package:renove_provider/providers/theme_provider.dart';

class FoundationDetails extends StatefulWidget {
  final int id;
  const FoundationDetails({super.key, required this.id});

  @override
  State<FoundationDetails> createState() => _FoundationDetailsState();
}

class _FoundationDetailsState extends State<FoundationDetails> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FoundationProvider>().fetchCampaignDetails(widget.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("تفاصيل الحملة", style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Consumer<FoundationProvider>(
        builder: (context, value, child) {
          if (value.isLoadingDetails) {
            return Center(child: CircularProgressIndicator(color: primarycolor1));
          }
          final campaign = value.selectedCampaignDetails;
          return SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "عنوان الحملة",
                      style: TextStyle(fontSize: 18),
                      textAlign: TextAlign.right,
                    ),
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
                        campaign!.title,
                        textDirection: TextDirection.rtl,

                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    SizedBox(height: 10),
                    Text("الوصف", style: TextStyle(fontSize: 18), textAlign: TextAlign.right),
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
                        campaign.description,
                        textDirection: TextDirection.rtl,

                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    SizedBox(height: 10),
                    Text("الموقع", style: TextStyle(fontSize: 18), textAlign: TextAlign.right),
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
                        campaign.location,
                        textDirection: TextDirection.rtl,

                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    SizedBox(height: 10),
                    Text("المقدار", style: TextStyle(fontSize: 18), textAlign: TextAlign.right),
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
                        campaign!.targetAmount,
                        textDirection: TextDirection.rtl,

                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "تم تجميع مقدار",
                      style: TextStyle(fontSize: 18),
                      textAlign: TextAlign.right,
                    ),
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
                        campaign!.collectedAmount,
                        textDirection: TextDirection.rtl,

                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    SizedBox(height: 10),
                    Text("بدء الحملة", style: TextStyle(fontSize: 18), textAlign: TextAlign.right),
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
                        campaign!.startsAt,
                        textDirection: TextDirection.rtl,

                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "انتهاء الحملة",
                      style: TextStyle(fontSize: 18),
                      textAlign: TextAlign.right,
                    ),
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
                        campaign!.endsAt,
                        textDirection: TextDirection.rtl,

                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    SizedBox(height: 10),
                    Text("الحالة", style: TextStyle(fontSize: 18), textAlign: TextAlign.right),
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
                        campaign!.status,
                        textDirection: TextDirection.rtl,

                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    SizedBox(height: 20),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: campaign.images.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 1.0,
                      ),
                      itemBuilder: (context, index) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: CachedNetworkImage(
                            fit: BoxFit.cover,
                            imageUrl: '$link${campaign.images[index].imageUrl}',
                            placeholder: (context, url) => Container(
                              color: Colors.grey[100],
                              child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                            ),

                            // Shows if the URL is invalid or image fails to load
                            errorWidget: (context, url, error) => Container(
                              color: Colors.grey[300],
                              child: const Icon(Icons.broken_image, color: Colors.grey, size: 32),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
