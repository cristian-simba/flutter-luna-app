import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:luna/providers/diary_editor_provider.dart';
import 'package:luna/constants/colors.dart';
import 'package:luna/constants/color_palettes.dart';

class ColorOptionsContainer extends StatelessWidget {
  const ColorOptionsContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DiaryEditorProvider>(context);
    final theme = Theme.of(context);

    return Visibility(
      visible: provider.isColorSelected,
      child: Container(
        height: 250,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: theme.brightness == Brightness.dark
              ? DiaryConstants.darkFontKeyboard
              : DiaryConstants.lightFontKeyboard,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 1,
            ),
          ],
        ),
        child: ListView(
          children: [
            _buildColorSection(context, 'Colores Neutros', ColorPalettes.neutralColors),
            _buildColorSection(context, 'Colores Cálidos', ColorPalettes.warmColors),
            _buildColorSection(context, 'Colores Fríos', ColorPalettes.coolColors),
            _buildColorSection(context, 'Colores Pastel', ColorPalettes.pastelColors),
            _buildColorSection(context, 'Colores Neón', ColorPalettes.neonColors),
          ],
        ),
      ),
    );
  }

  Widget _buildColorSection(BuildContext context, String title, List<Color> colors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title),
        SizedBox(height: 10),
        SizedBox(
          height: 50,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: colors.length,
            itemBuilder: (context, index) => _colorButton(context, colors[index]),
          ),
        ),
        SizedBox(height: 20),
      ],
    );
  }

  Widget _colorButton(BuildContext context, Color color) {
    final provider = Provider.of<DiaryEditorProvider>(context, listen: false);
    return GestureDetector(
      onTap: () {
        provider.selectColor(color);
        provider.toggleColorOptions();
      },
      child: Container(
        width: 40,
        height: 40,
        margin: const EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}