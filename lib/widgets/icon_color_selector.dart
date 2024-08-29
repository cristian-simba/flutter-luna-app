import 'package:flutter/material.dart';
import 'package:luna/constants/colors.dart';

class IconColorSelector extends StatefulWidget {
  final Function(Color) onColorSelected;

  const IconColorSelector({Key? key, required this.onColorSelected}) : super(key: key);

  @override
  _IconColorSelectorState createState() => _IconColorSelectorState();
}

class _IconColorSelectorState extends State<IconColorSelector> {
  Color _selectedColor = IconColors.primaryIcon; 

  void _selectColor(Color color) {
    setState(() {
      _selectedColor = color;
    });
    widget.onColorSelected(color);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.circle, color: IconColors.primaryIcon),
          onPressed: () => _selectColor(IconColors.primaryIcon),
        ),
        IconButton(
          icon: const Icon(Icons.circle, color: IconColors.secondaryIcon),
          onPressed: () => _selectColor(IconColors.secondaryIcon),
        ),
        IconButton(
          icon: const Icon(Icons.circle, color: IconColors.thirdIcon),
          onPressed: () => _selectColor(IconColors.thirdIcon),
        ),
      ],
    );
  }
}
