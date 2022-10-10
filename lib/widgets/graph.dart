import 'package:crypto_trainer/models/graph_persistant_value.dart';
import 'package:crypto_trainer/widgets/price_graph.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import '../models/coin_data.dart';
import '../models/coin_graph_data.dart';
import '../services/crypto_network.dart';
import 'graph_button.dart';

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
  bool enableTouch = false;
  late List<String> names = ["Day", "Week", "Month", "Year"];
  late List<CoinDataGraph> params = [
    CoinDataGraph(widget.coin, "1", "hourly"),
    CoinDataGraph(widget.coin, "365", "daily")
  ];

  void getGraphData(List<CoinDataGraph> coinDataGraph) async {
    List<List<FlSpot>> list = [];
    List<int> days = [7,30,365];

    for (int i = 0; i < coinDataGraph.length; i++) {
      list.add( await compute(fetchGraphData, coinDataGraph[i]));
    }

    nodesList.add(list[0]); // getting hourly graphy data for one day

    //using the year data to get weekly,monthly,yearly data
    var x = list[1];

    if(mounted){
      setState((){

        for(int i = 0;i < days.length;i++){
          nodesList.add(x.sublist(x.length - days[i],x.length));
        }

      });
    }

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
              : ChangeNotifierProvider(
                create:(context)=>GraphPersistentValue(displayPersistent: true),
                child: Stack(children: [

                  PriceGraph(showTooltipIndicatorsAtIndexes: true,nodesList: nodesList, nodeIndex: nodeIndex, widget: widget),
                  IgnorePointer(child: PriceGraph(showTooltipIndicatorsAtIndexes: false,nodesList: nodesList, nodeIndex: nodeIndex, widget: widget),),

          ],),
              ),
        ),
      ],
    );
  }
}





