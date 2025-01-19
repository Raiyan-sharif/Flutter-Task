import 'package:flutter/material.dart';

class AlbumScreen extends StatelessWidget {
  // Sample album data
  final List<Map<String, dynamic>> albums = [
    {
      'name': 'All',
      'image': 'assets/images/all.jpeg',
      'photoCount': 27,
    },
    {
      'name': 'Recent',
      'image': 'assets/images/recent.jpeg',
      'photoCount': 12,
    },
    {
      'name': 'Game',
      'image': 'assets/images/game.jpeg',
      'photoCount': 122,
    },
    // Add more albums here
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Albums'),
      ),
      body: GridView.builder(
        padding: EdgeInsets.all(10),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Number of columns
          crossAxisSpacing: 10, // Spacing between columns
          mainAxisSpacing: 10, // Spacing between rows
          childAspectRatio: 0.8, // Aspect ratio of grid items
        ),
        itemCount: albums.length,
        itemBuilder: (context, index) {
          final album = albums[index];
          return AlbumGridItem(
            image: album['image'],
            name: album['name'],
            photoCount: album['photoCount'],
          );
        },
      ),
    );
  }
}

class AlbumGridItem extends StatelessWidget {
  final String image;
  final String name;
  final int photoCount;

  const AlbumGridItem({
    required this.image,
    required this.name,
    required this.photoCount,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Image
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.asset(
            image,
            fit: BoxFit.cover,
          ),
        ),

        // Gradient Overlay
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                Colors.black.withOpacity(0.7),
                Colors.transparent,
              ],
            ),
          ),
        ),

        // Album Name and Photo Count
        Positioned(
          left: 10,
          bottom: 10,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '$photoCount photos',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}