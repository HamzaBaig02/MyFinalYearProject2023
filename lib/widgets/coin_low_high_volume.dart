

import 'package:crypto_trainer/constants/showcase_keys.dart';
import 'package:crypto_trainer/widgets/custom_showcase.dart';
import 'package:flutter/material.dart';

import '../models/coin_data.dart';
import '../services/functions.dart';

class CoinLowHighVolume extends StatelessWidget {

  final CoinData coinData;


  CoinLowHighVolume({required this.coinData});


  @override
  Widget build(BuildContext context) {

    double fontSize = getFontSize(context, 2.3);

    return Container(

      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Row(
        children: [
          Flexible(
            fit: FlexFit.tight,
            child: CoinLowHighVolTile(label: "24hr Low",data: coinData.low_24h, fontSize: fontSize),
          ),
          Flexible(
            fit: FlexFit.tight,
            child: CoinLowHighVolTile(label: "24hr High",data: coinData.high_24h, fontSize: fontSize),
          ),
          Flexible(
            fit: FlexFit.tight,
            child: CoinLowHighVolTile(label: "24hr Vol",data: coinData.total_volume, fontSize: fontSize),
          ),


        ],
      ),
    );
  }
}

class CoinLowHighVolTile extends StatelessWidget {

  final String label;
  final double data;
  final double fontSize;


  CoinLowHighVolTile({required this.label, required this.data, required this.fontSize});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
            style: TextStyle(
              color: Colors.grey,
            ),),
          SizedBox(height: 5,),
          Text("${'\$${formatNumber(data)}'}",
            style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.w400
            ),),
        ],
      ),
    );
  }
}