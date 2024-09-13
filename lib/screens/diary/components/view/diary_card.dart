import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:luna/models/diary_entry.dart';
import 'package:luna/services/database.dart';
import 'package:luna/constants/colors.dart';
import 'package:provider/provider.dart';
import 'package:luna/providers/icon_color_provider.dart';
import 'package:luna/utils/mood_utils.dart';
import 'package:luna/utils/date_formatter.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:luna/screens/diary/components/view/audio_player.dart';
import 'package:luna/screens/diary/components/view/show_options.dart';
import 'package:luna/screens/diary/components/view/image_preview.dart';

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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final iconColor = Provider.of<IconColorProvider>(context).iconColor;
    final cardColor = theme.brightness == Brightness.dark ? CardColors.darkCard : CardColors.lightCard;

    try {
      final jsonMap = jsonDecode(entry.content);
      final document = Document.fromJson(jsonMap);
      final QuillController _controller = QuillController(
        document: document,
        readOnly: true,
        selection: const TextSelection.collapsed(offset: 0),
      );

      return Card(
        elevation: 0.25,
        margin: const EdgeInsets.only(top: 10, bottom: 3, left: 15, right: 15),
        color: cardColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              dayAndMood(iconColor, context),
              if (entry.songUrl != null && entry.songUrl!.isNotEmpty)
                YouTubeAudioPlayer(
                  youtubeUrl: entry.songUrl!,
                  songName: entry.songName ?? 'Canción del día',
                ),
              if (entry.songUrl != null && entry.songUrl!.isNotEmpty) ...[
                audioPlayer(iconColor, context),
              ],              
              textEditor(_controller, theme),
              const SizedBox(height: 10),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: ImagePreview(imagePaths: entry.imagePaths),
              )
            ],
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

  Widget audioPlayer(Color iconColor, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0, left: 18, right: 3, bottom: 10),
      child: Row(
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
    );
  }

  Row dayAndMood(Color iconColor, BuildContext context) {
    final theme = Theme.of(context);
    final bannerColor = theme.brightness == Brightness.dark ? iconColor.withOpacity(0.8) : iconColor.withOpacity(1);

    return Row(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: bannerColor,
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)), 
            ),
            padding: const EdgeInsets.only(top: 5.0, bottom: 2, left: 20, right: 5), 
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      formatDate(entry.date),
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white), 
                    ),
                    const SizedBox(width: 8),
                    SvgPicture.asset(
                      getMoodSvg(entry.mood),
                      width: 20,
                      height: 20,
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.more_vert, size: 20, color: Colors.white), 
                  onPressed: () => _showOptions(context),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _launchSongUrl(BuildContext context) async {
    final Uri url = Uri.parse(entry.songUrl!);
    await launchUrl(url);
  }

  SizedBox textEditor(QuillController _controller, ThemeData theme) {
    return SizedBox(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 3, left: 20, right: 3), 
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
      )
    );
  }

  Future<void> _deleteEntry(BuildContext context) async {
    final confirmed = await showDeleteConfirmationDialog(context);
    if (confirmed) {
      await DiaryDatabaseHelper.instance.deleteEntry(entry.id!);
      onDelete();
    }
  }

  void _showOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
      ),
      builder: (BuildContext context) {
        return DiaryCardOptions(
          entry: entry,
          onDelete: () => _deleteEntry(context),
          onUpdate: onUpdate,
        );
      },
    );
  }

}
