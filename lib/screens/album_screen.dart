import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'photos_screen.dart';

class AlbumScreen extends StatefulWidget {
  @override
  State<AlbumScreen> createState() => _AlbumScreenState();
}

class _AlbumScreenState extends State<AlbumScreen> {
  static const platform = MethodChannel('com.example.galleryApp/albums');

  List<Map<String, dynamic>> albums = [];

  @override
  void initState() {
    super.initState();
    _fetchAlbums();
  }

  Future<void> _fetchAlbums() async {
    try {
      final result = await platform.invokeMethod<List<dynamic>>('getAlbums');
      if (result != null) {
        setState(() {
          albums = result.map((e) => Map<String, dynamic>.from(e)).toList();
        });
      }
    } on PlatformException catch (e) {
      print("Failed to fetch albums: '${e.message}'.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Albums'),
      ),
      body: albums.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : GridView.builder(
        padding: const EdgeInsets.all(10),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 0.8,
        ),
        itemCount: albums.length,
        itemBuilder: (context, index) {
          final album = albums[index];
          final image = album['thumbnail']?.toString() ?? ''; // Ensure a string path
          final name = album['name']?.toString() ?? 'Unknown Album';
          final photoCount = album['photoCount'] ?? 0;
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PhotosScreen(album: album),
                ),
              );
            },
            child: AlbumGridItem(
              image: image,
              name: name,
              photoCount: photoCount,
            ),
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
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: isValidUri(image)
              ? FutureBuilder<File>(
            future: _getFileFromUri(image),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData && snapshot.data != null) {
                  return Image.file(snapshot.data!, fit: BoxFit.cover);
                } else {
                  return Icon(Icons.broken_image);
                }
              } else {
                return CircularProgressIndicator();
              }
            },
          )
              : Image.file(File(image), fit: BoxFit.cover),
        ),
        // Gradient overlay
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

  // Check if the string is a URI or a local file path
  bool isValidUri(String path) {
    return path.startsWith('content://');
  }

  // Convert a URI to a file (using the platform channel if needed)
  Future<File> _getFileFromUri(String uri) async {
    final platform = MethodChannel('com.example.galleryApp/albums');
    final filePath = await platform.invokeMethod<String>('getFilePath', {"uri": uri});
    return File(filePath ?? '');
  }
}
