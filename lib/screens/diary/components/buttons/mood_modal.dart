import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:luna/utils/mood_utils.dart';

class MoodModal extends StatelessWidget {
  final String? selectedMood;
  final Function(String) onMoodSelected;

  MoodModal({Key? key, this.selectedMood, required this.onMoodSelected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '¿Cómo te sientes en este día?',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            SizedBox(height: 20),
            ..._buildMoodGrid(context),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildMoodGrid(BuildContext context) {
    final List<Widget> rows = [];
    for (int i = 0; i < _moodOptions.length; i += 3) {
      final rowMoods = _moodOptions.sublist(i, i + 3 > _moodOptions.length ? _moodOptions.length : i + 3);
      rows.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: rowMoods.map((mood) => Expanded(
            child: GestureDetector(
              onTap: () {
                onMoodSelected(mood);
                Navigator.of(context).pop();
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset(
                    getMoodSvg(mood),
                    width: 25,
                    height: 30,
                  ),
                  SizedBox(height: 8),
                  Text(
                    mood,
                    style: TextStyle(fontSize: 12),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          )).toList(),
        ),
      );
      if (i + 3 < _moodOptions.length) {
        rows.add(SizedBox(height: 20));
      }
    }
    return rows;
  }

  List<String> get _moodOptions => [
    'Normal', 'Feliz', 'Triste', 
    'Enojado', 'Aburrido', 'Sorprendido', 
    'Decepcionado', 'Cansado', 'Enamorado'
  ];
}