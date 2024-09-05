import 'package:flutter/material.dart';
import 'package:luna/screens/diary/components/buttons/custom_save_button.dart';
import 'package:luna/screens/diary/components/diary_editor.dart';
import 'package:luna/screens/diary/components/buttons/date_button.dart';
import 'package:luna/screens/diary/components/buttons/song_of_the_day.dart';
import 'package:luna/screens/diary/components/buttons/mood_modal.dart'; 
import 'package:luna/models/diary_entry.dart';
import 'package:luna/services/database.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:luna/constants/colors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:convert';

class EditDiaryScreen extends StatefulWidget {
  final DiaryEntry? entry;
  final VoidCallback onEntryUpdated;

  const EditDiaryScreen({
    Key? key,
    this.entry,
    required this.onEntryUpdated,
  }) : super(key: key);

  @override
  _EditDiaryScreenState createState() => _EditDiaryScreenState();
}

class _EditDiaryScreenState extends State<EditDiaryScreen> {
  late DateTime _selectedDate;
  late String _songName;
  late String _songUrl;
  late List<String> _imagePaths;
  late QuillController _controller;
  String? _selectedMood;

  void _showMoodModal() {
    showDialog(
      context: context,
      builder: (context) => MoodModal(
        selectedMood: _selectedMood,
        onMoodSelected: (mood) {
          setState(() {
            _selectedMood = mood;
          });
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  void _initializeData() {
    if (widget.entry != null) {
      // Editing existing entry
      _selectedDate = widget.entry!.date;
      _songName = widget.entry!.songName ?? "";
      _songUrl = widget.entry!.songUrl ?? "";
      _imagePaths = widget.entry!.imagePaths;
      _controller = QuillController(
        document: Document.fromJson(jsonDecode(widget.entry!.content)),
        selection: const TextSelection.collapsed(offset: 0),
      );
      _selectedMood = widget.entry!.mood; 
    } else {
      // Creating new entry
      _selectedDate = DateTime.now();
      _songName = "";
      _songUrl = "";
      _imagePaths = [];
      _controller = QuillController.basic();
    }
    setState(() {});
    print("Imagenes que estan guardadas");
    print(_imagePaths);
  }

  void _updateSelectedDate(DateTime date) {
    setState(() => _selectedDate = date);
  }

  void _updateSongInfo(String name, String url) {
    setState(() {
      _songName = name;
      _songUrl = url;
    });
  }

  void _updateImages(List<String> paths){
    setState(() {
      _imagePaths = paths;
    });
  }

  Future<void> _saveEntry() async {
    final delta = _controller.document.toDelta();
    final content = jsonEncode(delta.toJson());

    if (content.trim().isEmpty || content == jsonEncode([{"insert":"\n"}])) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('El contenido no puede estar vacío')),
      );
      return;
    }

    // Si no se selecciona ningún estado de ánimo, establecer "predeterminado"
    final mood = _selectedMood ?? 'x';

    final entry = DiaryEntry(
      id: widget.entry?.id,
      content: content,
      date: _selectedDate,
      songName: _songName,
      songUrl: _songUrl,
      imagePaths: _imagePaths,
      mood: mood, 
    );

    try {
      if (widget.entry != null) {
        await DiaryDatabaseHelper.instance.updateEntry(entry);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Diario actualizado')),
        );
      } else {
        await DiaryDatabaseHelper.instance.insertEntry(entry);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Diario guardado')),
        );
      }
      widget.onEntryUpdated();
      Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al guardar el diario: $e')),
      );
    }
  }

  String _getMoodSvg(String mood) {
    switch (mood) {
      case 'Normal':
        return 'assets/svgs/neutral.svg';
      case 'Feliz':
        return 'assets/svgs/happy.svg';
      case 'Triste':
        return 'assets/svgs/sad.svg';
      case 'Enojado':
        return 'assets/svgs/angry.svg';
      case 'Confundido':
        return 'assets/svgs/confused.svg';
      case 'Sorprendido':
        return 'assets/svgs/surprised.svg';
      case 'Cansado':
        return 'assets/svgs/tired.svg';
      case 'x':
        return 'assets/svgs/predetermined.svg';
      default:
        return 'assets/svgs/predetermined.svg';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
            resizeToAvoidBottomInset: true,
            appBar: AppBar(
              scrolledUnderElevation: 0,
              backgroundColor: theme.brightness == Brightness.dark ? 
              ScreenBackground.darkBackground : 
              ScreenBackground.lightBackground, 
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 10, top: 5, bottom: 5),
                  child: CustomSaveButton(onPressed: _saveEntry),
                )
              ],
            ),
            body: Container(
              color: theme.brightness == Brightness.dark ? 
              ScreenBackground.darkBackground : 
              ScreenBackground.lightBackground, 
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: DateButton(
                          selectedDate: _selectedDate,
                          onDateChanged: _updateSelectedDate,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 20),
                        child: GestureDetector(
                          onTap: _showMoodModal,
                          child: SvgPicture.asset(
                            _getMoodSvg(_selectedMood ?? 'x'),
                            width: 25,
                            height: 25,
                          ),
                        ),
                      )
                    ],
                  ),
                  SongOfTheDay(
                    initialSongName: _songName,
                    initialSongUrl: _songUrl,
                    onSongUpdated: _updateSongInfo,
                  ),
                  Expanded(
                    child: DiaryEditor(
                      controller: _controller,
                      imagePaths: _imagePaths,
                      updateImages: _updateImages,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
