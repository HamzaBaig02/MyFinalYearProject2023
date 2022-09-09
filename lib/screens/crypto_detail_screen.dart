import 'dart:convert';
import 'dart:ui';
import 'package:crypto_trainer/services/crypto_network.dart';
import 'package:crypto_trainer/services/functions.dart';
import 'package:crypto_trainer/widgets/community_sentiment_bar.dart';
import 'package:crypto_trainer/widgets/expandable_widget.dart';
import 'package:crypto_trainer/widgets/performance_indicators.dart';
import 'package:crypto_trainer/widgets/web_scrap_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../models/coin_data.dart';
import '../services/network.dart';
import '../widgets/coin_low_high_volume.dart';
import '../widgets/coin_image_name.dart';
import '../widgets/crypto_percentages.dart';
import '../widgets/graph.dart';
import '../widgets/price_percentage.dart';
import 'buy_screen.dart';


Future<Map<String,String>> fetchData(CoinData coin) async {
  CryptoNetwork myNetwork = CryptoNetwork();
  return await myNetwork.getPerformanceIndicators(coin: coin);
}

Future<Map<String,dynamic>> fetchCoinDetails(CoinData coin) async {
  Uri url =  Uri.parse("https://api.coingecko.com/api/v3/coins/${coin.id}?localization=false&tickers=false&market_data=true&community_data=true&developer_data=true");
  Network myNetwork = Network(url,{});
   Map<String,dynamic> data = jsonDecode(await myNetwork.getData()) as Map<String,dynamic>;
   return data;
}



class CryptoDetails extends StatefulWidget {
  CoinData coinData;
  CryptoDetails(this.coinData);

  @override
  _CryptoDetailsState createState() => _CryptoDetailsState();
}

class _CryptoDetailsState extends State<CryptoDetails> {

  Map<String,String> performanceIndicators = {};
  Map<String,dynamic> coinDetails = {};

  void getData()async{
    List list = [];
    list.add(compute(fetchData,widget.coinData));
    list.add(compute(fetchCoinDetails,widget.coinData));
    performanceIndicators = await list[0] ?? {};
    coinDetails = await list[1] ?? {};
    print(coinDetails);
    if(mounted){
      setState(() {});
    }


  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();

  }

  Widget build(BuildContext context) {



    return Scaffold(
      backgroundColor: Colors.white,
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
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 5),
          child: ScrollConfiguration(
            behavior: MyBehavior(),
            child: CustomScrollView(
              slivers: [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        CoinImageAndName(coinData: widget.coinData,),
                        PriceAndPercentage(coinData: widget.coinData,),
                        CoinLowHighVolume(coinData: widget.coinData,),
                        CryptoGraph(widget.coinData),
                        CryptoPercentages(coinData: widget.coinData,),
                        CommunitySentimentBar(pos:doubleNullCheck(coinDetails['sentiment_votes_up_percentage']), neg: doubleNullCheck(coinDetails['sentiment_votes_down_percentage'])),
                        ExpandableWidget(title: 'Price Prediction', expanded: WebScrapTile(widget.coinData)),
                        ExpandableWidget(title:'Performance Indicators',expanded: PerformanceIndicators(performanceIndicators: performanceIndicators,),),


                      ]
                  ),
                )
              ],

            ),
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
      height: MediaQuery.of(context).size.height * 0.55,
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