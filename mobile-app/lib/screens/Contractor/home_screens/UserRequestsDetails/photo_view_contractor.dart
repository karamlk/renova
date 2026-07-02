import 'package:flutter/material.dart';

class PhotoViewContractor extends StatelessWidget {
  const PhotoViewContractor({super.key, required this.imageUrl});
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(backgroundColor: Colors.black),
      body: Center(
        child: InteractiveViewer(child: Image.network(imageUrl, fit: BoxFit.contain)),
      ),
    );
  }
}
