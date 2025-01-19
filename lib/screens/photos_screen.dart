import 'package:flutter/material.dart';

import 'full_screen_photos.dart';

class PhotosScreen extends StatelessWidget {
  // Sample photo data
  final List<String> photos = [
    'assets/images/all.jpeg',
    'assets/images/building.jpeg',
    'assets/images/game.jpeg',
    'assets/images/people.jpeg',
    'assets/images/recent.jpeg',
    'assets/images/all.jpeg',
    'assets/images/building.jpeg',
    'assets/images/game.jpeg',
    'assets/images/people.jpeg',
    'assets/images/recent.jpeg',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Navigate back
            Navigator.pop(context);
          },
        ),
        title: Text('Photos'),
      ),
      body: GridView.builder(
        padding: EdgeInsets.all(10),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4, // Number of photos in each row
          crossAxisSpacing: 5, // Spacing between columns
          mainAxisSpacing: 5, // Spacing between rows
        ),
        itemCount: photos.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              // Navigate to the full-screen photo viewer
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FullScreenPhotoScreen(image: photos[index]),
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