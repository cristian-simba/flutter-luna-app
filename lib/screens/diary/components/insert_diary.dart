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
  const InsertDiary({super.key});

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
        SnackBar(content: Text('Diary entry saved successfully!')),
      );
      // Optionally, navigate back or clear the form
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