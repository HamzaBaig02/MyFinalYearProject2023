import 'dart:ui';
import 'package:crypto_trainer/services/crypto_network.dart';
import 'package:crypto_trainer/widgets/expandable_widget.dart';
import 'package:crypto_trainer/widgets/performance_indicator_tile.dart';
import 'package:crypto_trainer/widgets/performance_indicators.dart';
import 'package:crypto_trainer/widgets/web_scrap_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:expandable/expandable.dart';
import '../models/coin_data.dart';
import '../services/functions.dart';
import '../widgets/coin_low_high_volume.dart';
import '../widgets/coing_image_name.dart';
import '../widgets/crypto_percentages.dart';
import '../widgets/graph.dart';
import '../widgets/price_percentage.dart';
import 'buy_screen.dart';


Future<Map<String,String>> fetchData(CoinData coin) async {
  CryptoNetwork myNetwork = CryptoNetwork();
  return await myNetwork.getPerformanceIndicators(coin: coin);
}



class CryptoDetails extends StatefulWidget {
  CoinData coinData;
  CryptoDetails(this.coinData);

  @override
  _CryptoDetailsState createState() => _CryptoDetailsState();
}

class _CryptoDetailsState extends State<CryptoDetails> {

  Map<String,String> performanceIndicators = {};

  void getData()async{

    performanceIndicators = await compute(fetchData,widget.coinData);

    setState(() {});

  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();

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
                        Flexible(flex:12,fit:FlexFit.tight,child: CoinImageAndName(coinData: widget.coinData,)),
                        Flexible(fit: FlexFit.tight, flex: 8, child: PriceAndPercentage(coinData: widget.coinData,),),
                        Flexible(flex:9,fit:FlexFit.tight,child: CoinLowHighVolume(coinData: widget.coinData,)),
                        Flexible(flex:65,fit:FlexFit.tight,child: CryptoGraph(widget.coinData)),
                        Flexible(flex:9,fit:FlexFit.tight,child: CryptoPercentages(coinData: widget.coinData,)),
                        ExpandableWidget(title: 'Price Prediction', expanded: WebScrapTile(widget.coinData)),
                        SizedBox(height: 5,),
                        ExpandableWidget(title:'Performance Indicators',expanded: PerformanceIndicators(performanceIndicators: performanceIndicators,),)

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







class CryptoGraph extends StatelessWidget {
  final CoinData coin;

  CryptoGraph(this.coin);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      padding: EdgeInsets.symmetric(vertical: 5.0,),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: Graph(coin),
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