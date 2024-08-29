import 'package:flutter/material.dart';
import 'package:luna/widgets/theme_switcher.dart';
import 'package:provider/provider.dart';
import 'package:luna/providers/icon_color_provider.dart';
import 'package:luna/widgets/icon_color_selector.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          const ThemeSwitcher(),
        ],
      ),
      body: Center(
        child: Consumer<IconColorProvider>(
          builder: (context, iconColorProvider, child) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Color de iconos actual:'),
                Icon(Icons.circle, color: iconColorProvider.iconColor, size: 50),
                const SizedBox(height: 20),
                const Text('Selecciona un nuevo color:'),
                IconColorSelector(
                  onColorSelected: (Color color) {
                    iconColorProvider.updateIconColor(color);
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
