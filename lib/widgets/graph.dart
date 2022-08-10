import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/rendering.dart';
import '../models/coin_data.dart';
import '../services/crypto_network.dart';

List<FlSpot> smaNodesList = [];

Future<List<FlSpot>> fetchGraphData(CoinDataGraph data) async {
  List<FlSpot> nodes = [];

  nodes = await CryptoNetwork().getGraphData(
      coin: data.coinData, days: data.days, interval: data.interval);

  return nodes;
}

Future<List<FlSpot>> fetchGraphDataSMA(CoinDataGraph data) async {
  List<FlSpot> smaNodes = [];

  smaNodes = await CryptoNetwork().getGraphDataSMA(
      coin: data.coinData,
      smaDays: int.parse(data.days),
      intervalDays: int.parse(data.interval));

  return smaNodes;
}

class Graph extends StatefulWidget {
  final CoinData coin;

  Graph(this.coin);

  @override
  _GraphState createState() => _GraphState();
}

class _GraphState extends State<Graph> {
  List<List<FlSpot>> nodesList = [];
  int nodeIndex = 0;
  int currentSelectedIndex = 0;
  late List<String> names = ["Day", "Week", "Month", "Year"];
  late List<CoinDataGraph> params = [
    CoinDataGraph(widget.coin, "1", "hourly"),
    CoinDataGraph(widget.coin, "7", "daily"),
    CoinDataGraph(widget.coin, "30", "daily"),
    CoinDataGraph(widget.coin, "365", "daily")
  ];

  void getGraphData(List<CoinDataGraph> coinDataGraph) async {
    List list = [];
    for (int i = 0; i < coinDataGraph.length; i++) {
      list.add(compute(fetchGraphData, coinDataGraph[i]));
    }
    for(int i = 0;i < list.length;i++){
      nodesList.add(await list[i]);
    }

    setState((){});
  }
  void getGraphDataSMA(CoinDataGraph coinDataGraph) async {

    smaNodesList = await compute(fetchGraphDataSMA,CoinDataGraph(widget.coin, '200', '30'));
    setState((){});
  }

  void initState() {
    // TODO: implement initState
    super.initState();
    getGraphData(params);
    //getGraphDataSMA(CoinDataGraph(widget.coin, '200', '30'));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Flexible(
            fit: FlexFit.tight,
            flex: 1,
            child: Container(
              child: ListView.builder(
                  itemExtent: 85,
                  scrollDirection: Axis.horizontal,
                  itemCount: 4,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      child: GraphButton(
                          text: names[index],
                          index: index,
                          isSelected: currentSelectedIndex == index,
                          onSelect: () {
                            setState(() {
                              currentSelectedIndex = index;
                              nodeIndex = index;
                            });


                          }),
                    );
                  }),
            )),
        SizedBox(
          height: 18,
        ),
        Flexible(
          flex: 10,
          fit: FlexFit.tight,
          child: nodesList.isEmpty
              ? Center(child: CircularProgressIndicator())
              : PriceGraph(nodesList: nodesList, nodeIndex: nodeIndex, widget: widget),
        ),
      ],
    );
  }
}







class PriceGraph extends StatelessWidget {
  const PriceGraph({
    Key? key,
    required this.nodesList,
    required this.nodeIndex,
    required this.widget,
  }) : super(key: key);

  final List<List<FlSpot>> nodesList;
  final int nodeIndex;
  final Graph widget;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(vertical: 3, horizontal: 5),
        child: LineChart(LineChartData(
            titlesData: FlTitlesData(
              show: false,
            ),
            borderData: FlBorderData(show: false),
            gridData: FlGridData(
              show: false,
            ),
            lineBarsData: [
              LineChartBarData(
                dotData: FlDotData(show: false),
                  spots: nodesList[nodeIndex], colors: [
                nodesList[nodeIndex][0].y < widget.coin.value
                    ? Colors.green.shade300
                    : Colors.red.shade400
              ]),
              //LineChartBarData(spots: smaNodesList,colors: [Colors.purple])
            ],
            lineTouchData: LineTouchData(
                touchTooltipData: LineTouchTooltipData(
              tooltipPadding: EdgeInsets.symmetric(vertical: 5),
              fitInsideHorizontally: true,
              getTooltipItems: (List<LineBarSpot> touchedSpots) {
                List<LineTooltipItem> list = [];
                touchedSpots.forEach((element) {
                  String price = element.y < 0.0001
                      ? (element.y).toStringAsExponential(3)
                      : (element.y).toStringAsFixed(4);
                  var date = DateTime.fromMillisecondsSinceEpoch(
                      element.x.toInt());
                  date = date.toLocal();
                  String data = "\$$price\n$date";
                  list.add(LineTooltipItem(
                      data, TextStyle(color: Colors.white)));
                });

                return list;
              },
            ))

        )),
      );
  }
}

class GraphButton extends StatefulWidget {
  final int index;
  final bool isSelected;
  final VoidCallback onSelect;
  final String text;

  GraphButton(
      {required this.text,
      required this.index,
      required this.isSelected,
      required this.onSelect});

  @override
  State<GraphButton> createState() => _GraphButtonState();
}

class _GraphButtonState extends State<GraphButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onSelect,
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(5),
        margin: EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
            color: widget.isSelected ? Colors.grey : Colors.blueGrey,
            borderRadius: BorderRadius.circular(5)),
        child: Text(
          "${widget.text}",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}

class CoinDataGraph {
  CoinData coinData;
  String days;
  String interval;

  CoinDataGraph(this.coinData, this.days, this.interval);
}
