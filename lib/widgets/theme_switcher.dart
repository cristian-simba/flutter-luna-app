import 'package:flutter/material.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:provider/provider.dart';
import 'package:luna/providers/icon_color_provider.dart';  

class ThemeSwitcher extends StatelessWidget {
  ThemeSwitcher({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final iconColor = Provider.of<IconColorProvider>(context).iconColor;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("Modo oscuro"),
        Switch(
          value: AdaptiveTheme.of(context).mode == AdaptiveThemeMode.dark,
          trackOutlineWidth: WidgetStatePropertyAll(0),     
          activeColor: iconColor,
          inactiveThumbColor: Colors.grey[300],
          inactiveTrackColor: Colors.white,
          onChanged: (bool value) {
            if (value) {
              AdaptiveTheme.of(context).setDark();
            } else {
              AdaptiveTheme.of(context).setLight();
            }
          },
        )
      ],
    );
  }
}