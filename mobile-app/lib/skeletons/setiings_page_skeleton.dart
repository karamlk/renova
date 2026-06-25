import 'package:flutter/material.dart';
import 'package:renove_provider/extras/shimmer_loading_box.dart';

class SetiingsPageSkeleton extends StatelessWidget {
  const SetiingsPageSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const Center(child: ShimmerLoadingBox.rectangular(width: double.infinity, height: 100)),
        ],
      ),
    );
  }
}
