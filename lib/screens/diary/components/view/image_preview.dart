import 'dart:io';
import 'package:flutter/material.dart';
import 'package:luna/constants/colors.dart';

class ImagePreview extends StatelessWidget {
  final List<String> imagePaths;

  const ImagePreview({Key? key, required this.imagePaths}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (imagePaths.isEmpty) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      height: 175,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: imagePaths.length,
        itemBuilder: (context, index) {
          final file = File(imagePaths[index]);
          if (!file.existsSync()) {
            return const SizedBox.shrink();
          }
          return Padding(
            padding: const EdgeInsets.only(right: 5.0,),
            child: Container(
              width: 200,
              decoration: BoxDecoration(
                border: Border.all(
                  color: theme.brightness == Brightness.dark 
                      ? CardColors.darkImageBorder 
                      : CardColors.lightImageBorder, 
                ),
                borderRadius: BorderRadius.circular(15.0), 
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15.0),
                child: Image.file(
                  file,
                  width: 200,
                  height: 200,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 200,
                      height: 200,
                      color: Colors.grey[300],
                      child: const Icon(Icons.error, size: 60),
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
