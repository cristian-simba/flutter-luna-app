import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:luna/constants/grid_painter.dart';
import 'package:luna/providers/icon_color_provider.dart';
import 'package:luna/screens/diary/components/view/diary_list.dart';
import 'package:luna/screens/diary/components/buttons/add_diary.dart';

class Diary extends StatefulWidget {
  const Diary({Key? key}) : super(key: key);

  @override
  _DiaryState createState() => _DiaryState();
}

class _DiaryState extends State<Diary> {
  Key _diaryListKey = UniqueKey();

  void _refreshDiaryList() {
    setState(() {
      _diaryListKey = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    final iconColor = Provider.of<IconColorProvider>(context).iconColor;

    return Stack(
      children: [
        // Positioned.fill(
        //   child: CustomPaint(
        //     painter: GridPainter(Theme.of(context)),
        //   ),
        // ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: const Text('Diario'),
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          body: DiaryList(key: _diaryListKey),
          floatingActionButton: AddDiary(
            iconColor: iconColor,
            onEntryAdded: _refreshDiaryList,
          ),
        ),
      ],
    );
  }
}