import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:luna/constants/colors.dart';
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
    final theme = Theme.of(context);

    return Stack(
      children: [
        Scaffold(
        backgroundColor: theme.brightness == Brightness.dark ? 
              ScreenBackground.darkBackground : ScreenBackground.lightBackground,
          // appBar: AppBar(
          //   scrolledUnderElevation: 0,
          //   bottom: PreferredSize(
          //     preferredSize: const Size.fromHeight(0.0),
          //     child: Container(
          //       decoration: BoxDecoration(
          //         color: theme.brightness == Brightness.dark 
          //           ? SeparatorColors.darkSeparator 
          //           : SeparatorColors.lightSeparator,
          //         boxShadow: [
          //           BoxShadow(
          //             color: Colors.grey.withOpacity(0.1), // Color de la sombra
          //             spreadRadius: 1, // Expansión de la sombra
          //             blurRadius: 1, // Desenfoque de la sombra
          //           ),
          //         ],
          //       ),
          //       height: 0.25,
          //     ),
          //   ),
          //   title: const Text('Luna :)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
          //   centerTitle: true,
          //   backgroundColor: theme.brightness == Brightness.dark ? 
          //     ScreenBackground.darkBackground : ScreenBackground.lightBackground,
          // ),
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