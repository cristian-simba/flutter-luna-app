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
              'Selecciona tu estado de ánimo',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            SizedBox(height: 20),
            // Fila superior
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: _moodOptions.sublist(0, 4).map((mood) => Expanded(
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
                        height: 25,
                      ),
                      SizedBox(height: 8),
                      Text(
                        mood,
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
              )).toList(),
            ),
            SizedBox(height: 20),
            // Fila inferior
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: _moodOptions.sublist(4).map((mood) => Expanded(
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
                        height: 25,
                      ),
                      SizedBox(height: 8),
                      Text(
                        mood,
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
              )).toList(),
            ),
          ],
        ),
      ),
    );
  }



  List<String> get _moodOptions => ['Normal', 'Feliz', 'Triste', 'Enojado', 'Sorprendido', 'Confundido', 'Cansado'];
}
