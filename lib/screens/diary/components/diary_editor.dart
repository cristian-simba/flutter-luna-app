import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:provider/provider.dart';
import 'package:luna/providers/diary_editor_provider.dart';
import 'package:luna/screens/diary/components/toolbar/custom_quill_toolbar.dart';
import 'package:luna/screens/diary/components/toolbar/font_options_container.dart';
import 'package:luna/screens/diary/components/toolbar/color_options_container.dart'; 
import 'package:luna/screens/diary/components/toolbar/emoji_picker.dart';

class DiaryEditor extends StatefulWidget {
  const DiaryEditor({Key? key}) : super(key: key);

  @override
  _DiaryEditorState createState() => _DiaryEditorState();
}

class _DiaryEditorState extends State<DiaryEditor> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
      reverseCurve: Curves.easeIn,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ChangeNotifierProvider(
      create: (_) => DiaryEditorProvider(),
      child: Consumer<DiaryEditorProvider>(
        builder: (context, provider, child) {
          if (provider.isFontSelected || provider.isColorSelected || provider.isEmojiSelected) {
            _animationController.forward();
          } else {
            _animationController.reverse();
          }
          return Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
                  child: QuillEditor.basic(
                    focusNode: provider.diaryFocusNode,
                    controller: provider.controller,
                    configurations: QuillEditorConfigurations(placeholder: "Escribe tu dia", customStyles: DefaultStyles(
                      placeHolder: const DefaultTextBlockStyle(
                        TextStyle(
                          fontSize: 16, 
                          height: 1.5, 
                          color: Colors.grey
                        ), 
                        HorizontalSpacing.zero,
                        VerticalSpacing.zero,
                        VerticalSpacing(20, 20), 
                        null,
                      ),
                      paragraph: DefaultTextBlockStyle(
                        TextStyle(
                          fontSize: 16, 
                          height: 1.5, 
                          wordSpacing: 1.25, 
                          color: theme.brightness == Brightness.dark ? 
                          Colors.white : Colors.black
                        ), 
                        HorizontalSpacing.zero,
                        VerticalSpacing.zero,
                        VerticalSpacing(20, 20), 
                        null,
                      ),
                    ),
                  ),
                ),
              )
            ),
              const CustomQuillToolbar(),
              _buildAnimatedOptions(provider),
            ],
          );
        },
      ),
    );
  }

  Widget _buildAnimatedOptions(DiaryEditorProvider provider) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 100),
      height: provider.isFontSelected || provider.isColorSelected || provider.isEmojiSelected ? 250 : 0,
      child: SlideTransition(
        position: _slideAnimation,
        child: SingleChildScrollView(
          child: Column(
            children: [
              if (provider.isFontSelected) const FontOptionsContainer(),
              if (provider.isColorSelected) const ColorOptionsContainer(),
              if (provider.isEmojiSelected)
                EmojiPickerWidget(onEmojiSelected: provider.insertEmoji),
            ],
          ),
        ),
      ),
    );
  }
}
