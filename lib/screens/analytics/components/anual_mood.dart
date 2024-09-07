import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:luna/constants/colors.dart';
import 'package:luna/utils/mood_utils.dart';
import 'package:provider/provider.dart';
import 'package:luna/providers/icon_color_provider.dart';

class AnnualMood extends StatefulWidget {
  final Map<String, int> moodCounts;

  AnnualMood({required this.moodCounts});

  @override
  _AnnualMoodState createState() => _AnnualMoodState();
}

class _AnnualMoodState extends State<AnnualMood> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

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
    final List<String> allMoods = getAllMoods(); // Obtén todas las emociones posibles
    final List<String> moodNames = allMoods;
    final List<int> counts = moodNames.map((mood) => widget.moodCounts[mood] ?? 0).toList();
    final double maxCount = counts.reduce((max, count) => count > max ? count : max).toDouble();

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Opacity(
          opacity: _animation.value,
          child: Card(
            color: theme.brightness == Brightness.dark ? CardColors.darkCard : CardColors.lightCard,
            child: Padding(
              padding: const EdgeInsets.only(top: 20.0, bottom: 20.0, left: 10, right: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(padding: EdgeInsets.symmetric(horizontal: 25), child: Text(
                    'Tus emociones del año',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                  ),),
                  SizedBox(height: 16),
                  SizedBox(
                    height: 300,
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
                                width: 25,
                                borderRadius: BorderRadius.zero,
                              )
                            ],
                          );
                        }),
                        titlesData: FlTitlesData(
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 50,
                              getTitlesWidget: (value, meta) {
                                return RotatedBox(quarterTurns: -1,  child: Padding(
                                  padding: const EdgeInsets.only(right: 0.0),
                                  child: SvgPicture.asset(
                                    getMoodSvg(moodNames[value.toInt()]),
                                    height: 20,
                                    width: 20,
                                  ),
                                ),);
                              },
                            ),
                          ),
                          leftTitles: AxisTitles(),
                          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        ),
                        borderData: FlBorderData(
                          show: false,
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
                              strokeWidth: 0,
                              dashArray: [5, 5],
                            );
                          },
                          getDrawingVerticalLine: (value) {
                            return FlLine(
                              color: theme.brightness == Brightness.dark ? 
                            BarChartWidgetColors.darkVerticalLines : BarChartWidgetColors.lightVerticalLines,
                              strokeWidth: 0.5,
                              dashArray: [5, 5],
                            );
                          },
                        ),
                        barTouchData: BarTouchData(enabled: false),
                      ),
                      swapAnimationDuration: Duration(milliseconds: 150),
                      swapAnimationCurve: Curves.linear,
                    ),
                  )),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // Devuelve una lista de todas las emociones posibles
  List<String> getAllMoods() {
    // Reemplaza esto con la lista completa de emociones posibles
    return ['Feliz', 'Triste', 'Enojado', 'Neutral', 'Sorprendido', 'Aburrido'];
  }
}
