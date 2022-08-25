
import 'package:crypto_trainer/models/coin_data.dart';

import 'package:flutter/material.dart';

import '../services/functions.dart';

class CryptoPercentages extends StatelessWidget {
  final CoinData coinData;


  CryptoPercentages({required this.coinData});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10)
      ),
      child: Row(

        children: [
          Flexible(
            fit: FlexFit.tight,
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Day",style: TextStyle(color: Colors.grey),),
                  SizedBox(height: 5,),
                  Text("${coinData.percentChange.toStringAsFixed(2)}%",style: TextStyle(color: percentColor(coinData.percentChange),fontSize: 16),),
                ],
              ),
            ),
          ),
          Flexible(
            fit: FlexFit.tight,
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Week",style: TextStyle(color: Colors.grey),),
                  SizedBox(height: 5,),
                  coinData.percentChange7d == 0 ? Text("N/A",style: TextStyle(color: Colors.grey,fontSize: 16),):
                  Text("${coinData.percentChange7d.toStringAsFixed(2)}%",style: TextStyle(color: percentColor(coinData.percentChange7d),fontSize: 16),),
                ],
              ),
            ),
          ),
          Flexible(
            fit: FlexFit.tight,
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Month",style: TextStyle(color: Colors.grey),),
                  SizedBox(height: 5,),
                  coinData.percentChange30d == 0 ? Text("N/A",style: TextStyle(color: Colors.grey,fontSize: 16),):
                  Text("${coinData.percentChange30d.toStringAsFixed(2)}%",style: TextStyle(color: percentColor(coinData.percentChange30d),fontSize: 16),),
                ],
              ),
            ),
          ),
          Flexible(
            fit: FlexFit.tight,
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Year",style: TextStyle(color: Colors.grey),),
                  SizedBox(height: 5,),
                  coinData.percentChange1y == 0 ? Text("N/A",style: TextStyle(color: Colors.grey,fontSize: 16),):
                  Text("${coinData.percentChange1y.toStringAsFixed(2)}%",style: TextStyle(color: percentColor(coinData.percentChange1y),fontSize: 16),),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}