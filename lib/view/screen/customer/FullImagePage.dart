import 'package:flutter/material.dart';
import 'package:online_store/core/constant/App_link.dart';

class FullImagePage extends StatelessWidget {
  final String imageUrl;
  const FullImagePage({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    final fullUrl =
        "${ServerConfig().serverLink}$imageUrl"; // دمج السيرفر مع المسار النسبي
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
      body: Center(child: InteractiveViewer(child: Image.network(fullUrl))),
    );
  }
}
