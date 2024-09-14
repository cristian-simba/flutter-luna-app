import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:luna/utils/mood_utils.dart';
import 'package:luna/constants/colors.dart';
import 'package:provider/provider.dart';
import 'package:luna/providers/icon_color_provider.dart';
class DayCell extends StatelessWidget {
  final DateTime day;
  final String? mood;
  final bool isSelected;

  const DayCell({
    Key? key,
    required this.day,
    this.mood,
    required this.isSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final iconColor = Provider.of<IconColorProvider>(context).iconColor;
    final circleColor = theme.brightness == Brightness.dark ? CalendaryCell.darkCircle : CalendaryCell.lightCircle;
    final borderColor = theme.brightness == Brightness.dark ? Colors.white.withOpacity(0.5) : Color(0xFFE0E0E0).withOpacity(0.5);
    final shadowColor = theme.brightness == Brightness.dark ? Colors.white.withOpacity(0.5) : Color(0xFFD6D6D6).withOpacity(0.8);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 30.0,
          height: 30.0,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: circleColor,
            border: isSelected
                ? Border.all(
                    color: borderColor,
                    width: 0.25,
                  )
                : null,
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: shadowColor,
                      blurRadius: 5,
                      spreadRadius: 1,
                      offset: Offset(0, 0),
                    )
                  ]
                : [], // No shadow if not selected
          ),
          child: Center(
            child: mood != null
                ? SvgPicture.asset(
                    getMoodSvg(mood!),
                    width: 30.0,
                    height: 30.0,
                  )
                : Opacity(
                    opacity: theme.brightness == Brightness.dark ? 0.25 : 0.15,
                    child: SvgPicture.asset(
                      'assets/svgs/predetermined.svg',
                      width: 30.0,
                      height: 30.0,
                    ),
                  ),
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
