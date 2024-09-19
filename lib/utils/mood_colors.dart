import 'package:flutter/material.dart';
import 'package:luna/constants/colors.dart';
import 'package:luna/constants/analytics_colors.dart';

class MoodColorSelector {
  static Color getMoodColor(String mood, Color iconColor) {
    final Map<Color, String> paletteMap = {
      IconColors.primaryIcon: 'primary',
      IconColors.secondaryIcon: 'secondary',
      IconColors.thirdIcon: 'third',
      IconColors.fourthIcon: 'fourth',
      IconColors.fifthIcon: 'fifth',
    };

    String palette = paletteMap[iconColor] ?? 'default';

    return MoodColors.palettes[palette]?[mood] ?? 
           MoodColors.palettes[palette]!['default']!;
  }
}