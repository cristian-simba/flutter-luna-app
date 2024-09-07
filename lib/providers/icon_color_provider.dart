import 'package:flutter/material.dart';
import 'package:luna/constants/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:luna/utils/mood_colors.dart';

class IconColorProvider with ChangeNotifier {
  Color _iconColor = IconColors.primaryIcon;

  IconColorProvider() {
    _loadIconColor();
  }

  Color get iconColor => _iconColor;

  void updateIconColor(Color color) {
    _iconColor = color;
    _saveIconColor(color);
    notifyListeners();
  }

  Color getMoodColor(String mood) {
    return MoodColorSelector.getMoodColor(mood, _iconColor);
  }

  void _loadIconColor() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? colorValue = prefs.getInt('icon_color');
    if (colorValue != null) {
      _iconColor = Color(colorValue);
      notifyListeners();
    }
  }

  void _saveIconColor(Color color) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('icon_color', color.value);
  }
}