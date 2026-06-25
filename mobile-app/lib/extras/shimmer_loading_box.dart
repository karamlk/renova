import 'package:flutter/material.dart';
import 'package:renove_provider/extras/theme.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerLoadingBox extends StatelessWidget {
  const ShimmerLoadingBox({
    super.key,
    required this.width,
    required this.height,
    required this.shapeBorder,
  });
  final double width;
  final double height;
  final ShapeBorder shapeBorder;

  const ShimmerLoadingBox.rectangular({
    super.key,
    required this.width,
    required this.height,
    this.shapeBorder = const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
    ),
  });
  const ShimmerLoadingBox.circular({
    super.key,
    required this.width,
    required this.height,
    this.shapeBorder = const CircleBorder(),
  });
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: primarycolor2,
      highlightColor: Colors.grey[900]!,
      period: const Duration(milliseconds: 1500),
      child: Container(
        width: width,
        height: height,
        decoration: ShapeDecoration(shape: shapeBorder, color: Colors.grey),
      ),
    );
  }
}
