import 'package:flutter/material.dart';
import 'package:luna/constants/colors.dart';
import 'package:luna/screens/diary/components/view/diary_list.dart';

class Diary extends StatefulWidget {
  const Diary({Key? key}) : super(key: key);

  @override
  DiaryState createState() => DiaryState();
}

class DiaryState extends State<Diary> {
  Key _diaryListKey = UniqueKey();

  void refreshDiaryList() {
    setState(() {
      _diaryListKey = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Stack(
      children: [
        Scaffold(
        backgroundColor: theme.brightness == Brightness.dark ? 
              ScreenBackground.darkBackground : ScreenBackground.lightBackground,
          body: DiaryList(key: _diaryListKey),
        ),
      ],
    );
  }
}