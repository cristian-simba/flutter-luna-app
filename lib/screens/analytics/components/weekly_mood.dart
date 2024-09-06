import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:luna/constants/colors.dart';
import 'package:luna/utils/mood_utils.dart';
import 'package:luna/utils/mood_colors.dart';

class WeeklyMood extends StatelessWidget {
  final Map<String, int> moodCounts;

  WeeklyMood({required this.moodCounts});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final List<String> moodNames = moodCounts.keys.toList();
    final List<int> counts = moodCounts.values.toList();
    final double maxCount = counts.reduce((max, count) => count > max ? count : max).toDouble();

    return Wrap(
      children: [
        Card(
          color: theme.brightness == Brightness.dark ? CardColors.darkCard : CardColors.lightCard,
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Tus 5 emociones de la semana',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
                SizedBox(height: 16),
                SizedBox(
                  height: 175, 
                  child: BarChart(
                    BarChartData(
                      alignment: BarChartAlignment.spaceEvenly,
                      maxY: maxCount,
                      barGroups: List.generate(moodNames.length, (index) {
                        return BarChartGroupData(
                          x: index,
                          barRods: [
                            BarChartRodData(
                              toY: counts[index].toDouble(),
                              color: getMoodColor(moodNames[index]),
                              width: 30, // Barras más anchas
                              borderRadius: BorderRadius.zero,
                            )
                          ],
                        );
                      }),
                      titlesData: FlTitlesData(
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              return Padding(
                                padding: const EdgeInsets.only(top: 3.0),
                                child: SvgPicture.asset(
                                  getMoodSvg(moodNames[value.toInt()]),
                                  height: 50,
                                  width: 50,
                                ),
                              );
                            },
                          ),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 30,
                            getTitlesWidget: (value, meta) {
                              return Text(
                                value.toInt().toString(),
                                style: TextStyle(fontSize: 10),
                              );
                            },
                          ),
                        ),
                        topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      ),
                      borderData: FlBorderData(
                        border: Border.all(
                          color: theme.brightness == Brightness.dark ? 
                          BarChartWidgetColors.darkBorder : BarChartWidgetColors.lightBorder,
                        )
                      ),
                      gridData: FlGridData(
                        show: true,
                        getDrawingHorizontalLine: (value) {
                          return FlLine(
                            color: theme.brightness == Brightness.dark ? 
                          BarChartWidgetColors.darkHorizontalLines : BarChartWidgetColors.lightHorizontalLines,
                            strokeWidth: 1,
                            dashArray: [5, 5],
                          );
                        },
                        getDrawingVerticalLine: (value) {
                          return FlLine(
                            color: theme.brightness == Brightness.dark ? 
                          BarChartWidgetColors.darkVerticalLines : BarChartWidgetColors.lightVerticalLines,
                            strokeWidth: 1,
                            dashArray: [5, 5],
                          );
                        },
                      ),
                      barTouchData: BarTouchData(enabled: false),
                    ),
                    swapAnimationDuration: Duration(milliseconds: 150),
                    swapAnimationCurve: Curves.linear,
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}