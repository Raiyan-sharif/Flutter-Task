import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'full_screen_photos.dart';

class PhotosScreen extends StatefulWidget {
  final Map<String, dynamic> album;

  PhotosScreen({required this.album});

  @override
  State<PhotosScreen> createState() => _PhotosScreenState();
}

class _PhotosScreenState extends State<PhotosScreen> {
  static const platform = MethodChannel('com.example.galleryApp/photos');

  List<String> photos = [];

  @override
  void initState() {
    super.initState();
    _fetchPhotos();
  }

  Future<void> _fetchPhotos() async {
    try {
      final List<dynamic> result = await platform.invokeMethod(
        'getPhotos',
        {'albumId': widget.album['id']},
      );
      setState(() {
        photos = result.cast<String>();
      });
    } on PlatformException catch (e) {
      print("Failed to fetch photos: '${e.message}'.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.album['name']),
      ),
      body: photos.isEmpty
          ? Center(child: CircularProgressIndicator())
          : GridView.builder(
        padding: EdgeInsets.all(10),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 5,
          mainAxisSpacing: 5,
        ),
        itemCount: photos.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              // Navigate to FullScreenPhotoScreen
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FullScreenPhotoScreen(
                    image: photos[index],
                  ),
                ),
              );
            },
            child: PhotoGridItem(
              image: photos[index],
            ),
          );
        },
      ),
    );
  }
}

class PhotoGridItem extends StatelessWidget {
  final String image;

  const PhotoGridItem({
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: Image.asset(
        image,
        fit: BoxFit.cover,
      ),
    );
  }
}