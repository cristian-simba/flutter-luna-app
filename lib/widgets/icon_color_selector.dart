import 'package:flutter/material.dart';
import 'package:luna/constants/colors.dart';

class IconColorSelector extends StatelessWidget {
  final Function(Color) onColorSelected;

  const IconColorSelector({Key? key, required this.onColorSelected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildColorListTile(context, 'Principal', IconColors.primaryIcon),
        _buildColorListTile(context, 'Secundario', IconColors.secondaryIcon),
        _buildColorListTile(context, 'Terciario', IconColors.thirdIcon),
        _buildColorListTile(context, 'Cuarto', IconColors.fourthIcon),
        _buildColorListTile(context, 'Quinto', IconColors.fifthIcon),
      ],
    );
  }

  Widget _buildColorListTile(BuildContext context, String name, Color color) {
    return ListTile(
      leading: Icon(Icons.circle, color: color, size: 20),
      title: Text(name, style: TextStyle(fontSize: 14),),
      onTap: () => onColorSelected(color),
    );
  }
}