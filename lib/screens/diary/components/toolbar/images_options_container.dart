import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:luna/providers/diary_editor_provider.dart';
import 'package:luna/providers/icon_color_provider.dart';
import 'package:luna/constants/colors.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ImageOptionsContainer extends StatelessWidget {
  const ImageOptionsContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DiaryEditorProvider>(context);
    final iconColor = Provider.of<IconColorProvider>(context).iconColor;
    final theme = Theme.of(context);

    return Visibility(
      visible: provider.isImageSelected,
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 7, top: 10),
              child: Text(
                'Imágenes',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Divider(
              height: 1,
              color: theme.brightness == Brightness.dark
                  ? SeparatorColors.darkSeparator
                  : SeparatorColors.ligthSeparator
            ),
            const SizedBox(height: 10),
            Expanded(
              child: provider.selectedImages.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('No hay imágenes seleccionadas'),
                          const SizedBox(height: 10),
                          TextButton(
                            onPressed: () => _pickImage(context),
                            style: TextButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0), 
                              ),
                              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 24.0), 
                              backgroundColor: iconColor, 
                            ),
                            child: const Text(
                              '+ Agregar imagen',
                              style: TextStyle(
                                color: Colors.white, 
                                fontWeight: FontWeight.bold
                              ),
                            ),
                          )
                        ]
                      )
                    )
                  : GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemCount: provider.selectedImages.length + 1, 
                      itemBuilder: (context, index) {
                        if (index == provider.selectedImages.length) {
                          return Center(
                            child: TextButton(
                              onPressed: () => _pickImage(context),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.add_photo_alternate, size: 40, color: Colors.grey[400],),
                                  Text('Agregar imagen', style: TextStyle(color: Colors.grey[400]),),
                                ],
                              ),
                            ),
                          );
                        }
                        // For other indices, show the image
                        return Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.file(
                              File(provider.selectedImages[index].path),
                              fit: BoxFit.cover,
                            ),
                            Positioned(
                              right: 0,
                              top: 0,
                              child: IconButton(
                                icon: Icon(Icons.close, color: Colors.white),
                                onPressed: () => provider.removeImage(index),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage(BuildContext context) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      Provider.of<DiaryEditorProvider>(context, listen: false).addImage(pickedFile);
    }
  }
}