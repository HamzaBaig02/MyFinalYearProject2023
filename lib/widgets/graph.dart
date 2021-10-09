import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class Graph extends StatelessWidget {
  List<FlSpot> nodes;

  Graph(this.nodes);

  @override
  Widget build(BuildContext context) {
    return LineChart(LineChartData(
      titlesData: FlTitlesData(
        show: false,
      ),
      borderData: FlBorderData(show: false),
      gridData: FlGridData(
        show: false,
      ),
      lineBarsData: [
        LineChartBarData(spots: nodes, colors: [Colors.green.shade300])
      ],
    ));
  }
}
