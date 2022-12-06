import 'package:crypto_trainer/widgets/developer_sentiment.dart';
import 'package:crypto_trainer/widgets/performance_indicators.dart';
import 'package:crypto_trainer/widgets/web_scrap_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/coin_data.dart';
import '../services/functions.dart';

class CryptoBottomSheet extends StatelessWidget {
  final String name;
  final CoinData coin;
  final Map<String,dynamic> developerData;

  CryptoBottomSheet({required this.name,required this.coin,required this.developerData });

    menuWidget<Widget>(String name){
    if(name == 'Price Prediction')
      return WebScrapTile(coin);
    else if(name == 'Performance Indicators')
      return PerformanceIndicators(coin: coin);
    else if(name == 'Developer Sentiment')
      return DeveloperSentiment(developerData: developerData);
    else
      return Container(child: Text("Work In-Progress"),);
  }


  @override
  Widget build(BuildContext context) {

    return Container(

      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(30),topRight: Radius.circular(30))
      ),
      child:Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(name,style: TextStyle(fontSize: getFontSize(context, 2.7),letterSpacing:1),),
          SizedBox(height: 8,),
          menuWidget(name)
        ],
      )

    );
  }
}
