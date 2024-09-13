import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:luna/services/background_image_service.dart';

class BackgroundImagePicker extends StatelessWidget {
  final BackgroundImageService backgroundImageService;

  const BackgroundImagePicker({Key? key, required this.backgroundImageService}) : super(key: key);

  void _showBackgroundOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text('Elige una portada'),
              ),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 3,
                  children: [
                    _buildGalleryOption(context),
                    ..._buildPresetOptions(context),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildGalleryOption(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        _pickBackgroundImage();
      },
      child: const Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.photo_library, size: 40, color: Color(0xFFBDBDBD)),
            SizedBox(height: 8),
            Text(
              'Galería',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildPresetOptions(BuildContext context) {
    return backgroundImageService.presetImages.map((presetImage) {
      return GestureDetector(
        onTap: () {
          Navigator.pop(context);
          _saveBackgroundImage(presetImage);
        },
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          clipBehavior: Clip.hardEdge,
          child: Image.asset(
            presetImage,
            fit: BoxFit.cover,
          ),
        ),
      );
    }).toList();
  }

  Future<void> _pickBackgroundImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      await _saveBackgroundImage(pickedFile.path);
    }
  }

  Future<void> _saveBackgroundImage(String path) async {
    await backgroundImageService.saveBackgroundImage(path);
  }

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'editBackgroundFAB',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _showBackgroundOptions(context),
          customBorder: const CircleBorder(),
          child: Ink(
            decoration: BoxDecoration(
              color: Colors.grey[200],
              shape: BoxShape.circle,
            ),
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(
                Icons.edit,
                color: Colors.grey,
                size: 15.0,
              ),
            ),
          ),
        ),
      ),
    );
  }
}