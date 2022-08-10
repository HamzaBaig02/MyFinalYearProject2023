import 'dart:ui';
import 'package:crypto_trainer/screens/sell_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/coin_data.dart';
import '../widgets/graph.dart';
import 'buy_screen.dart';

String formatNumber(double number){
  final formatter = NumberFormat('#,##,000.00');
  NumberFormat formatterBig = NumberFormat.compact();

  return ( number >= 99999?formatterBig.format(number): (number >= 1000 ? formatter.format(
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
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(

      body: SafeArea(
        child: ScrollConfiguration(
          behavior: MyBehavior(),
          child: CustomScrollView(
            slivers: [
              SliverFillRemaining(
                hasScrollBody: false,
                child: Column(
                    children: [
                      Flexible(flex:12,fit:FlexFit.tight,child: CoinDataHeader(widget: widget)),
                      Flexible(flex:9,fit:FlexFit.tight,child: CoinLowHighVolume(widget: widget)),
                      Flexible(flex:65,fit:FlexFit.tight,child: CryptoGraph(widget.coinData)),
                      Flexible(flex:10,fit:FlexFit.tight,child: CryptoPercentages(widget: widget)),
                      SizedBox(height: 5,),
                      Flexible(
                        flex:8,
                        fit: FlexFit.tight,
                        child: BuyButton(widget: widget),
                      )
                    ]
                ),
              )
            ],

          ),
        ),
    ),

    );
  }
}

class BuyButton extends StatelessWidget {
  const BuyButton({
    Key? key,
    required this.widget,
  }) : super(key: key);

  final CryptoDetails widget;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) {
            return Buy(widget.coinData);
          }),
        );
      },
      child: Container(
        alignment: Alignment.center,
        width: double.infinity,
        child: Text("BUY",style: TextStyle(color: Colors.white,fontSize: 25,fontWeight: FontWeight.w300),),
        decoration: BoxDecoration(color: Colors.green.shade300),
      ),);
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
              alignment: Alignment.center,
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
              alignment: Alignment.center,
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
              alignment: Alignment.center,
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
              alignment: Alignment.center,
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

  @override
  Widget build(BuildContext context) {
    return Container(

      padding: EdgeInsets.symmetric(vertical: 5.0,horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
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
              alignment: Alignment.center,
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
              alignment: Alignment.centerRight,
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

class CoinDataHeader extends StatelessWidget {
  CoinDataHeader({
    Key? key,
    required this.widget,
  }) : super(key: key);

  final CryptoDetails widget;

  @override
  Widget build(BuildContext context) {
    return Container(
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
                  fontSize: 18,
                  fontWeight: FontWeight.w500
                ),
                ),
                Text(widget.coinData.symbol.toUpperCase(),
                style: TextStyle(
                  fontSize: 12,
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
                    fontSize: 20,
                    fontWeight: FontWeight.w400
                ),
              ),
                Text("${widget.coinData.percentChange.toStringAsFixed(2)}%",
                  style: TextStyle(
                      fontSize: 14,
                      color: percentColor(widget.coinData.percentChange),
                  ),),
            ],),
          )
        ],
      ),
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