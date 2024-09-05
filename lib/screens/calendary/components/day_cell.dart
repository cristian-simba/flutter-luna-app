import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:luna/constants/colors.dart';

class DayCell extends StatelessWidget {
  final DateTime day;
  final String? mood;

  const DayCell({
    Key? key,
    required this.day,
    this.mood,
  }) : super(key: key);

  String _getMoodSvg(String mood) {
    switch (mood) {
      case 'Normal':
        return 'assets/svgs/neutral.svg';
      case 'Feliz':
        return 'assets/svgs/happy.svg';
      case 'Triste':
        return 'assets/svgs/sad.svg';
      case 'Enojado':
        return 'assets/svgs/angry.svg';
      case 'Confundido':
        return 'assets/svgs/confused.svg';
      case 'Sorprendido':
        return 'assets/svgs/surprised.svg';
      case 'Cansado':
        return 'assets/svgs/tired.svg';
      case 'x':
        return 'assets/svgs/predetermined.svg';
      default:
        return 'assets/svgs/predetermined.svg';
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasMood = mood != null;
    final theme = Theme.of(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (hasMood)
          SvgPicture.asset(
            _getMoodSvg(mood!),
            width: 30.0,
            height: 30.0,
          )
        else
          Container(
            width: 30.0,
            height: 30.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: theme.brightness == Brightness.dark ?
              CalendaryCell.darkCircle : CalendaryCell.lightCircle
            ),
          ),
        SizedBox(height: 5.0), 
        Text(
          '${day.day}',
          style: TextStyle(fontSize: 12), 
        ),
      ],
    );
  }
}
