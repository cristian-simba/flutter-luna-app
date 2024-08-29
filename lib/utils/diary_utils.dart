import 'package:flutter_quill/flutter_quill.dart';

class DiaryUtils {
  static void applyFontFamily(QuillController controller, String fontFamily) {
    controller.formatSelection(Attribute.fromKeyValue('font', fontFamily));
  }
}