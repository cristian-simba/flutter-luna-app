import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

class BackgroundImageService {
  static const String _backgroundImagePathKey = 'background_image_path';
  static const List<String> _presetImages = [
    'assets/images/preset_background_1.jpg',
    'assets/images/preset_background_2.jpg',
  ];

  final ValueNotifier<String?> backgroundImagePathNotifier = ValueNotifier<String?>(null);

  Future<void> loadBackgroundImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String path = prefs.getString(_backgroundImagePathKey) ?? _presetImages[0];
    backgroundImagePathNotifier.value = path;
  }

  Future<void> saveBackgroundImage(String path) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_backgroundImagePathKey, path);
    backgroundImagePathNotifier.value = path;
  }

  Widget buildBackgroundImage() {
    return ValueListenableBuilder<String?>(
      valueListenable: backgroundImagePathNotifier,
      builder: (context, imagePath, child) {
        if (imagePath != null) {
          if (imagePath.startsWith('assets')) {
            return Image.asset(imagePath, fit: BoxFit.cover);
          } else {
            return Image.file(File(imagePath), fit: BoxFit.cover);
          }
        } else {
          return Image.asset(_presetImages[0], fit: BoxFit.cover);
        }
      },
    );
  }

  List<String> get presetImages => _presetImages;
}