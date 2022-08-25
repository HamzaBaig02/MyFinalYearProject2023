import 'package:crypto_trainer/widgets/performance_indicator_tile.dart';
import 'package:flutter/material.dart';
class PerformanceIndicators extends StatelessWidget {
  final Map<String,String> performanceIndicators;

  PerformanceIndicators({required this.performanceIndicators});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Flexible(fit:FlexFit.tight,child: IndicatorTile('50-Day SMA', performanceIndicators['sma50'].toString())),
          Flexible(fit:FlexFit.tight,child: IndicatorTile('200-Day SMA', performanceIndicators['sma200'].toString())),
          Flexible(fit:FlexFit.tight,child: IndicatorTile('RSI', performanceIndicators['rsi'].toString()))
        ],
      ),
    );
  }
}