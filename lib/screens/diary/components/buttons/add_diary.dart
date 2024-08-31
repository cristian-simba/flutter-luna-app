import 'package:flutter/material.dart';
import 'package:luna/constants/route_transitions.dart';
import 'package:luna/screens/diary/components/insert_diary.dart';

class AddDiary extends StatelessWidget {
  final Color iconColor;

  const AddDiary({Key? key, required this.iconColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Navigator.push(
          context,
          SlideAndFadeTransition(page: const InsertDiary()),
        ).then((_) {
          // Refresh the entries list when returning from InsertDiary
          // You might want to use a state management solution or
          // callback to refresh the DiaryList widget
        });
      },
      child: const Icon(Icons.edit, color: Colors.white),
      backgroundColor: iconColor,
    );
  }
}