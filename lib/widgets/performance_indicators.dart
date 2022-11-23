import 'package:crypto_trainer/widgets/performance_indicator_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/tutorials.dart';
import '../models/coin_data.dart';
import '../services/coin_information_stats.dart';
import '../services/crypto_network.dart';

Future<Map<String,String>> fetchData(CoinData coin) async {
  CryptoNetwork myNetwork = CryptoNetwork();
  return await myNetwork.getPerformanceIndicators(coinId: coin.id);
}

class PerformanceIndicators extends StatefulWidget {
  final CoinData coin;

  PerformanceIndicators({required this.coin});

  @override
  State<PerformanceIndicators> createState() => _PerformanceIndicatorsState();
}

class _PerformanceIndicatorsState extends State<PerformanceIndicators> {
  int currentSelectedIndex = 6;
  List<String> indicatorText = ['','',''];
  Map<String,String> performanceIndicators = {};
  bool isPressed = false;
  void getData()async{
    //performanceIndicators = await compute(fetchData,widget.coin) ?? {};

    setState(() {

    });
}



@override
  void initState() {
    // TODO: implement initState
    super.initState();
    //getData();
  }

  @override
  Widget build(BuildContext context) {

    performanceIndicators = Provider.of<CoinInfo>(context,
        listen: true).performanceIndicators;
    bool loading = Provider.of<CoinInfo>(context, listen: true).loading;
    List tilesInfo = [['50-Day SMA',performanceIndicators['sma50'].toString()],['200-Day SMA', performanceIndicators['sma200'].toString()],['RSI', performanceIndicators['rsi'].toString()],['20-Day EMA',  performanceIndicators['ema'].toString()]];
    List <IndicatorTile> indicatorTiles = List.generate(4, (index) => IndicatorTile(tilesInfo[index][0],tilesInfo[index][1],(){
      setState(() {
        currentSelectedIndex  = index;
        indicatorText = performanceIndicatorAnalyzer(coinName: widget.coin.name,currentPrice: widget.coin.value,indicatorNameIndex: index,indicator: double.parse(tilesInfo[index][1]));
        isPressed = true;
      });

    }, currentSelectedIndex  == index));



    return Container(

      child: loading?Center(child: CircularProgressIndicator()):Column(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 8,
                children: indicatorTiles,
              ),
              SizedBox(height: 10,),
              isPressed ? Center(child: Text('SIGNAL',style: TextStyle(fontWeight: FontWeight.w400,fontSize: 22,),)):Text(''),
              Center(child: Text('${indicatorText[0]}',style: TextStyle(fontWeight: FontWeight.w600,fontSize: 20,color: indicatorText[0] == 'SELL' ? Colors.red : (indicatorText[0] == 'BUY' ? Colors.green : Colors.grey)),)),
              Text('${indicatorText[1]}',style: TextStyle(fontWeight: FontWeight.w500)),
              Text('${indicatorText[2]}'),

            ],
          ),
        ],
      ),
    );
  }
}