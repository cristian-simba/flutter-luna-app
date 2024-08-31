import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:luna/models/diary_entry.dart';
import 'package:luna/utils/date_formatter.dart';
import 'package:luna/screens/diary/components/view/image_preview.dart';

class DiaryCard extends StatelessWidget {
  final DiaryEntry entry;

  const DiaryCard({Key? key, required this.entry}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    try {
      final jsonMap = jsonDecode(entry.content);
      final document = Document.fromJson(jsonMap);
      final QuillController _controller = QuillController(
        document: document,
        readOnly: true,
        selection: const TextSelection.collapsed(offset: 0),
      );

      return Card(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                formatDate(entry.date),
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              SizedBox(
                child: QuillEditor.basic(
                  controller: _controller,
                  configurations: QuillEditorConfigurations(showCursor: false,
                    customStyles: DefaultStyles(
                      paragraph: DefaultTextBlockStyle(
                        TextStyle(
                          fontSize: 16,
                          height: 1.5,
                          wordSpacing: 1,
                          color: theme.brightness == Brightness.dark ? Colors.white : Colors.black
                        ),
                        HorizontalSpacing.zero,
                        VerticalSpacing.zero,
                        VerticalSpacing(20, 20),
                        null,
                      ),
                    )
                  ),
                ),
              ),
              const SizedBox(height: 5),
              ImagePreview(imagePaths: entry.imagePaths),
            ],
          ),
        ),
      );
    } catch (e) {
      return ListTile(
        title: Text('Error al cargar la entrada'),
        subtitle: Text('El contenido de esta entrada no es válido.'),
      );
    }
  }
}