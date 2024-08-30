import 'package:flutter/material.dart';
import 'package:luna/constants/grid_painter.dart';
import 'package:luna/constants/route_transitions.dart';
import 'package:luna/screens/diary/components/insert_diary.dart';
import 'package:provider/provider.dart';
import 'package:luna/providers/icon_color_provider.dart';  
import 'package:luna/services/database.dart';
import 'package:luna/models/diary_entry.dart';

class Diary extends StatefulWidget {
  const Diary({super.key});

  @override
  _DiaryState createState() => _DiaryState();
}

class _DiaryState extends State<Diary> {
  @override
  Widget build(BuildContext context) {
    final iconColor = Provider.of<IconColorProvider>(context).iconColor;

    return Stack(
      children: [
        Positioned.fill(
          child: CustomPaint(
            painter: GridPainter(Theme.of(context)),
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent, 
          appBar: AppBar(
            title: Text('Diario'),
            backgroundColor: Colors.transparent, 
            elevation: 0, 
          ),
          body: const Center(
            child: Text('Diario'),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                SlideAndFadeTransition(page: const InsertDiary()),
              );
            },
            child: Icon(Icons.edit, color: Colors.white,),
            backgroundColor: iconColor,
          ),
        ),
      ],
    );
  }
}
