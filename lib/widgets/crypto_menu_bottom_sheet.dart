import 'package:crypto_trainer/widgets/performance_indicators.dart';
import 'package:crypto_trainer/widgets/web_scrap_widget.dart';
import 'package:flutter/material.dart';

import '../models/coin_data.dart';
import '../services/functions.dart';

class CryptoBottomSheet extends StatelessWidget {
  String name;
  CoinData coin;
  CryptoBottomSheet({required this.name,required this.coin});

    menuWidget<Widget>(String name){
    if(name == 'Price Prediction')
      return WebScrapTile(coin);
    else if(name == 'Performance Indicators')
      return PerformanceIndicators(coin: coin);
    else
      return Container(child: Text("Work In-Progress"),);
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      child:Column(
        children: [
          Text(name,style: TextStyle(fontSize: getFontSize(context, 2.7),letterSpacing:1),),
          menuWidget(name)
        ],
      )

    );
  }
}
