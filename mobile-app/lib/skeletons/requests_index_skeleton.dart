import 'package:flutter/material.dart';
import 'package:renove_provider/extras/shimmer_loading_box.dart';

class RequestsIndexSkeleton extends StatelessWidget {
  const RequestsIndexSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          children: [
            Center(child: ShimmerLoadingBox.rectangular(width: double.infinity, height: 165)),
            SizedBox(height: 18),

            Center(child: ShimmerLoadingBox.rectangular(width: double.infinity, height: 165)),
            SizedBox(height: 18),
            Center(child: ShimmerLoadingBox.rectangular(width: double.infinity, height: 165)),
          ],
        ),
      ),
    );
  }
}
