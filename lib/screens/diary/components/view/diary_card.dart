import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:luna/constants/colors.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:luna/models/diary_entry.dart';
import 'package:luna/utils/date_formatter.dart';
import 'package:luna/screens/diary/components/view/image_preview.dart';
import 'package:luna/services/database.dart';
import 'package:url_launcher/url_launcher.dart';

class DiaryCard extends StatelessWidget {
  final DiaryEntry entry;
  final VoidCallback onDelete;

  const DiaryCard({
    Key? key,
    required this.entry,
    required this.onDelete,
  }) : super(key: key);

  Future<void> _launchSongUrl(BuildContext context) async {
    if (entry.songUrl != null && entry.songUrl!.isNotEmpty) {
      final Uri url = Uri.parse(entry.songUrl!);
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No se pudo abrir el enlace.')),
        );
      }
    }
  }

  Future<void> _deleteEntry(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar eliminación'),
          content: const Text('¿Estás seguro de que quieres eliminar este diario?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            TextButton(
              child: const Text('Eliminar'),
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        );
      },
    );

  if (confirmed == true) {
      await DiaryDatabaseHelper.instance.deleteEntry(entry.id!);
      onDelete();
    }
  }

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
        margin: const EdgeInsets.symmetric(vertical:7, horizontal: 16),
        color: theme.brightness == Brightness.dark ? CardColors.darkCard : CardColors.lightCard,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5)), 
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    formatDate(entry.date),
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                    onPressed: () => _deleteEntry(context),
                  ),
                ],
              ),

              if (entry.songUrl != null && entry.songUrl!.isNotEmpty) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.music_note, size: 16, color: theme.primaryColor),
                    const SizedBox(width: 8),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => _launchSongUrl(context),
                        child: Text(
                          entry.songName ?? 'Canción del día',
                          style: TextStyle(
                            fontSize: 14,
                            color: theme.primaryColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],

              const SizedBox(height: 8),
              SizedBox(
                child: QuillEditor.basic(
                  controller: _controller,
                  configurations: QuillEditorConfigurations(
                    showCursor: false,
                    customStyles: DefaultStyles(
                      paragraph: DefaultTextBlockStyle(
                        TextStyle(
                          fontSize: 14,
                          height: 1.25,
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
              const SizedBox(height: 15),
              ImagePreview(imagePaths: entry.imagePaths),
            ],
          ),
        ),
      );
    } catch (e) {
      return ListTile(
        title: const Text('Error al cargar la entrada'),
        subtitle: const Text('El contenido de esta entrada no es válido.'),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: () => _deleteEntry(context),
        ),
      );
    }
  }
}