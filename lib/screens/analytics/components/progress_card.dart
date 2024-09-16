import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:luna/providers/icon_color_provider.dart';
import 'package:luna/services/database.dart';
import 'dart:math'; // Importa la biblioteca dart:math

class ProgressCard extends StatelessWidget {
  const ProgressCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final iconColor = Provider.of<IconColorProvider>(context).iconColor;
    final bannerColor = theme.brightness == Brightness.dark ? iconColor.withOpacity(0.8) : iconColor.withOpacity(1);

    return FutureBuilder<int>(
      future: DiaryDatabaseHelper.instance.getDiaryCount(),
      builder: (context, snapshot) {
        int diaryCount = snapshot.data ?? 0;
        diaryCount = min(diaryCount, 7); // Limita diaryCount a un máximo de 7
        final progress = diaryCount / 7;

        return Card(
          elevation: 0.25,
          color: bannerColor,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Progreso',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            '$diaryCount de 7 diarios para ver gráficas',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 5),
                    SvgPicture.asset(
                      'assets/svgs/predetermined.svg',
                      width: 50,
                      height: 50,
                    ),
                  ],
                ),
                SizedBox(height: 10),
                LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.white.withOpacity(0.3),
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
