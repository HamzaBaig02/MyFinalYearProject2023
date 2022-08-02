import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import '../models/coin_data.dart';
import '../services/crypto_network.dart';

Future<List<FlSpot>> fetchGraphData(CoinDataGraph data)async{
  List<FlSpot> nodes = [];

  nodes =  await CryptoNetwork().getGraphData(coin: data.coinData);

  return nodes;
}

class Graph extends StatefulWidget {
  final CoinData coin;


  Graph(this.coin);

  @override
  _GraphState createState() => _GraphState();
}

class _GraphState extends State<Graph> {
  List<FlSpot> nodes = [];
  bool loading = true;
  void getGraphData(CoinDataGraph coinDataGraph)async{
    nodes =  await compute(fetchGraphData,coinDataGraph);
    setState((){loading = false;});
  }

  void initState() {
    // TODO: implement initState
    getGraphData(CoinDataGraph(widget.coin,"1", "hourly"));
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return loading ? Center(child: CircularProgressIndicator()) : LineChart(
        LineChartData(

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
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              tooltipPadding: EdgeInsets.symmetric(vertical: 5),
              fitInsideHorizontally: true,
              getTooltipItems: (List<LineBarSpot> touchedSpots){
                List<LineTooltipItem> list = [];
                touchedSpots.forEach((element) {
                  String price = element.y.toString();
                  var date = DateTime.fromMillisecondsSinceEpoch(element.x.toInt());
                  date = date.toLocal();
                  String data = "\$$price\n$date";
                  list.add(LineTooltipItem(data, TextStyle(color: Colors.white)));
                });

                return list;
              },
            )
          )
        ));
  }
}

 class CoinDataGraph{
  CoinData coinData;
  String days;
  String interval;

  CoinDataGraph(this.coinData, this.days, this.interval);
}