import 'package:flutter/material.dart';

class PermissionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Image Icon
              Image.asset(
                'assets/images/permission.png',
                width: 123,
                height: 149,
              ),
              SizedBox(height: 20), // Spacing
        
              // Bold Text Title
              Text(
                'Require Permission',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 10), // Spacing
        
              // Description
              Text(
                'To show your black and white photos\nwe just need your folder permission.\nWe promise, we don’t take your photos.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 30), // Spacing
        
              // Button
              SizedBox(
                width: double.infinity,  // Takes the full width of the screen
                child: ElevatedButton(
                  onPressed: () {
                    // Handle permission request here
                    _requestPermissions(context);
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    backgroundColor: Color(0xFF66FF6B),
                  ),
                  child: Text(
                    'Grant Access',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _requestPermissions(BuildContext context) {

  }
  }