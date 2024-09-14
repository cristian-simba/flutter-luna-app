import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:luna/constants/colors.dart';
import 'package:luna/utils/mood_utils.dart';
import 'package:provider/provider.dart';
import 'package:luna/providers/icon_color_provider.dart';

class WeeklyMoodExample extends StatefulWidget {
  final Map<String, int>? moodCounts;

  const WeeklyMoodExample({Key? key, this.moodCounts}) : super(key: key);

  @override
  _WeeklyMoodState createState() => _WeeklyMoodState();
}

class _WeeklyMoodState extends State<WeeklyMoodExample> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  final Map<String, int> _exampleData = {
    'Feliz': 8,
    'Triste': 6,
    'Enojado': 5,
    'Normal': 3,
    'Sorprendido': 1,
  };

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
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
    final cardColor = theme.brightness == Brightness.dark ? CardColors.darkCard : CardColors.lightCard;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Opacity(
          opacity: _animation.value,
          child: Card(
            elevation: 0,
            color: cardColor,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildChartTitle(),
                  const SizedBox(height: 25),
                  _buildChartContent(theme, iconColorProvider),
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
    return Text(
      'No hay datos disponibles',
      style: TextStyle(
        fontSize: 14,
        color: theme.brightness == Brightness.dark ? Colors.grey : Colors.grey[700],
      ),
    );
  }

  Widget _buildChartContent(ThemeData theme, IconColorProvider iconColorProvider) {
    if (widget.moodCounts == null || widget.moodCounts!.isEmpty) {
      return Stack(
        alignment: Alignment.center,
        children: [
          Opacity(
            opacity: 0.3,
            child: _buildChart(theme, iconColorProvider, _exampleData),
          ),
        ],
      );
    } else {
      return _buildChart(theme, iconColorProvider, widget.moodCounts!);
    }
  }

  Widget _buildChart(ThemeData theme, IconColorProvider iconColorProvider, Map<String, int> data) {
    final List<String> moodNames = data.keys.toList();
    final List<int> counts = data.values.toList();
    final double maxCount = counts.reduce((max, count) => count > max ? count : max).toDouble();
    
    final borderColor = theme.brightness == Brightness.dark ? BarChartWidgetColors.darkBorder : BarChartWidgetColors.lightBorder;
    final horizontalColor = theme.brightness == Brightness.dark ? BarChartWidgetColors.darkHorizontalLines : BarChartWidgetColors.lightHorizontalLines;
    final verticalColor = theme.brightness == Brightness.dark ? BarChartWidgetColors.darkVerticalLines : BarChartWidgetColors.lightVerticalLines;

    return SizedBox(
      height: 125,
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
                  borderRadius: const BorderRadius.all(Radius.circular(5))
                )
              ],
            );
          }),
          titlesData: _flTitleData(moodNames),
          borderData: _flBorder(borderColor),
          gridData: _flGridData(horizontalColor, verticalColor),
          barTouchData: BarTouchData(enabled: false),
        ),
        swapAnimationDuration: const Duration(milliseconds: 150),
        swapAnimationCurve: Curves.linear,
      ),
    );
  }

  FlTitlesData _flTitleData(List<String> moodNames) {
    return FlTitlesData(
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          getTitlesWidget: (value, meta) {
            return Padding(
              padding: const EdgeInsets.only(top: 5.0),
              child: SvgPicture.asset(
                getMoodSvg(moodNames[value.toInt()]),
                height: 50,
                width: 50,
              ),
            );
          },
        ),
      ),
      leftTitles: _leftTitles(),
      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
    );
  }

  AxisTitles _leftTitles() {
    return AxisTitles(
      sideTitles: SideTitles(
        showTitles: true,
        reservedSize: 30,
        getTitlesWidget: (value, meta) {
          return Text(
            value.toInt().toString(),
            style: const TextStyle(fontSize: 10),
          );
        },
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

  FlBorderData _flBorder(Color borderColor) {
    return FlBorderData(
      show: false,
      border: Border.all(color: borderColor)
    );
  }
}
