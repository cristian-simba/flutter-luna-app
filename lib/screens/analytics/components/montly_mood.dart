import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:luna/constants/colors.dart';
import 'package:luna/utils/mood_utils.dart';
import 'package:luna/utils/mood_colors.dart';

class MonthlyMoodPieChart extends StatelessWidget {
  final Map<String, int> moodCounts;

  MonthlyMoodPieChart({required this.moodCounts});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Ordenar emociones por conteo y tomar las 5 principales
    final sortedMoods = moodCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value)); // Orden descendente
    final top5Moods = sortedMoods.take(5).toList();

    final List<String> moodNames = top5Moods.map((entry) => entry.key).toList();
    final List<int> counts = top5Moods.map((entry) => entry.value).toList();
    final total = counts.reduce((sum, count) => sum + count);

    return Card(
      color: theme.brightness == Brightness.dark ? CardColors.darkCard : CardColors.lightCard,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Tus principales emociones del mes',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            SizedBox(height: 16),
            SizedBox(
              height: 175,
              width: double.infinity, 
              child: PieChart(
                PieChartData(
                  borderData: FlBorderData(
                    show: false,
                  ),
                  sectionsSpace: 0,
                  centerSpaceRadius: 0,
                  sections: List.generate(moodNames.length, (index) {
                    return PieChartSectionData(
                      color: getMoodColor(moodNames[index]),
                      value: (counts[index] / total) * 100,
                      radius: 75,
                      showTitle: false
                    );
                  }),
                ),
              ),
            ),
            SizedBox(height: 5),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(3, (index) {
                    if (index >= moodNames.length) return Container(); // Evita errores si hay menos de 3 ítems
                    final percentage = (counts[index] / total) * 100;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 16,
                            height: 16,
                            color: getMoodColor(moodNames[index]),
                          ),
                          SizedBox(width: 5),
                          SvgPicture.asset(
                            getMoodSvg(moodNames[index]),
                            height: 20,
                            width: 20,
                          ),
                          SizedBox(width: 5),
                          Text('${percentage.toStringAsFixed(1)}%', style: TextStyle(fontSize: 12, color: Colors.grey),),
                        ],
                      ),
                    );
                  }),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(2, (index) {
                    final dataIndex = 3 + index; // Para las 2 leyendas de la fila inferior
                    if (dataIndex >= moodNames.length) return Container(); // Evita errores si hay menos de 5 ítems
                    final percentage = (counts[dataIndex] / total) * 100;
                    return Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8.0, top:  10),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 16,
                            height: 16,
                            color: getMoodColor(moodNames[dataIndex]),
                          ),
                          SizedBox(width: 5),
                          SvgPicture.asset(
                            getMoodSvg(moodNames[dataIndex]),
                            height: 20,
                            width: 20,
                          ),
                          SizedBox(width: 5),
                          Text('${percentage.toStringAsFixed(1)}%', style: TextStyle(fontSize: 12, color: Colors.grey),),
                        ],
                      ),
                    );
                  }),
                ),
              ],
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
