import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';

final splashScreenProvider = Provider<SplashScreenController>((ref) {
  return SplashScreenController();
});

class SplashScreenController {
  Future<void> initializeApp() async {
    await Future.delayed(Duration(seconds: 3));
  }
}
