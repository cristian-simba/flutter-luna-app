import 'package:flutter/material.dart';
import 'package:luna/constants/colors.dart';
import 'package:luna/constants/analytics_colors.dart';

class MoodColorSelector {
  static Color getMoodColor(String mood, Color iconColor) {
    String palette;
    if (iconColor == IconColors.primaryIcon) {
      palette = 'primary';
    } else if (iconColor == IconColors.secondaryIcon) {
      palette = 'secondary';
    } else if (iconColor == IconColors.thirdIcon) {
      palette = 'third';
    } else {
      palette = 'default';
    }

    return MoodColors.palettes[palette]?[mood] ?? MoodColors.palettes[palette]!['default']!;
  }
}