import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:luna/constants/colors.dart';
import 'package:luna/utils/mood_utils.dart';
import 'package:provider/provider.dart';
import 'package:luna/providers/icon_color_provider.dart';

class AnnualMoodExample extends StatefulWidget {
  @override
  _AnnualMoodExampleState createState() => _AnnualMoodExampleState();
}

class _AnnualMoodExampleState extends State<AnnualMoodExample> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  // Datos de ejemplo predefinidos
  final Map<String, int> exampleMoodCounts = {
    'Feliz': 120,
    'Normal': 95,
    'Cansado': 60,
    'Triste': 40,
    'Enojado': 30,
    'Sorprendido': 25,
    'x': 15,
  };

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final iconColorProvider = Provider.of<IconColorProvider>(context);

    final sortedMoodEntries = exampleMoodCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final List<String> moodNames = sortedMoodEntries.map((entry) => entry.key).toList();
    final List<int> counts = sortedMoodEntries.map((entry) => entry.value).toList();
    final double maxCount = counts.reduce((max, count) => count > max ? count : max).toDouble();
    final cardColor = theme.brightness == Brightness.dark ? CardColors.darkCard : CardColors.lightCard;
    final borderColor = theme.brightness == Brightness.dark ? BarChartWidgetColors.darkBorder : BarChartWidgetColors.lightBorder;
    final horizontalColor = theme.brightness == Brightness.dark ? BarChartWidgetColors.darkHorizontalLines : BarChartWidgetColors.lightHorizontalLines;
    final verticalColor = theme.brightness == Brightness.dark ? BarChartWidgetColors.darkVerticalLines : BarChartWidgetColors.lightVerticalLines;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Opacity(
          opacity: _animation.value,
          child: Card(
            elevation: 0,
            color: cardColor,
            child: Padding(
              padding: const EdgeInsets.only(top: 25.0, bottom: 20.0, left: 10, right: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildChartTitle(),
                  SizedBox(height: 5),
                  SizedBox(
                    height: 300,
                    child: Opacity(
                      opacity: 0.3,
                      child: RotatedBox(
                        quarterTurns: -3,
                        child: BarChart(
                          BarChartData(
                            alignment: BarChartAlignment.spaceEvenly,
                            maxY: maxCount,
                            barGroups: List.generate(moodNames.length, (index) {
                              return BarChartGroupData(
                                x: index,
                                barRods: [
                                  BarChartRodData(
                                    toY: counts[index].toDouble() * _animation.value,
                                    color: iconColorProvider.getMoodColor(moodNames[index]),
                                    width: 20,
                                    borderRadius: BorderRadius.all(Radius.circular(5)),
                                  ),
                                ],
                              );
                            }),
                            titlesData: _flTitleData(moodNames),
                            borderData: _flBorder(borderColor),
                            gridData: _flGridData(horizontalColor, verticalColor),
                            barTouchData: BarTouchData(enabled: false),
                          ),
                          swapAnimationDuration: Duration(milliseconds: 150),
                          swapAnimationCurve: Curves.linear,
                        ),
                      ),
                    )
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildChartTitle() {
    final theme = Theme.of(context);
    return Center(
      child: Text(
        'No hay datos disponibles',
        style: TextStyle(
          fontSize: 14,
          color: theme.brightness == Brightness.dark ? Colors.grey : Colors.grey[700],
        ),
      )
    );
  }

  FlTitlesData _flTitleData(List<String> moodNames) {
    return FlTitlesData(
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 50,
          getTitlesWidget: (value, meta) {
            return RotatedBox(
              quarterTurns: -1,
              child: Padding(
                padding: const EdgeInsets.only(right: 0.0),
                child: SvgPicture.asset(
                  getMoodSvg(moodNames[value.toInt()]),
                  height: 20,
                  width: 20,
                ),
              ),
            );
          },
        ),
      ),
      leftTitles: AxisTitles(),
      topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
      rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
    );
  }

  FlBorderData _flBorder(Color borderColor) {
    return FlBorderData(
      show: false,
      border: Border.all(
        color: borderColor,
      ),
    );
  }

  FlGridData _flGridData(Color horizontalColor, Color verticalColor) {
    return FlGridData(
      show: true,
      getDrawingHorizontalLine: (value) {
        return FlLine(
          color: horizontalColor,
          strokeWidth: 0,
          dashArray: [5, 5],
        );
      },
      getDrawingVerticalLine: (value) {
        return FlLine(
          color: verticalColor,
          strokeWidth: 0.5,
          dashArray: [5, 5],
        );
      },
    );
  }
}