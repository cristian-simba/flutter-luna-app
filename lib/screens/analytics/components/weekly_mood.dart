import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:luna/constants/colors.dart';
import 'package:luna/utils/mood_utils.dart';
import 'package:provider/provider.dart';
import 'package:luna/providers/icon_color_provider.dart';

class WeeklyMood extends StatefulWidget {
  final Map<String, int> moodCounts;

  const WeeklyMood({Key? key, required this.moodCounts}) : super(key: key);

  @override
  _WeeklyMoodState createState() => _WeeklyMoodState();
}

class _WeeklyMoodState extends State<WeeklyMood> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _setupAnimation();
  }

  void _setupAnimation() {
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
      builder: (context, child) => _buildCard(theme, iconColorProvider, cardColor),
    );
  }

  Widget _buildCard(ThemeData theme, IconColorProvider iconColorProvider, Color cardColor) {
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
              _buildChart(theme, iconColorProvider),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChartTitle() {
    return const Text(
      'Tus emociones los últimos 7 días',
      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
    );
  }

  Widget _buildChart(ThemeData theme, IconColorProvider iconColorProvider) {
    final List<String> moodNames = widget.moodCounts.keys.toList();
    final List<int> counts = widget.moodCounts.values.toList();
    final double maxCount = counts.reduce((max, count) => count > max ? count : max).toDouble();

    return SizedBox(
      height: 125,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceEvenly,
          maxY: maxCount,
          barGroups: _generateBarGroups(moodNames, counts, iconColorProvider),
          titlesData: _flTitleData(moodNames),
          borderData: _flBorder(theme),
          gridData: _flGridData(theme),
          barTouchData: BarTouchData(enabled: false),
        ),
        swapAnimationDuration: const Duration(milliseconds: 150),
        swapAnimationCurve: Curves.linear,
      ),
    );
  }

  List<BarChartGroupData> _generateBarGroups(
    List<String> moodNames, 
    List<int> counts, 
    IconColorProvider iconColorProvider
  ) {
    return List.generate(moodNames.length, (index) {
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
    });
  }

  FlTitlesData _flTitleData(List<String> moodNames) {
    return FlTitlesData(
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          getTitlesWidget: (value, meta) => _buildMoodIcon(moodNames[value.toInt()]),
        ),
      ),
      leftTitles: _leftTitles(),
      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
    );
  }

  Widget _buildMoodIcon(String mood) {
    return Padding(
      padding: const EdgeInsets.only(top: 5.0),
      child: SvgPicture.asset(
        getMoodSvg(mood),
        height: 50,
        width: 50,
      ),
    );
  }

  AxisTitles _leftTitles() {
    return AxisTitles(
      sideTitles: SideTitles(
        showTitles: true,
        reservedSize: 30,
        getTitlesWidget: (value, meta) => Text(
          value.toInt().toString(),
          style: const TextStyle(fontSize: 10),
        ),
      ),
    );
  }

  FlGridData _flGridData(ThemeData theme) {
    final horizontalColor = theme.brightness == Brightness.dark 
      ? BarChartWidgetColors.darkHorizontalLines 
      : BarChartWidgetColors.lightHorizontalLines;
    final verticalColor = theme.brightness == Brightness.dark 
      ? BarChartWidgetColors.darkVerticalLines 
      : BarChartWidgetColors.lightVerticalLines;

    return FlGridData(
      show: true,
      getDrawingHorizontalLine: (value) => FlLine(
        color: horizontalColor,
        strokeWidth: 0,
        dashArray: [5, 5],
      ),
      getDrawingVerticalLine: (value) => FlLine(
        color: verticalColor,
        strokeWidth: 0.5,
        dashArray: [5, 5],
      ),
    );
  }

  FlBorderData _flBorder(ThemeData theme) {
    final borderColor = theme.brightness == Brightness.dark 
      ? BarChartWidgetColors.darkBorder 
      : BarChartWidgetColors.lightBorder;

    return FlBorderData(
      show: false,
      border: Border.all(color: borderColor)
    );
  }

}