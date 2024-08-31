import 'dart:convert';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';

Future<Uint8List?> pickImage() async {
  final picker = ImagePicker();
  final pickedFile = await picker.pickImage(source: ImageSource.gallery);

  if (pickedFile != null) {
    return await pickedFile.readAsBytes();
  }
  return null;
}

String imageToBase64(Uint8List imageBytes) {
  return base64Encode(imageBytes);
}

Uint8List base64ToImage(String base64String) {
  return base64Decode(base64String);
}

