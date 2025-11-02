import 'package:flutter/material.dart';

class FullImagePage extends StatelessWidget {
  final String imageUrl;
  const FullImagePage({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
      body: Center(
        child: InteractiveViewer(
          // عشان تقدر تكبر/تصغر الصورة
          child: Image.network(imageUrl),
        ),
      ),
    );
  }
}
