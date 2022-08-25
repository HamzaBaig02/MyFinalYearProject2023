

import 'package:flutter/material.dart';

import '../models/coin_data.dart';
import '../services/functions.dart';

class CoinLowHighVolume extends StatelessWidget {

  final CoinData coinData;


  CoinLowHighVolume({required this.coinData});

  @override
  Widget build(BuildContext context) {
    return Container(

      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Row(
        children: [
          Flexible(
            fit: FlexFit.tight,
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("24hr Low",
                    style: TextStyle(
                      color: Colors.grey,
                    ),),
                  SizedBox(height: 5,),
                  Text("${'\$${formatNumber(coinData.low_24h)}'}",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400
                    ),),
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
                  Text("24hr High",style: TextStyle(color: Colors.grey),),
                  SizedBox(height: 5,),
                  Text('\$${formatNumber(coinData.high_24h)}',
                    style: TextStyle(fontSize: 16,fontWeight: FontWeight.w400),),
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
                  Text("24hr Vol",
                    style: TextStyle(color: Colors.grey),),
                  SizedBox(height: 5,),
                  Text("\$${formatNumber(coinData.total_volume)}",
                    style: TextStyle(fontSize: 16,fontWeight: FontWeight.w400),),
                ],
              ),
            ),
          ),

        ],
      ),
    );
  }
}