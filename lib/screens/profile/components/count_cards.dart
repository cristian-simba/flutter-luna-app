import 'package:flutter/material.dart';
import 'package:luna/constants/colors.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CountCards extends StatelessWidget {
  final int diaryCount;
  final int photoCount;

  const CountCards({
    Key? key,
    required this.diaryCount,
    required this.photoCount,
  }) : super(key: key);

  Widget _buildCountCard(BuildContext context, String title, int count, String svgPath) {
    final theme = Theme.of(context);
    final cardColor = theme.brightness == Brightness.dark ? CardColors.darkCard : CardColors.lightCard;

    return Card(
      elevation: 0.25,
      color: cardColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, 
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            Text(
              count.toString(),
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.end, 
              children: [
                SvgPicture.asset(
                  svgPath,
                  width: 40,
                  height: 40,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: _buildCountCard(context, "Diarios", diaryCount, 'assets/svgs/book.svg'),
        ),
        Expanded(
          child: _buildCountCard(context, "Fotos", photoCount, 'assets/svgs/galery.svg'),
        ),
      ],
    );
  }
}