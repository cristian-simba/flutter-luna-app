import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:luna/constants/colors.dart';
import 'package:luna/providers/icon_color_provider.dart';
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
    final iconColor = Provider.of<IconColorProvider>(context).iconColor;
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