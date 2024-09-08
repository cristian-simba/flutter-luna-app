import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:luna/constants/colors.dart';
import 'package:luna/utils/mood_utils.dart';
import 'package:provider/provider.dart';
import 'package:luna/providers/icon_color_provider.dart';

class MonthlyMoodPieChart extends StatefulWidget {
  final Map<String, int> moodCounts;

  MonthlyMoodPieChart({required this.moodCounts});

  @override
  _MonthlyMoodPieChartState createState() => _MonthlyMoodPieChartState();
}

class _MonthlyMoodPieChartState extends State<MonthlyMoodPieChart> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );
    _animation = CurvedAnimation(parent: _animationController, curve: Curves.easeInOut);
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
    final sortedMoods = widget.moodCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value)); // Orden descendente
    final top5Moods = sortedMoods.take(5).toList();

    final List<String> moodNames = top5Moods.map((entry) => entry.key).toList();
    final List<int> counts = top5Moods.map((entry) => entry.value).toList();
    final total = counts.reduce((sum, count) => sum + count);

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Opacity(
          opacity: _animation.value,
          child: Card(
            elevation: 0,
            color: theme.brightness == Brightness.dark ? CardColors.darkCard : CardColors.lightCard,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 10),
                  Text(
                    'Tus principales emociones del mes',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    height: 150,
                    width: double.infinity,
                    child: PieChart(
                      PieChartData(
                        borderData: FlBorderData(show: false),
                        sectionsSpace: 0,
                        centerSpaceRadius: 0,
                        sections: List.generate(moodNames.length, (index) {
                          final color = iconColorProvider.getMoodColor(moodNames[index]);
                          return PieChartSectionData(
                            color: color,
                            value: (counts[index] / total) * 100 * _animation.value,
                            radius: 65 * _animation.value,
                            showTitle: false,
                          );
                        }),
                      ),
                    ),
                  ),
                  SizedBox(height: 25),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(3, (index) {
                          if (index >= moodNames.length) return Container();
                          final percentage = (counts[index] / total) * 100;
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Opacity(
                              opacity: _animation.value,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 16,
                                    height: 16,
                                    color: iconColorProvider.getMoodColor(moodNames[index]),
                                  ),
                                  SizedBox(width: 5),
                                  SvgPicture.asset(
                                    getMoodSvg(moodNames[index]),
                                    height: 20,
                                    width: 20,
                                  ),
                                  SizedBox(width: 5),
                                  Text(
                                    '${(percentage * _animation.value).toStringAsFixed(1)}%',
                                    style: TextStyle(fontSize: 10, color: Colors.grey),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(2, (index) {
                          final dataIndex = 3 + index;
                          if (dataIndex >= moodNames.length) return Container();
                          final percentage = (counts[dataIndex] / total) * 100;
                          return Padding(
                            padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 10),
                            child: Opacity(
                              opacity: _animation.value,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 16,
                                    height: 16,
                                    color: iconColorProvider.getMoodColor(moodNames[dataIndex]),
                                  ),
                                  SizedBox(width: 5),
                                  SvgPicture.asset(
                                    getMoodSvg(moodNames[dataIndex]),
                                    height: 20,
                                    width: 20,
                                  ),
                                  SizedBox(width: 5),
                                  Text(
                                    '${(percentage * _animation.value).toStringAsFixed(1)}%',
                                    style: TextStyle(fontSize: 10, color: Colors.grey),
                                  ),
                                ],
                              ),
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
          ),
        );
      },
    );
  }
}