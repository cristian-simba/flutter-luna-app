import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:image_picker/image_picker.dart';

class DiaryEditorProvider extends ChangeNotifier {
  late QuillController _controller;
  final FocusNode _diaryFocusNode = FocusNode();
  bool _showFontOptions = false;
  bool _isBoldSelected = false;
  bool _isItalicSelected = false;
  bool _isFontSelected = false;
  bool _isUnderlineSelected = false;
  bool _isEmojiSelected = false;  
  bool _isColorSelected = false;
  bool _isImageSelected = false;
  XFile? _selectedImage;
  List<XFile> _selectedImages = [];
  List<XFile> get selectedImages => _selectedImages;
  String _selectedFontFamily = "Nunito"; 
  String _selectedColor = '#000000';

  DiaryEditorProvider({QuillController? controller})
      : _controller = controller ?? QuillController.basic() {
    _diaryFocusNode.addListener(_onFocusChange);
  }

  void setController(QuillController controller) {
    _controller = controller;
    notifyListeners();
  }

  QuillController get controller => _controller;
  FocusNode get diaryFocusNode => _diaryFocusNode;
  bool get showFontOptions => _showFontOptions;
  bool get isBoldSelected => _isBoldSelected;
  bool get isItalicSelected => _isItalicSelected;
  bool get isFontSelected => _isFontSelected;
  bool get isUnderline => _isUnderlineSelected;
  bool get isEmojiSelected => _isEmojiSelected;
  bool get isColorSelected => _isColorSelected;
  bool get isImageSelected => _isImageSelected; 
  String get selectedColor => _selectedColor;
  String get selectedFontFamily => _selectedFontFamily;
  XFile? get selectedImage => _selectedImage;

  void _onFocusChange() {
    if (_diaryFocusNode.hasFocus) {
      _showFontOptions = false;
      _isFontSelected = false;
      _isEmojiSelected = false;
      _isColorSelected = false;
      _isImageSelected = false;
      notifyListeners();
    }
  }

  void closeAllContainers() {
    _isFontSelected = false;
    _isColorSelected = false;
    _isEmojiSelected = false;
    _isImageSelected = false;
    notifyListeners();
  }

  void unfocusEditor() {
    _diaryFocusNode.unfocus();
  }
  
  void toggleBold() {
    _isBoldSelected = !_isBoldSelected;
    _controller.formatSelection(_isBoldSelected 
        ? Attribute.bold 
        : Attribute.clone(Attribute.bold, null));
    notifyListeners();
  }

  void toggleItalic() {
    _isItalicSelected = !_isItalicSelected;
    _controller.formatSelection(_isItalicSelected 
        ? Attribute.italic 
        : Attribute.clone(Attribute.italic, null));
    notifyListeners();
  }

  void toggleUnderline() {
    _isUnderlineSelected = !_isUnderlineSelected;
    _controller.formatSelection(_isUnderlineSelected 
        ? Attribute.underline 
        : Attribute.clone(Attribute.underline, null));
    notifyListeners();
  }

  void toggleFontOptions() {
    _showFontOptions = !_showFontOptions;
    _isFontSelected = _showFontOptions;
    unfocusEditor();
    if (_isFontSelected && _showFontOptions) {
      _isColorSelected = false;
      _isEmojiSelected = false;
      _isImageSelected = false;
    }
    notifyListeners();
  }

  void setSelectedFontFamily(String fontFamily) {
    _selectedFontFamily = fontFamily;
    notifyListeners();
  }

  void toggleEmojiPicker() {
    _isEmojiSelected = !_isEmojiSelected;
    notifyListeners();
    if (_isEmojiSelected) {
      _isFontSelected = false;
      _showFontOptions = false;
      _isColorSelected = false;
      _isImageSelected = false;
    }
    unfocusEditor();
  }

  void insertEmoji(String emoji) {
    final index = _controller.selection.baseOffset;
    final length = _controller.selection.extentOffset - index;
    _controller.replaceText(index, length, emoji, TextSelection.collapsed(offset: index + emoji.length));
    unfocusEditor();
  }
  
  void toggleColorOptions() {
    _isColorSelected = !_isColorSelected;
    
    if (_isColorSelected) {
      unfocusEditor();
      _isFontSelected = false;
      _showFontOptions = false;
      _isEmojiSelected = false;
      _isImageSelected = false;
    }

    notifyListeners();
  }

  void selectColor(Color color) {
    _selectedColor = _colorToHex(color);
    _controller.formatSelection(ColorAttribute(_selectedColor));
    notifyListeners();      
  }

  String _colorToHex(Color color) {
    return '#${color.value.toRadixString(16).padLeft(8, '0').toUpperCase()}';
  }

  void toggleImageSelection() {
    _isImageSelected = !_isImageSelected;
    if(_isImageSelected){
            unfocusEditor();
       _isFontSelected = false;
      _showFontOptions = false;
      _isEmojiSelected = false;
      _isColorSelected = false;     
    }
    notifyListeners();
  }

  void setSelectedImage(XFile? image) {
    _selectedImage = image;
    notifyListeners();
  }
  void addImage(XFile image) {
    _selectedImages.add(image);
    notifyListeners();
  }

  void removeImage(int index) {
    if (index >= 0 && index < _selectedImages.length) {
      _selectedImages.removeAt(index);
      notifyListeners();
    }
  }
  @override
  void dispose() {
    _diaryFocusNode.removeListener(_onFocusChange);
    _diaryFocusNode.dispose();
    _controller.dispose();
    super.dispose();
  }
}
