import 'dart:convert';
import 'dart:ui';
import 'package:crypto_trainer/services/coin_information_stats.dart';
import 'package:crypto_trainer/services/functions.dart';
import 'package:crypto_trainer/widgets/community_sentiment_bar.dart';
import 'package:crypto_trainer/widgets/crypto_menu_bottom_sheet.dart';
import 'package:crypto_trainer/widgets/expandable_widget.dart';
import 'package:crypto_trainer/widgets/news_list.dart';
import 'package:floating_action_bubble/floating_action_bubble.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../models/coin_data.dart';
import '../services/network.dart';
import '../widgets/coin_low_high_volume.dart';
import '../widgets/coin_image_name.dart';
import '../widgets/crypto_graph_dimensions.dart';
import '../widgets/crypto_percentages.dart';
import '../widgets/price_percentage.dart';
import 'buy_screen.dart';




Future<Map<String,dynamic>> fetchCoinDetails(CoinData coin) async {
  Uri url =  Uri.parse("https://api.coingecko.com/api/v3/coins/${coin.id}?localization=false&tickers=false&market_data=true&community_data=true&developer_data=true");
  Network myNetwork = Network(url,{});
   Map<String,dynamic> data = jsonDecode(await myNetwork.getData()) as Map<String,dynamic>;
   return data;
}



class CryptoDetails extends StatefulWidget  {
  CoinData coinData;
  CryptoDetails(this.coinData);

  @override
  _CryptoDetailsState createState() => _CryptoDetailsState();
}

class _CryptoDetailsState extends State<CryptoDetails> with SingleTickerProviderStateMixin{

  Map<String,dynamic> coinDetails = {};
  late Animation<double> _animation;
  late AnimationController _animationController;

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
    Provider.of<CoinInfo>(context,
        listen: false).coinId = widget.coinData.id;
    Provider.of<CoinInfo>(context,
        listen: false).getCoinInfo();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 260),
    );

    final curvedAnimation = CurvedAnimation(curve: Curves.easeInOut, parent: _animationController);
    _animation = Tween<double>(begin: 0, end: 1).animate(curvedAnimation);

  }

  Widget build(BuildContext context) {


    return Scaffold(
      backgroundColor: Colors.white,

      //floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton:  FloatingActionBubble(

        // Menu items
        items: <Bubble>[

          // Floating action menu item
          Bubble(
            title:"Price Prediction",
            iconColor :Colors.white,
            bubbleColor : Color(0xc48b4a6c),
            icon:FontAwesomeIcons.chartLine,
            titleStyle:TextStyle(fontSize: 16 , color: Colors.white),
            onPress: () {
              showModalBottomSheet(context: context, builder: (BuildContext context) {
                return Container(
                  child : CryptoBottomSheet(coin: widget.coinData,name: "Price Prediction",developerData: coinDetails['developer_data'],),
                );

              },backgroundColor: Colors.transparent);
              _animationController.reverse();
            },
          ),
          // Floating action menu item
          Bubble(
            title:"Performance Indicators",
            iconColor :Colors.white,
            bubbleColor : Color(0xc48b4a6c),
            icon:FontAwesomeIcons.calculator,
            titleStyle:TextStyle(fontSize: 16 , color: Colors.white),
            onPress: () {
              showModalBottomSheet(context: context,isScrollControlled: true, builder: (BuildContext context) {
                return Wrap(
                    children:[ CryptoBottomSheet(coin: widget.coinData,name: "Performance Indicators",developerData: coinDetails['developer_data'],)]);

              },backgroundColor: Colors.transparent);
              _animationController.reverse();
            },
          ),
          //Floating action menu item
          Bubble(
            title:"Developer Sentiment",
            iconColor :Colors.white,
            bubbleColor : Color(0xc48b4a6c),
            icon:FontAwesomeIcons.code,
            titleStyle:TextStyle(fontSize: 16 , color: Colors.white),
            onPress: () {
              //Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context) => Homepage()));
              showModalBottomSheet(context: context,isScrollControlled: true, builder: (BuildContext context) {
                return Wrap(children: [CryptoBottomSheet(coin: widget.coinData,name: "Developer Sentiment",developerData: coinDetails['developer_data'],)]);

              },backgroundColor: Colors.transparent);
              _animationController.reverse();

            },
          ),
          Bubble(
            title:"Buy",
            iconColor :Colors.white,
            bubbleColor : Color(0xc48b4a6c),
            icon:FontAwesomeIcons.shoppingCart,
            titleStyle:TextStyle(fontSize: 16 , color: Colors.white),
            onPress: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) {
                  return Buy(widget.coinData);
                }),
              );
              _animationController.reverse();
            },
          ),
        ],

        // animation controller
        animation: _animation,

        // On pressed change animation state
        onPress: () => _animationController.isCompleted
            ? _animationController.reverse()
            : _animationController.forward(),

        // Floating Action button Icon color
        iconColor: Colors.white,

        // Flaoting Action button Icon
        iconData: FontAwesomeIcons.bars,
        backGroundColor: Color(0xa98b4a6c),
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
                        GestureDetector(
                          onDoubleTap: (){
                            print("Sentiment Button Pressed");
                            compute(getCoinSentiment,widget.coinData.id);
                          },
                            child: CommunitySentimentBar(pos:doubleNullCheck(coinDetails['sentiment_votes_up_percentage']), neg: doubleNullCheck(coinDetails['sentiment_votes_down_percentage']))),
                        NewsList(widget.coinData),



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











class MyBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}
