import 'package:flutter/material.dart';
import 'package:luna/screens/diary/components/buttons/custom_save_button.dart';
import 'package:luna/screens/diary/components/buttons/date_button.dart';
import 'package:luna/screens/diary/components/diary_editor.dart';
import 'package:luna/screens/diary/components/buttons/song_of_the_day.dart'; 

class InsertDiary extends StatefulWidget {
  const InsertDiary({super.key});

  @override
  _InsertDiaryState createState() => _InsertDiaryState();
}

class _InsertDiaryState extends State<InsertDiary> {
  DateTime _selectedDate = DateTime.now();

  void _updateSelectedDate(DateTime date) {
    setState(() => _selectedDate = date);
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
                  child: CustomSaveButton(onPressed: () {
                    // Implementar lógica de guardado aquí
                  }),
                )
              ],
            ),
            body: Column(
              children: [
                DateButton(
                  selectedDate: _selectedDate,
                  onDateChanged: _updateSelectedDate,
                ),
                SongOfTheDay(),
                Expanded(
                  child: DiaryEditor(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}