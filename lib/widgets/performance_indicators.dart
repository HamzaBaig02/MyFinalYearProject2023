import 'package:crypto_trainer/widgets/performance_indicator_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

  Map<String,String> performanceIndicators = {};
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
    return Container(
      child: loading?CircularProgressIndicator():Row(
        children: [
          Flexible(fit:FlexFit.tight,child: IndicatorTile('50-Day SMA', performanceIndicators['sma50'].toString())),
          Flexible(fit:FlexFit.tight,child: IndicatorTile('200-Day SMA', performanceIndicators['sma200'].toString())),
          Flexible(fit:FlexFit.tight,child: IndicatorTile('RSI', performanceIndicators['rsi'].toString())),
          Flexible(fit:FlexFit.tight,child: IndicatorTile('20-Day EMA',  performanceIndicators['ema'].toString()))
        ],
      ),
    );
  }
}