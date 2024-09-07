import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:luna/utils/mood_utils.dart';
import 'package:luna/constants/colors.dart';

class DayCell extends StatelessWidget {
  final DateTime day;
  final String? mood;

  const DayCell({
    Key? key,
    required this.day,
    this.mood,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final hasMood = mood != null;
    final theme = Theme.of(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (hasMood)
          SvgPicture.asset(
            getMoodSvg(mood!),
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
          style: TextStyle(fontSize: 11), 
        ),
      ],
    );
  }
}
