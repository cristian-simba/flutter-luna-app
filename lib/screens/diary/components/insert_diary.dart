import 'package:flutter/material.dart';
import 'package:luna/screens/diary/components/buttons/custom_save_button.dart';
import 'package:luna/screens/diary/components/diary_editor.dart';
import 'package:luna/screens/diary/components/buttons/date_button.dart';
import 'package:luna/screens/diary/components/buttons/song_of_the_day.dart';
import 'package:luna/models/diary_entry.dart';
import 'package:luna/services/database.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'dart:convert';

class InsertDiary extends StatefulWidget {
  final VoidCallback onEntryAdded;

  const InsertDiary({Key? key, required this.onEntryAdded}) : super(key: key);

  @override
  _InsertDiaryState createState() => _InsertDiaryState();
}

class _InsertDiaryState extends State<InsertDiary> {
  DateTime _selectedDate = DateTime.now();
  String _songName = "";
  String _songUrl = "";
  List<String> _imagePaths = [];
  
  final QuillController _controller = QuillController.basic();

  void _updateSelectedDate(DateTime date) {
    setState(() => _selectedDate = date);
  }

  void _updateSongInfo(String name, String url) {
    setState(() {
      _songName = name;
      _songUrl = url;
    });
  }

  void _addImage(String path) {
    setState(() {
      _imagePaths.add(path);
    });
  }

  Future<void> _saveEntry() async {
    final delta = _controller.document.toDelta();
    final content = jsonEncode(delta.toJson());

    // Check if the content is empty or just contains newlines/whitespace
    if (content.trim().isEmpty || content == jsonEncode([{"insert":"\n"}])) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('El contenido no puede estar vacio')),
      );
      return;
    }

    final entry = DiaryEntry(
      content: content,
      date: _selectedDate,
      songName: _songName,
      songUrl: _songUrl,
      imagePaths: _imagePaths,
    );

    try {
      await DiaryDatabaseHelper.instance.insertEntry(entry);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Diario guardado')),
      );
      widget.onEntryAdded(); // Call the callback to update the diary list
      Navigator.of(context).pop(); // Return to the diary screen
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving diary entry: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
            resizeToAvoidBottomInset: true,
            appBar: AppBar(
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 10, top: 5, bottom: 5),
                  child: CustomSaveButton(onPressed: _saveEntry),
                )
              ],
            ),
            body: Column(
              children: [
                DateButton(
                  selectedDate: _selectedDate,
                  onDateChanged: _updateSelectedDate,
                ),
                SongOfTheDay(
                  onSongUpdated: _updateSongInfo,
                ),
                Expanded(
                  child: DiaryEditor(
                    controller: _controller,
                    onImageAdded: _addImage,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}