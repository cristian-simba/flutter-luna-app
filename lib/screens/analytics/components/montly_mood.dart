import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:luna/constants/colors.dart';
import 'package:luna/utils/mood_utils.dart';
import 'package:provider/provider.dart';
import 'package:luna/providers/icon_color_provider.dart';

class MonthlyMood extends StatefulWidget {
  final Map<String, int> moodCounts;

  const MonthlyMood({Key? key, required this.moodCounts}) : super(key: key);

  @override
  _MonthlyMoodState createState() => _MonthlyMoodState();
}

class _MonthlyMoodState extends State<MonthlyMood> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  late List<MapEntry<String, int>> _top5Moods;
  late int _total;

  @override
  void initState() {
    super.initState();
    _setupAnimation();
    _processMoodData();
  }

  void _setupAnimation() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _animation = CurvedAnimation(parent: _animationController, curve: Curves.easeInOut);
    _animationController.forward();
  }

  void _processMoodData() {
    final sortedMoods = widget.moodCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    _top5Moods = sortedMoods.take(5).toList();
    _total = _top5Moods.fold(0, (sum, entry) => sum + entry.value);
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

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) => _buildCard(theme, iconColorProvider),
    );
  }

  Widget _buildCard(ThemeData theme, IconColorProvider iconColorProvider) {
    return Opacity(
      opacity: _animation.value,
      child: Card(
        elevation: 0,
        color: theme.brightness == Brightness.dark ? CardColors.darkCard : CardColors.lightCard,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 5),
              const Text(
                'Tus principales emociones del mes',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 10),
              _buildPieChart(iconColorProvider),
              const SizedBox(height: 15),
              _buildLegend(iconColorProvider),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPieChart(IconColorProvider iconColorProvider) {
    return SizedBox(
      height: 150,
      width: double.infinity,
      child: PieChart(
        PieChartData(
          borderData: FlBorderData(show: false),
          sectionsSpace: 0,
          centerSpaceRadius: 0,
          sections: _buildPieChartSections(iconColorProvider),
        ),
      ),
    );
  }

  List<PieChartSectionData> _buildPieChartSections(IconColorProvider iconColorProvider) {
    return List.generate(_top5Moods.length, (index) {
      final mood = _top5Moods[index];
      final color = iconColorProvider.getMoodColor(mood.key);
      return PieChartSectionData(
        color: color,
        value: (mood.value / _total) * 100 * _animation.value,
        radius: 65 * _animation.value,
        showTitle: false,
      );
    });
  }

  Widget _buildLegend(IconColorProvider iconColorProvider) {
    return Column(
      children: [
        _buildLegendRow(0, 3, iconColorProvider),
        _buildLegendRow(3, 5, iconColorProvider),
      ],
    );
  }

  Widget _buildLegendRow(int start, int end, IconColorProvider iconColorProvider) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(end - start, (index) {
        final dataIndex = start + index;
        if (dataIndex >= _top5Moods.length) return Container();
        final mood = _top5Moods[dataIndex];
        final percentage = (mood.value / _total) * 100;
        return _buildLegendItem(mood.key, percentage, iconColorProvider);
      }),
    );
  }

  Widget _buildLegendItem(String mood, double percentage, IconColorProvider iconColorProvider) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
      child: Opacity(
        opacity: _animation.value,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 15,
              height: 15,
              decoration: BoxDecoration(
                color: iconColorProvider.getMoodColor(mood),
                borderRadius: const BorderRadius.all(Radius.circular(3)),
              ),
            ),
            const SizedBox(width: 5),
            SvgPicture.asset(
              getMoodSvg(mood),
              height: 18,
              width: 20,
            ),
            const SizedBox(width: 5),
            Text(
              '${(percentage * _animation.value).toStringAsFixed(1)}%',
              style: const TextStyle(fontSize: 10, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}