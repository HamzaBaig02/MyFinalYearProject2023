import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/rendering.dart';
import '../models/coin_data.dart';
import '../services/crypto_network.dart';


Color color = Colors.blueGrey;



Future<List<FlSpot>> fetchGraphData(CoinDataGraph data)async{
  List<FlSpot> nodes = [];

  nodes =  await CryptoNetwork().getGraphData(coin: data.coinData,days: data.days,interval: data.interval);


  return nodes;
}
Future<List<FlSpot>> fetchGraphDataSMA(CoinDataGraph data)async{
  List<FlSpot> smaNodes = [];

  smaNodes = await CryptoNetwork().getGraphDataSMA(coin: data.coinData, smaDays: int.parse(data.days), intervalDays: int.parse(data.interval));

  return smaNodes;
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

  int currentSelectedIndex = 0;
  late List<String> names  = ["Day","Week","Month","Year"];
  late List<CoinDataGraph> params = [CoinDataGraph(widget.coin,"1", "hourly"),CoinDataGraph(widget.coin,"7", "daily"),CoinDataGraph(widget.coin,"30", "daily"),CoinDataGraph(widget.coin,"365", "daily")];
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Flexible(
          fit: FlexFit.tight,
          flex: 1,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 4,
              itemBuilder: (context,index){
            return GestureDetector(
              child: GraphButton(
                text: names[index],
                  index: index,
                  isSelected: currentSelectedIndex == index,
                  onSelect: () {
                    setState(() {
                      currentSelectedIndex = index;
                      loading = true;
                      getGraphData(params[index]);
                    });
                  }
              ),
            );
          })
        ),
        SizedBox(height: 18,),
        Flexible(
          flex: 10,
          fit: FlexFit.tight,
          child: loading ? Center(child: CircularProgressIndicator()) : LineChart(
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
                        String price = element.y  < 0.0001 ? (element.y).toStringAsExponential(3) : (element.y).toStringAsFixed(4);
                        var date = DateTime.fromMillisecondsSinceEpoch(element.x.toInt());
                        date = date.toLocal();
                        String data = "\$$price\n$date";
                        list.add(LineTooltipItem(data, TextStyle(color: Colors.white)));
                      });

                      return list;
                    },
                  )
                )
              )),
        ),
      ],
    );
  }
}

class GraphButton extends StatefulWidget {
  final int index;
  final bool isSelected;
  final VoidCallback onSelect;
  final String text;


  GraphButton({required this.text,required this.index, required this.isSelected, required this.onSelect});

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
        width: 55,
        margin: EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(color: widget.isSelected?Colors.grey:Colors.blueGrey,borderRadius: BorderRadius.circular(5)),
        child: Text("${widget.text}",style: TextStyle(color: Colors.white),),

      ),
    );
  }
}



 class CoinDataGraph{
  CoinData coinData;
  String days;
  String interval;

  CoinDataGraph(this.coinData, this.days, this.interval);
}

