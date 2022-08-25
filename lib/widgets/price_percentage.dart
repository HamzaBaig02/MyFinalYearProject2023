import 'package:flutter/material.dart';

import '../models/coin_data.dart';
import '../services/functions.dart';

class PriceAndPercentage extends StatelessWidget {
  final CoinData coinData;


  PriceAndPercentage({required this.coinData});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text('\$${formatNumber(coinData.value)}',
            style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w400
            ),
          ),
          SizedBox(width: 5,),
          Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(15),color: Colors.grey.shade100),
            padding: EdgeInsets.all(4),
            child: Text("${coinData.percentChange.toStringAsFixed(2)}%",
              style: TextStyle(
                fontSize: 14,
                color: percentColor(coinData.percentChange),
              ),),
          ),
        ],),
    );
  }
}