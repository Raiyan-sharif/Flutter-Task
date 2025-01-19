import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gallery_app/screens/permission_screen.dart';
import '../provider/splash_screen_provider.dart';

class SplashScreen extends ConsumerStatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      // Initialize the app, simulate loading or setup tasks
      await ref.read(splashScreenProvider).initializeApp();

      // After initialization, navigate to the PhotosScreen
      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => PermissionScreen()),
              (_) => false, // This removes all previous routes
        );
      }

    } catch (e) {
      // Handle any initialization errors
      print("Error during initialization: $e");

      // Navigate to PermissionScreen in case of error
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => PermissionScreen()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set the background color
      body: Center(
        child: Image.asset(
          'assets/images/splash.png', // Path to your logo image
          width: 150, // Adjust the width as needed
          height: 150, // Adjust the height as needed
        ),
      ),
    );
  }
}
