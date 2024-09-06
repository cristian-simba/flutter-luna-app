import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class LineChartWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: LineChart(
        LineChartData(
          lineBarsData: [
            LineChartBarData(
              spots: _getSpots(),
              barWidth: 4,
              isStrokeCapRound: true,
              dotData: FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
              ),
            ),
          ],
          minX: 0,
          maxX: 7,
          minY: 0,
          maxY: 10,
        ),
      ),
    );
  }

  List<FlSpot> _getSpots() {
    return [
      FlSpot(0, 4),
      FlSpot(1, 1),
      FlSpot(2, 4),
      FlSpot(3, 7),
      FlSpot(4, 2),
      FlSpot(5, 5),
      FlSpot(6, 8),
      FlSpot(7, 6),
    ];
  }
}
