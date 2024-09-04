import 'package:flutter/material.dart';
import 'package:luna/constants/route_transitions.dart';
import 'package:luna/screens/diary/components/insert_diary.dart';

class AddDiary extends StatelessWidget {
  final Color iconColor;
  final VoidCallback onEntryAdded;

  const AddDiary({
    Key? key, 
    required this.iconColor, 
    required this.onEntryAdded
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Navigator.push(
          context,
          SlideAndFadeTransition(
            page: EditDiaryScreen(onEntryUpdated: onEntryAdded),
          ),
        );
      },
      child: Icon(Icons.add, color: Colors.white),
      backgroundColor: iconColor,
      shape: const CircleBorder(), 
    );
  }
}
