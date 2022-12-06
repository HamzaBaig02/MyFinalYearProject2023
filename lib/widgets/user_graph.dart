import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/graph_persistant_value.dart';
import '../services/functions.dart';
import 'graph.dart';

class UserGraph extends StatelessWidget {
  const UserGraph({
    Key? key,
    required this.nodesList,
    required this.nodeIndex,
    required this.widget,
    required this.showTooltipIndicatorsAtIndexes,
  }) : super(key: key);

  final List<List<FlSpot>> nodesList;
  final int nodeIndex;
  final Graph widget;
  final bool showTooltipIndicatorsAtIndexes;



  @override
  Widget build(BuildContext context) {
    Map minMax = maxminDot(nodesList[nodeIndex]);
    final List<int> showIndexes =  [minMax['max'],minMax['min']];
    final lineBarsData = [LineChartBarData(
        showingIndicators: showIndexes,
        dotData: FlDotData(checkToShowDot: showDot),
        spots: nodesList[nodeIndex], colors: [
      showTooltipIndicatorsAtIndexes?(nodesList[nodeIndex].first.y < nodesList[nodeIndex].last.y
          ? Colors.green.shade300
          : Colors.red.shade400):Colors.transparent
    ])];

    final tooltipsOnBar = lineBarsData[0];
    var lineTouchTooltipData = LineTouchTooltipData(
                    tooltipBgColor: showTooltipIndicatorsAtIndexes?Colors.blueGrey:Colors.transparent,
                    tooltipPadding: EdgeInsets.all(8),
                    fitInsideVertically: showTooltipIndicatorsAtIndexes?false:true,
                    fitInsideHorizontally: true,
                    getTooltipItems: (List<LineBarSpot> touchedSpots) {
                      List<LineTooltipItem> list = [];
                      touchedSpots.forEach((element) {

                        String price = formatNumber(element.y);

                        var date = DateTime.fromMillisecondsSinceEpoch(
                            element.x.toInt());
                        date = date.toLocal();
                        String formattedDate = DateFormat('yyyy-MM-dd \n kk:mm').format(date);

                        String data = "\$$price\n$formattedDate";

                        showTooltipIndicatorsAtIndexes?data = "\$$price\n$formattedDate":data = "\$$price";

                        list.add(LineTooltipItem(
                            data, TextStyle(fontWeight: FontWeight.w500,color: showTooltipIndicatorsAtIndexes?Colors.white:Colors.grey.shade700,height: 1.5,shadows: showTooltipIndicatorsAtIndexes?[]:[
                          Shadow( // bottomLeft
                              offset: Offset(-1.5, -1.5),
                              color: Colors.white
                          ),
                          Shadow( // bottomRight
                              offset: Offset(1.5, -1.5),
                              color: Colors.white
                          ),
                          Shadow( // topRight
                              offset: Offset(1.5, 1.5),
                              color: Colors.white
                          ),
                          Shadow( // topLeft
                              offset: Offset(-1.5, 1.5),
                              color: Colors.white
                          ),
                        ])));
                      });

                      return list;
                    },
                  );
    var lineTouchTooltipData2 = LineTouchTooltipData(
      tooltipBgColor: showTooltipIndicatorsAtIndexes?Colors.blueGrey:Colors.transparent,
      tooltipPadding: EdgeInsets.all(8),
      fitInsideVertically: showTooltipIndicatorsAtIndexes?false:true,
      fitInsideHorizontally: true,
      getTooltipItems: (List<LineBarSpot> touchedSpots) {
        List<LineTooltipItem> list = [];
        touchedSpots.forEach((element) {

          String price = formatNumber(element.y);
          var date = DateTime.fromMillisecondsSinceEpoch(
              element.x.toInt());
          date = date.toLocal();
          String formattedDate = DateFormat('yyyy-MM-dd \n kk:mm').format(date);

          String data = "\$$price\n$formattedDate";

          showTooltipIndicatorsAtIndexes?data = "\$$price\n$formattedDate":data = "\$$price";

          list.add(LineTooltipItem(
              data, TextStyle(color: showTooltipIndicatorsAtIndexes?Colors.white:Colors.transparent,height: 1.5 )));
        });

        return list;
      },
    );

    return Container(
      padding: EdgeInsets.all(5),
      child: LineChart(
          LineChartData(
              showingTooltipIndicators: showIndexes.map((index) {
                return ShowingTooltipIndicators([
                  LineBarSpot(tooltipsOnBar, lineBarsData.indexOf(tooltipsOnBar),
                      tooltipsOnBar.spots[index]),
                ]);
              }).toList(),
              titlesData: FlTitlesData(
                show: false,

              ),
              borderData: FlBorderData(show: false),
              gridData: FlGridData(
                show: showTooltipIndicatorsAtIndexes?true:false,
              ),
              lineBarsData: lineBarsData,
              lineTouchData: LineTouchData(
                  touchCallback: (FlTouchEvent touchEvent,LineTouchResponse? lineTouch) {
                    if(touchEvent.isInterestedForInteractions)
                      Provider.of<GraphPersistentValue>(context, listen: false).display(false);
                    else
                      Provider.of<GraphPersistentValue>(context, listen: false).display(true);
                  },
                  enabled: showTooltipIndicatorsAtIndexes,
                  touchSpotThreshold: 12,
                  getTouchedSpotIndicator: (LineChartBarData barData, List<int> spotIndexes) {
                    return spotIndexes.map((index) {
                      return TouchedSpotIndicatorData(

                        FlLine(
                          color: showTooltipIndicatorsAtIndexes?barData.colors[0]:Colors.transparent,
                          strokeWidth: 2.3,
                        ),
                        FlDotData(
                          show: true,
                        ),

                      );
                    }).toList();
                  },
                  touchTooltipData: Provider.of<GraphPersistentValue>(context, listen: true).displayPersistent?lineTouchTooltipData:lineTouchTooltipData2,)

          )),
    );
  }
}