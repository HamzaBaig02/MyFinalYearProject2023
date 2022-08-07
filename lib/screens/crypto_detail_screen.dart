import 'dart:ui';
import 'package:fl_chart/fl_chart.dart';
import 'package:crypto_trainer/services/crypto_network.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/coin_data.dart';
import '../widgets/graph.dart';

String formatNumber(double number){
  final formatter = NumberFormat('#,##,000.00');
  NumberFormat formatterBig = NumberFormat.compact();

  return ( number >= 1000000?formatterBig.format(number): (number >= 1000 ? formatter.format(
    number) : (number<0.0001?number.toStringAsExponential(4):number.toStringAsFixed(4)).toString()));
}
Color percentColor(double number){
  return number < 0 ? Colors.red : Colors.green;
}


class CryptoDetails extends StatefulWidget {
  CoinData coinData;
  CryptoDetails(this.coinData);

  @override
  _CryptoDetailsState createState() => _CryptoDetailsState();
}

class _CryptoDetailsState extends State<CryptoDetails> {

  Widget build(BuildContext context) {
    return Scaffold(

      body: SafeArea(
        child: Column(
          children: [
            CoinDataHeader(widget: widget),
            CoinLowHighVolume(widget: widget),
            CryptoGraph(widget.coinData),
            CryptoPercentages(widget: widget),
            ]
      ),
    ),

    );
  }
}

class CryptoPercentages extends StatelessWidget {
  const CryptoPercentages({
    Key? key,
    required this.widget,

  }) : super(key: key);

  final CryptoDetails widget;


  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(5.0),
      padding: EdgeInsets.symmetric(vertical: 5.0,horizontal: 10.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10)
      ),
      child: Row(

        children: [
          Flexible(
            fit: FlexFit.tight,
            child: Container(
              alignment: Alignment.center,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Day",style: TextStyle(color: Colors.grey),),
                  SizedBox(height: 5,),
                  Text("${widget.coinData.percentChange.toStringAsFixed(2)}%",style: TextStyle(color: percentColor(widget.coinData.percentChange),fontSize: 20),),
                ],
              ),
            ),
          ),
          Flexible(
            fit: FlexFit.tight,
            child: Container(
              alignment: Alignment.center,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Week",style: TextStyle(color: Colors.grey),),
                  SizedBox(height: 5,),
                  widget.coinData.percentChange7d == 0 ? Text("N/A",style: TextStyle(color: Colors.grey,fontSize: 20),):
                  Text("${widget.coinData.percentChange7d.toStringAsFixed(2)}%",style: TextStyle(color: percentColor(widget.coinData.percentChange7d),fontSize: 20),),
                ],
              ),
            ),
          ),
          Flexible(
            fit: FlexFit.tight,
            child: Container(
              alignment: Alignment.center,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Month",style: TextStyle(color: Colors.grey),),
                  SizedBox(height: 5,),
                  widget.coinData.percentChange30d == 0 ? Text("N/A",style: TextStyle(color: Colors.grey,fontSize: 20),):
                  Text("${widget.coinData.percentChange30d.toStringAsFixed(2)}%",style: TextStyle(color: percentColor(widget.coinData.percentChange30d),fontSize: 20),),
                ],
              ),
            ),
          ),
          Flexible(
            fit: FlexFit.tight,
            child: Container(
              alignment: Alignment.center,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Year",style: TextStyle(color: Colors.grey),),
                  SizedBox(height: 5,),
                  widget.coinData.percentChange1y == 0 ? Text("N/A",style: TextStyle(color: Colors.grey,fontSize: 20),):
                  Text("${widget.coinData.percentChange1y.toStringAsFixed(2)}%",style: TextStyle(color: percentColor(widget.coinData.percentChange1y),fontSize: 20),),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CryptoGraph extends StatelessWidget {
  final CoinData coin;

  CryptoGraph(this.coin);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,

      margin: EdgeInsets.symmetric(vertical: 0,horizontal: 5),
      padding: EdgeInsets.symmetric(vertical: 10.0,horizontal: 10.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: Graph(coin),
    );
  }
}

class CoinLowHighVolume extends StatelessWidget {
  CoinLowHighVolume({
    Key? key,
    required this.widget,
  }) : super(key: key);

  final CryptoDetails widget;
  NumberFormat formatterVolume = NumberFormat.compact();
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(5.0),
      padding: EdgeInsets.symmetric(vertical: 5.0,horizontal: 10.0),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10)
      ),
      child: Row(

        children: [
          Flexible(
            fit: FlexFit.tight,
            child: Container(
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("24hr Low",
                  style: TextStyle(
                    color: Colors.grey,
                  ),),
                  SizedBox(height: 5,),
                  Text("${'\$${formatNumber(widget.coinData.low_24h)}'}",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w400
                  ),),
                ],
              ),
            ),
          ),
          Flexible(
            fit: FlexFit.tight,
            child: Container(
              alignment: Alignment.center,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("24hr High",style: TextStyle(color: Colors.grey),),
                  SizedBox(height: 5,),
                  Text('\$${formatNumber(widget.coinData.high_24h)}',
                  style: TextStyle(fontSize: 22,fontWeight: FontWeight.w400),),
                ],
              ),
            ),
          ),
          Flexible(
            fit: FlexFit.tight,
            child: Container(
              alignment: Alignment.centerRight,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("24hr Vol",
                  style: TextStyle(color: Colors.grey),),
                  SizedBox(height: 5,),
                  Text("\$${widget.coinData.total_volume>1000?formatterVolume.format(widget.coinData.total_volume):widget.coinData.total_volume}",
                    style: TextStyle(fontSize: 22,fontWeight: FontWeight.w400),),
                ],
              ),
            ),
          ),

        ],
      ),
    );
  }
}

class CoinDataHeader extends StatelessWidget {
  CoinDataHeader({
    Key? key,
    required this.widget,
  }) : super(key: key);

  final CryptoDetails widget;
  final formatter = NumberFormat('#,##,000.00');
  final formatterVolume = NumberFormat.compact();
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(5.0),
      padding: EdgeInsets.symmetric(vertical: 5.0,horizontal: 10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10)
      ),
      child: Row(
        children: [
          CircleAvatar(
            foregroundImage: NetworkImage(widget.coinData.imageUrl),
            radius: 30,
            backgroundColor: Colors.grey.shade100,
          ),
          SizedBox(
            width: 10,
          ),
          Flexible(
            fit: FlexFit.tight,
            flex: 6,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.coinData.name,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w500
                ),
                ),
                Text(widget.coinData.symbol.toUpperCase(),
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey
                ),)
              ],
            ),
          ),
          Flexible(
            fit: FlexFit.tight,
            flex: 5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
              Text('\$${formatNumber(widget.coinData.value)}',
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w400
                ),
              ),
                Text("${widget.coinData.percentChange.toStringAsFixed(2)}%",
                  style: TextStyle(
                      fontSize: 16,
                      color: percentColor(widget.coinData.percentChange),
                  ),),
            ],),
          )
        ],
      ),
    );
  }
}


