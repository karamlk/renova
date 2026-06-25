import 'package:flutter/material.dart';
import 'package:renove_provider/extras/shimmer_loading_box.dart';

class ProfilePageSkeleton extends StatelessWidget {
  const ProfilePageSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: Column(
        spacing: 5,
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: ShimmerLoadingBox.rectangular(width: 70, height: 20),
          ),
          ShimmerLoadingBox.rectangular(width: double.infinity, height: 50),
          Align(
            alignment: Alignment.centerRight,
            child: ShimmerLoadingBox.rectangular(width: 70, height: 20),
          ),
          ShimmerLoadingBox.rectangular(width: double.infinity, height: 50),
          Align(
            alignment: Alignment.centerRight,
            child: ShimmerLoadingBox.rectangular(width: 100, height: 20),
          ),
          ShimmerLoadingBox.rectangular(width: double.infinity, height: 50),
          Align(
            alignment: Alignment.centerRight,
            child: ShimmerLoadingBox.rectangular(width: 70, height: 20),
          ),
          ShimmerLoadingBox.rectangular(width: double.infinity, height: 50),
          Align(
            alignment: Alignment.centerRight,
            child: ShimmerLoadingBox.rectangular(width: 70, height: 20),
          ),
          ShimmerLoadingBox.rectangular(width: double.infinity, height: 50),
        ],
      ),
    );
  }
}
