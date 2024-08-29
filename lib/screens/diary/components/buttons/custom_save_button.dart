import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:luna/providers/icon_color_provider.dart';  

class CustomSaveButton extends StatelessWidget {
  final VoidCallback onPressed;

  const CustomSaveButton({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final iconColor = Provider.of<IconColorProvider>(context).iconColor;
 
    return FilledButton.icon(
      onPressed: onPressed,
      icon: const Icon(Icons.collections_bookmark, size: 18.0,),
      label: const Text('Guardar', style: TextStyle(color: Colors.white)),
      style: FilledButton.styleFrom(
        backgroundColor: iconColor,
        iconColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ), 
      ),
    );
  }
}