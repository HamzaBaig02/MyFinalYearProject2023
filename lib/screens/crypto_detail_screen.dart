import 'dart:ui';
import 'package:crypto_trainer/widgets/web_scrap_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import '../models/coin_data.dart';
import '../widgets/graph.dart';
import 'buy_screen.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';

String formatNumber(double number){
  var decimals = number.toString().split('.')[1];
  final formatter = NumberFormat('#,##,000.00');
  NumberFormat formatterBig = NumberFormat.compact();
  if(number >= 1000000)
    return formatterBig.format(number);
  else if(number >= 1000)
    return formatter.format(number);
  else if(number >= 0.1)
    return number.toStringAsFixed(2);
  else if(number <= 0.00000001)
    return number.toStringAsExponential();
    else
    return number.toStringAsFixed(7);
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
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xc48b4a6c),
        child: Icon(FontAwesomeIcons.plus),
        onPressed: (){
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) {
              return Buy(widget.coinData);
            }),
          );
        },
      ),
      body: SafeArea(
        child: ScrollConfiguration(
          behavior: MyBehavior(),
          child: CustomScrollView(
            slivers: [
              SliverFillRemaining(
                hasScrollBody: false,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 5.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Flexible(flex:12,fit:FlexFit.tight,child: CoinImageAndName(widget: widget)),
                        Flexible(fit: FlexFit.tight, flex: 8, child: PriceAndPercentage(widget: widget),),
                        Flexible(flex:9,fit:FlexFit.tight,child: CoinLowHighVolume(widget: widget)),
                        Flexible(flex:65,fit:FlexFit.tight,child: CryptoGraph(widget.coinData)),
                        Flexible(flex:9,fit:FlexFit.tight,child: CryptoPercentages(widget: widget)),
                        Flexible(flex:9,fit:FlexFit.tight,child: WebScrapTile(widget.coinData)),

                      ]
                  ),
                ),
              )
            ],

          ),
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
                  Text("${widget.coinData.percentChange.toStringAsFixed(2)}%",style: TextStyle(color: percentColor(widget.coinData.percentChange),fontSize: 16),),
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
                  widget.coinData.percentChange7d == 0 ? Text("N/A",style: TextStyle(color: Colors.grey,fontSize: 16),):
                  Text("${widget.coinData.percentChange7d.toStringAsFixed(2)}%",style: TextStyle(color: percentColor(widget.coinData.percentChange7d),fontSize: 16),),
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
                  widget.coinData.percentChange30d == 0 ? Text("N/A",style: TextStyle(color: Colors.grey,fontSize: 16),):
                  Text("${widget.coinData.percentChange30d.toStringAsFixed(2)}%",style: TextStyle(color: percentColor(widget.coinData.percentChange30d),fontSize: 16),),
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
                  widget.coinData.percentChange1y == 0 ? Text("N/A",style: TextStyle(color: Colors.grey,fontSize: 16),):
                  Text("${widget.coinData.percentChange1y.toStringAsFixed(2)}%",style: TextStyle(color: percentColor(widget.coinData.percentChange1y),fontSize: 16),),
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
      padding: EdgeInsets.symmetric(vertical: 5.0),
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
                  Text("${'\$${formatNumber(widget.coinData.low_24h)}'}",
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
                  Text('\$${formatNumber(widget.coinData.high_24h)}',
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
                  Text("\$${formatNumber(widget.coinData.total_volume)}",
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

class CoinImageAndName extends StatelessWidget {
  CoinImageAndName({
    Key? key,
    required this.widget,
  }) : super(key: key);

  final CryptoDetails widget;

  @override
  Widget build(BuildContext context) {
    return Container(
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(widget.coinData.name,
                style: TextStyle(
                  fontSize: 20,
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

        ],
      ),
    );
  }
}

class PriceAndPercentage extends StatelessWidget {
  const PriceAndPercentage({
    Key? key,
    required this.widget,
  }) : super(key: key);

  final CryptoDetails widget;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
        Text('\$${formatNumber(widget.coinData.value)}',
          style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w400
          ),
        ),
          SizedBox(width: 5,),
          Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(15),color: Colors.grey.shade100),
            padding: EdgeInsets.all(4),
            child: Text("${widget.coinData.percentChange.toStringAsFixed(2)}%",
              style: TextStyle(
                  fontSize: 14,
                  color: percentColor(widget.coinData.percentChange),
              ),),
          ),
      ],),
    );
  }
}



class MyBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}