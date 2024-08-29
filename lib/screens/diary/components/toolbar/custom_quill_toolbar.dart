import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:luna/providers/diary_editor_provider.dart';
import 'package:luna/constants/colors.dart';
import 'package:luna/providers/icon_color_provider.dart';

class CustomQuillToolbar extends StatelessWidget {
  const CustomQuillToolbar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DiaryEditorProvider>(context);
    final theme = Theme.of(context);
    final iconColor = Provider.of<IconColorProvider>(context).iconColor;

    return Container(
      height: DiaryConstants.toolbarHeight,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      decoration: BoxDecoration(
        color: theme.brightness == Brightness.dark
            ? NavbarBackground.darkNavBackground
            : NavbarBackground.lightNavBackground,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 1,
          ),
        ],
        borderRadius: const BorderRadius.all(Radius.circular(15)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildFormatButton(
            icon: Icons.format_bold,
            isSelected: provider.isBoldSelected,
            onPressed: provider.toggleBold,
            iconColor: iconColor,
          ),
          _buildFormatButton(
            icon: Icons.format_italic,
            isSelected: provider.isItalicSelected,
            onPressed: provider.toggleItalic,
            iconColor: iconColor,
          ),
          _buildFormatButton(
            icon: Icons.format_underline,
            isSelected: provider.isUnderline,
            onPressed: provider.toggleUnderline,
            iconColor: iconColor,
          ),
          _buildFormatButton(
            icon: Icons.text_fields,
            isSelected: provider.isFontSelected,
            onPressed: provider.toggleFontOptions,
            iconColor: iconColor,
          ),
          _buildFormatButton(
            icon: Icons.emoji_emotions_outlined,
            isSelected: provider.isEmojiSelected,
            onPressed: provider.toggleEmojiPicker,
            iconColor: iconColor,
          ),
          _buildFormatButton(
            icon: Icons.color_lens_outlined,
            isSelected: provider.isColorSelected,
            onPressed: provider.toggleColorOptions,
            iconColor: iconColor,
          ),
        ],
      ),
    );
  }

  Widget _buildFormatButton({
    required IconData icon,
    required bool isSelected,
    required VoidCallback onPressed,
    required Color iconColor,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isSelected ? iconColor.withOpacity(0.2) : Colors.transparent,
        borderRadius: BorderRadius.circular(30.0),
      ),
      child: IconButton(
        icon: Icon(
          icon,
          size: 23,
          color: isSelected ? iconColor : Colors.grey[400],
        ),
        onPressed: onPressed,
      ),
    );
  }
}