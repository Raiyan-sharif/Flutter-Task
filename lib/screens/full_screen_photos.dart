import 'package:flutter/material.dart';

class FullScreenPhotoScreen extends StatelessWidget {
  final String image;

  const FullScreenPhotoScreen({
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Photo'),
      ),
      body: Center(
        child: Image.asset(
          image,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}