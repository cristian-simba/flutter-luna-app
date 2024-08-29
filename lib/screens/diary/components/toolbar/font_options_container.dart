import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:luna/providers/diary_editor_provider.dart';
import 'package:luna/providers/icon_color_provider.dart';
import 'package:luna/constants/colors.dart';
import 'package:luna/utils/diary_utils.dart';

class FontOptionsContainer extends StatelessWidget {
  const FontOptionsContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DiaryEditorProvider>(context);
    final theme = Theme.of(context);

    return Visibility(
      visible: provider.showFontOptions,
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
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 7, top: 10),
                  child: Text(
                    'Fuentes',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Divider(height: 1, color: theme.brightness == Brightness.dark
                  ? SeparatorColors.darkSeparator
                  : SeparatorColors.ligthSeparator), 
                const SizedBox(height: 10),
                Expanded(
                  child: SingleChildScrollView(
                    child: GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      childAspectRatio: (constraints.maxWidth / 4) / 40, 
                      physics: NeverScrollableScrollPhysics(),
                      children: [
                        _fontButton(context, "Nunito"),
                        _fontButton(context, "Roboto"),
                        _fontButton(context, "Times New Roman"),
                        _fontButton(context, "Courier New"),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _fontButton(BuildContext context, String fontFamily) {
    final provider = Provider.of<DiaryEditorProvider>(context);
    bool isSelected = provider.selectedFontFamily == fontFamily;
    final iconColor = Provider.of<IconColorProvider>(context).iconColor;
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () {
        provider.unfocusEditor();
        DiaryUtils.applyFontFamily(provider.controller, fontFamily);
        provider.setSelectedFontFamily(fontFamily); 
      },
      child: Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.all(6),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isSelected ? iconColor.withOpacity(0.05) : theme.brightness == Brightness.dark
              ? DiaryConstants.darkFontKeyboard
              : DiaryConstants.lightFontKeyboard,
          border: Border.all(color: isSelected ? iconColor.withOpacity(0.6) : Color(0xFF9E9E9E).withOpacity(0.3)),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          fontFamily,
          style: TextStyle(fontFamily: fontFamily, fontSize: 14, fontWeight: FontWeight.w400),
        ),
      ),
    );
  }
}
