import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set your desired background color
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
