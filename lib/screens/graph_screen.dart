import 'package:crypto_trainer/screens/homepage.dart';
import 'package:crypto_trainer/widgets/graph.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class GraphScreen extends StatelessWidget {
  List<FlSpot> nodes;

  GraphScreen(this.nodes);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => true,
      child: Scaffold(
        body: Center(
          child: Container(
            color: Colors.grey.shade100,
            padding: EdgeInsets.all(10),
            height: 300,
            width: 400,
            child: Graph(nodes),
          ),
        ),
      ),
    );
  }
}
