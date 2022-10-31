import 'dart:convert';
import 'dart:ui';
import 'package:crypto_trainer/services/crypto_network.dart';
import 'package:crypto_trainer/services/functions.dart';
import 'package:crypto_trainer/widgets/community_sentiment_bar.dart';
import 'package:crypto_trainer/widgets/crypto_menu_bottom_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../models/coin_data.dart';
import '../services/network.dart';
import '../widgets/coin_low_high_volume.dart';
import '../widgets/coin_image_name.dart';
import '../widgets/crypto_graph_dimensions.dart';
import '../widgets/crypto_percentages.dart';
import '../widgets/graph.dart';
import '../widgets/price_percentage.dart';
import 'buy_screen.dart';



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


  Map<String,dynamic> coinDetails = {};

  void getData()async{
    coinDetails = await compute(fetchCoinDetails,widget.coinData) ?? {};
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
          padding: EdgeInsets.symmetric(horizontal: 5,vertical: 5),
          child: ScrollConfiguration(
            behavior: MyBehavior(),
            child: CustomScrollView(
              slivers: [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Wrap(
                    runSpacing: 5,
                      children: [
                        CoinImageAndName(coinData: widget.coinData,),
                        PriceAndPercentage(coinData: widget.coinData,),
                        CoinLowHighVolume(coinData: widget.coinData,),
                        CryptoGraph(widget.coinData),
                        CryptoPercentages(coinData: widget.coinData,),
                        CommunitySentimentBar(pos:doubleNullCheck(coinDetails['sentiment_votes_up_percentage']), neg: doubleNullCheck(coinDetails['sentiment_votes_down_percentage'])),
                        Wrap(
                          spacing: 10,
                          children: [
                          CryptoMenuButton(text: 'Price Prediction',icon: FontAwesomeIcons.chartLine,coin: widget.coinData,),
                            CryptoMenuButton(text: 'Performance Indicators',icon: FontAwesomeIcons.calculator,coin: widget.coinData,),
                            CryptoMenuButton(text: 'Developer Sentiment',icon: FontAwesomeIcons.code,coin: widget.coinData,),
                            //CryptoMenuButton(text: 'About Coin',icon: FontAwesomeIcons.infoCircle,coin: widget.coinData,)
                        ],)
                        //ExpandableWidget(title: 'Price Prediction', expanded: WebScrapTile(widget.coinData)),
                        //ExpandableWidget(title:'Performance Indicators',expanded: PerformanceIndicators(performanceIndicators: performanceIndicators,),),


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

class CryptoMenuButton extends StatelessWidget {
 final String text;
 final IconData icon;
 final CoinData coin;


 CryptoMenuButton({required this.text, required this.icon, required this.coin});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      width: width*0.25,
      height: width*0.20,
      padding: EdgeInsets.all(2),
      margin: EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey.shade300,
      ),
      child : GestureDetector(
        onTap: (){
          showModalBottomSheet(context: context, builder: (BuildContext context) {
            return Container(
              child: CryptoBottomSheet(coin: coin,name: text,),
            );

        });
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
          Icon(icon,color: Colors.black,size: 20,),
          SizedBox(height: 8,),
          Text(text,style: TextStyle(color: Colors.black87),textAlign: TextAlign.center,)
        ],),
      )
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