import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DayCell extends StatelessWidget {
  final DateTime day;
  final String? mood;

  const DayCell({Key? key, required this.day, this.mood}) : super(key: key);

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
    if (mood != null) {
      final svgPath = _getMoodSvg(mood!);
      return Center(
        child: SvgPicture.asset(
          svgPath,
          width: 30.0,
          height: 30.0,
        ),
      );
    } else {
      return Center(
        child: Text(
          '${day.day}',
          style: TextStyle(fontSize: 14),
        ),
      );
    }
  }
}