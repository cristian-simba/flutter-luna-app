import 'package:flutter/material.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:luna/constants/colors.dart';

class EmojiPickerWidget extends StatelessWidget {
  final Function(String) onEmojiSelected;

  const EmojiPickerWidget({required this.onEmojiSelected, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final ThemeData theme = Theme.of(context);

    return EmojiPicker(
      onEmojiSelected: (Category? category, Emoji emoji) {
        onEmojiSelected(emoji.emoji);
      },
      config: Config(
        height: 250, 
        checkPlatformCompatibility: true,
        bottomActionBarConfig: const BottomActionBarConfig(
          showBackspaceButton: false,
          showSearchViewButton: false,
        ),
        emojiViewConfig: EmojiViewConfig(
          columns: 6,
          backgroundColor: theme.brightness == Brightness.dark
              ? EmojiPickerColor.darkEmojiView 
              : EmojiPickerColor.lightEmojiView, 
          emojiSizeMax: 26,
        ),
        categoryViewConfig: CategoryViewConfig(
          backgroundColor: theme.brightness == Brightness.dark
              ? EmojiPickerColor.darkEmojiView 
              : EmojiPickerColor.lightEmojiView, 
        ),
      ),
    );
  }
}