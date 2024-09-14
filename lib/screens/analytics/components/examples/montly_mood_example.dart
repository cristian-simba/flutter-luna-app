import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:luna/constants/colors.dart';
import 'package:luna/utils/mood_utils.dart';
import 'package:provider/provider.dart';
import 'package:luna/providers/icon_color_provider.dart';

class MonthlyMoodExample extends StatefulWidget {
  const MonthlyMoodExample({Key? key}) : super(key: key);

  @override
  _MonthlyMoodExampleState createState() => _MonthlyMoodExampleState();
}

class _MonthlyMoodExampleState extends State<MonthlyMoodExample> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  late List<MapEntry<String, int>> _exampleMoods;
  late int _total;

  // Datos de ejemplo
  final Map<String, int> _exampleMoodCounts = {
    'Feliz': 8,
    'Triste': 6,
    'Enojado': 5,
    'Normal': 3,
    'Sorprendido': 1,
  };

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
    _exampleMoods = _exampleMoodCounts.entries.toList();
    _total = _exampleMoods.fold(0, (sum, entry) => sum + entry.value);
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
    
    final cardColor = theme.brightness == Brightness.dark ? CardColors.darkCard : CardColors.lightCard;

    return Opacity(
      opacity: _animation.value,
      child: Card(
        elevation: 0,
        color: cardColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 5),
              _buildChartTitle(),
              const SizedBox(height: 15),
              _buildPieChart(iconColorProvider),
              const SizedBox(height: 15),
              _buildLegend(iconColorProvider),
            ],
          ),
        ),
      ),
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

  Widget _buildPieChart(IconColorProvider iconColorProvider) {
    return SizedBox(
      height: 150,
      width: double.infinity,
      child: Opacity(
      opacity: 0.3, 
      child: PieChart(
        PieChartData(
          borderData: FlBorderData(show: false),
          sectionsSpace: 0,
          centerSpaceRadius: 0,
          sections: _buildPieChartSections(iconColorProvider),
          ),
        ),
      )
    );
  }

  List<PieChartSectionData> _buildPieChartSections(IconColorProvider iconColorProvider) {
    return List.generate(_exampleMoods.length, (index) {
      final mood = _exampleMoods[index];
      final color = iconColorProvider.getMoodColor(mood.key).withOpacity(0.6);
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
        if (dataIndex >= _exampleMoods.length) return Container();
        final mood = _exampleMoods[dataIndex];
        final percentage = (mood.value / _total) * 100;
        return _buildLegendItem(mood.key, percentage, iconColorProvider);
      }),
    );
  }

  Widget _buildLegendItem(String mood, double percentage, IconColorProvider iconColorProvider) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
      child: Opacity(
        opacity: 0.5,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 15,
              height: 15,
              decoration: BoxDecoration(
                color: iconColorProvider.getMoodColor(mood).withOpacity(0.6),
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
