import 'package:crypto_trainer/constants/colors.dart';
import 'package:floating_action_bubble/floating_action_bubble.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:showcaseview/showcaseview.dart';

import '../constants/showcase_keys.dart';
import '../models/coin_data.dart';
import '../services/coin_information_stats.dart';
import '../services/functions.dart';
import '../widgets/coin_image_name.dart';
import '../widgets/coin_low_high_volume.dart';
import '../widgets/community_sentiment_bar.dart';
import '../widgets/crypto_graph_dimensions.dart';
import '../widgets/crypto_menu_bottom_sheet.dart';
import '../widgets/crypto_percentages.dart';
import '../widgets/custom_showcase.dart';
import '../widgets/news_list.dart';
import '../widgets/price_percentage.dart';
import 'buy_screen.dart';
import 'crypto_detail_screen.dart';



class CoinDetailsShowCase extends StatefulWidget {
  CoinData coinData;
  CoinDetailsShowCase(this.coinData);
  @override
  _CoinDetailsShowCaseState createState() => _CoinDetailsShowCaseState();
}

class _CoinDetailsShowCaseState extends State<CoinDetailsShowCase> with TickerProviderStateMixin{

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

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(Duration(milliseconds: 1000));
      ShowCaseWidget.of(context).startShowCase([
        cryptoDetailsPriceAndPercentKey,
        coinDetails24hrLowHighVolKey,
        // coinDetails24hrHighKey,
        // coinDetails24hrVolKey,
        cryptoDetailsGraphKey,
        cryptoDetailsPercentagesKey,
        cryptoDetailsSentimentKey,
        cryptoDetailsNewsKey,
        cryptoDetailsFloatingButtonKey
      ]);
    });

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,

      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton:  Stack(
        children: [
          FloatingActionBubble(

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
          Positioned(
            bottom: 1,
              right: 1,
              child: CustomShowCase(
                refKey: cryptoDetailsFloatingButtonKey,
                description: showCaseDescriptions['cryptoDetailsFloatingButton'].toString(),
                disposeOnTap: true,
                onTargetClick: () => _animationController.isCompleted
                    ? _animationController.reverse()
                    : _animationController.forward(),
                child: ClipOval(

                    child: IgnorePointer(child: Container(height: 53,width: 53,color: Colors.transparent,))),
              ))
      ]),

      body: SafeArea(
        child: Container(
          color: Colors.grey.shade200,
          padding: EdgeInsets.symmetric(horizontal: 5,vertical: 5),
          child: SingleChildScrollView(
            child:
              Wrap(
                  runSpacing: 8,
                  children: [
                    Material(
                      elevation: 1.75,
                      borderRadius:BorderRadius.circular(10),
                      color: Colors.white,
                      child: Container(
                        padding: EdgeInsets.all(5),

                        child: Column(
                          children: [
                            CoinImageAndName(coinData: widget.coinData,),
                            SizedBox(height: 5,),
                            CustomShowCase(
                              refKey: cryptoDetailsPriceAndPercentKey,
                                description: showCaseDescriptions['cryptoDetailsPriceAndPercent'].toString(),
                                child: PriceAndPercentage(coinData: widget.coinData,)),
                            SizedBox(height: 5,),
                            CustomShowCase(
                              refKey: coinDetails24hrLowHighVolKey,
                                description: showCaseDescriptions['coinDetails24hrLowHighVol'].toString(),
                                child: CoinLowHighVolume(coinData: widget.coinData,))
                          ],
                        ),
                      ),
                    ),

                    Material(
                      elevation: 1.5,
                      borderRadius:BorderRadius.circular(10),
                      color: Colors.white,
                      child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 5,vertical: 10),
                          child: Column(
                            children: [
                              CustomShowCase(
                                refKey: cryptoDetailsGraphKey,
                                  description: showCaseDescriptions['cryptoDetailsGraph'].toString(),
                                  child: CryptoGraph(widget.coinData)),
                              SizedBox(height: 5,),
                              CustomShowCase(
                                  refKey: cryptoDetailsPercentagesKey,
                                  description: showCaseDescriptions['cryptoDetailsPercentages'].toString(),
                                  child: CryptoPercentages(coinData: widget.coinData,))
                            ],
                          )),
                    ),

                    Material(
                      elevation: 1.5,
                      borderRadius:BorderRadius.circular(10),
                      color: Colors.white,
                      child: Container(
                        padding: EdgeInsets.all(5),
                        child: GestureDetector(
                            onDoubleTap: (){
                              print("Sentiment Button Pressed");
                              compute(getCoinSentiment,widget.coinData.id);
                            },
                            child: CustomShowCase(
                              refKey: cryptoDetailsSentimentKey,
                                description: showCaseDescriptions['cryptoDetailsSentiment'].toString(),
                                child: CommunitySentimentBar(pos:doubleNullCheck(coinDetails['sentiment_votes_up_percentage']), neg: doubleNullCheck(coinDetails['sentiment_votes_down_percentage'])))),
                      ),
                    ),
                    Material(
                      elevation: 1.5,
                      borderRadius:BorderRadius.circular(10),
                      color: Colors.white,
                      child: CustomShowCase(
                        refKey: cryptoDetailsNewsKey,
                        description: showCaseDescriptions['cryptoDetailsNews'].toString(),
                        child: Container(
                            padding: EdgeInsets.all(5),
                            child: NewsList(widget.coinData)),
                      ),
                    ),



                  ]

              )

          ),
        ),
      ),

    );
  }
}

