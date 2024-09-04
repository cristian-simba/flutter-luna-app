import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:luna/constants/colors.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:luna/models/diary_entry.dart';
import 'package:luna/utils/date_formatter.dart';
import 'package:luna/screens/diary/components/view/image_preview.dart';
import 'package:luna/services/database.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:luna/providers/icon_color_provider.dart';
import 'package:luna/screens/diary/components/insert_diary.dart';

class DiaryCard extends StatelessWidget {
  final DiaryEntry entry;
  final VoidCallback onDelete;
  final VoidCallback onUpdate;

  const DiaryCard({
    Key? key,
    required this.entry,
    required this.onDelete,
    required this.onUpdate,
  }) : super(key: key);


  Future<void> _launchSongUrl(BuildContext context) async {
    final Uri url = Uri.parse(entry.songUrl!);
    await launchUrl(url);
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


  void _showOptions(BuildContext context) {
    final theme = Theme.of(context);

    showModalBottomSheet(
      context: context,
      // backgroundColor: theme.brightness == Brightness.dark ? CardColors.darkCard : CardColors.lightCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.zero),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.edit, size: 18),
                title: const Text('Editar', style: TextStyle(fontSize: 16),),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditDiaryScreen(
                        entry: entry,
                        onEntryUpdated: () {
                          onUpdate();
                        },
                      ),
                    ),
                  );
                }
              ),
              Divider(
                height: 1, 
                color: theme.brightness == Brightness.dark
                  ? SeparatorColors.darkSeparator
                  : SeparatorColors.lightSeparator
              ),
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red, size: 18,),
                title: const Text('Eliminar', style: TextStyle(color: Colors.red, fontSize: 16)),
                onTap: () {
                  Navigator.pop(context);
                  _deleteEntry(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final iconColor = Provider.of<IconColorProvider>(context).iconColor;

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
                    icon: const Icon(Icons.more_vert, size: 20),
                    onPressed: () => _showOptions(context),
                  ),
                ],
              ),

              if (entry.songUrl != null && entry.songUrl!.isNotEmpty) ...[
                Row(
                  children: [
                    Icon(Icons.play_circle, size: 18, color: iconColor),
                    const SizedBox(width: 5),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => _launchSongUrl(context),
                        child: Text(
                          entry.songName ?? 'Canción del día',
                          style: TextStyle(
                            fontSize: 14,
                            color: iconColor,
                            fontWeight: FontWeight.w700,
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