import 'package:crypto_trainer/constants/showcase_keys.dart';

import 'package:crypto_trainer/models/user_data.dart';

import 'package:crypto_trainer/services/functions.dart';
import 'package:crypto_trainer/widgets/wallet_tile.dart';
import 'package:crypto_trainer/widgets/wallet_tile_placeholder.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:showcaseview/showcaseview.dart';

import '../constants/colors.dart';
import 'custom_showcase.dart';


class UserInfoCard extends StatefulWidget {
  Function callback;


  UserInfoCard({required this.callback});

  @override
  _UserInfoCardState createState() => _UserInfoCardState();
}

class _UserInfoCardState extends State<UserInfoCard>
    with TickerProviderStateMixin {
  double balance = 0;
  double profit = 0;





  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.fastLinearToSlowEaseIn,
    );
  }

  _toggleContainer() {
    print(_animation.status);
    if (_animation.status != AnimationStatus.completed) {
      _controller.forward();
    } else {
      _controller.animateBack(0, duration: Duration(milliseconds: 500));
    }
  }

  @override
  Widget build(BuildContext context) {
    balance = Provider.of<UserData>(context, listen: true).balance;
    profit = Provider.of<UserData>(context, listen: true).profit;
    //final user = FirebaseAuth.instance.currentUser?? '';
    return Column(
      children: [
        Container(
          height: 205,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            image: DecorationImage(
              fit: BoxFit.fill,
              image: AssetImage('assets/images/cardWavy.png'),
            ),
          ),
          padding: EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text('Welcome',
                      style: GoogleFonts.patuaOne(
                        textStyle: TextStyle(
                            color: Colors.white,
                            letterSpacing: .75,
                            fontSize: getFontSize(context,4)),
                      )),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.65,
                    child: Text(Provider.of<UserData>(context, listen: true).emailID,
                        style: GoogleFonts.patuaOne(

                          textStyle: TextStyle(
                            overflow: TextOverflow.ellipsis,
                              color: Colors.white,
                              letterSpacing: .75,
                              fontSize: MediaQuery.of(context).size.width *0.05),
                        )),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Balance',
                        style: TextStyle(
                            color: Colors.white,
                            letterSpacing: 1,
                            fontSize: getFontSize(context,2.6),
                        fontWeight: FontWeight.w400),
                      ),
                      Text(
                        '\$${formatNumber(balance)}',
                        style: TextStyle(
                            letterSpacing: 1,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: getFontSize(context,3.3)),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Net Profit',
                        style: TextStyle(
                            color: Colors.white,
                            letterSpacing: 1,
                            fontSize: getFontSize(context,2.6),
                            fontWeight: FontWeight.w400),
                      ),
                      Text(
                        '\$${formatNumber(profit)}',
                        style: TextStyle(
                            color: Colors.white,
                            letterSpacing: 1,
                            fontWeight: FontWeight.w500,
                            fontSize: getFontSize(context,3.3),
                      ),
                      )
                    ],
                  )
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [

                  PopupMenuButton(
                    child: Icon(FontAwesomeIcons.ellipsisV,color: Colors.white,),

                    itemBuilder: (context) {
                        return [
                          PopupMenuItem(
                          height: 10,
                          child: GestureDetector(child: Row(
                            children: [
                              Icon(FontAwesomeIcons.rightFromBracket,color: domColor,),
                              SizedBox(width: 10,),
                              Text('Logout',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500),),
                            ],
                          ),
                          onTap:(){
                            print("Logging out...");
                            widget.callback();
                          }
                            ,),),
                          PopupMenuItem(
                            height: 10,
                            child: GestureDetector(child: Text('',style: TextStyle(fontSize: 0),),
                              onTap:(){

                              }
                              ,),),

                          PopupMenuItem(
                            height: 10,
                            onTap: (){
                              print("Showing Tutorial");
                              ShowCaseWidget.of(context).startShowCase([
                                coinTileKey,
                                coinTileValueKey,
                                coinTilePercentageChangeKey,
                                coinTilePercentageChangeKey2,
                                searchBarKey,
                                infoCardKey,
                                walletButtonKey
                              ]);
                            },
                            child: Row(
                              children: [
                                Icon(FontAwesomeIcons.circleInfo,color: domColor,),
                                SizedBox(width: 10,),
                                Text('Tutorial',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500),),
                              ],
                            ),),

                        ];

                    },
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      CustomShowCase(
                        refKey: walletButtonKey,
                        opacity:0.1,
                        description: showCaseDescriptions['walletButton'].toString(),
                        onTargetClick:() {
                          _toggleContainer();
                          Future.delayed(Duration(milliseconds: 500));
                          ShowCaseWidget.of(context).startShowCase([walletKey,walletAmountKey,walletTileKey,assetAmountKey,assetValueKey,assetPercentageChangeKey,coinTileKey2]);
                        } ,
                        disposeOnTap: true,
                        child: MaterialButton(
                          shape: CircleBorder(),
                          onPressed: () {
                            print('Wallet Button Pressed');
                            _toggleContainer();
                          },
                          child: Icon(
                            FontAwesomeIcons.wallet,
                            color: Colors.white,
                          ),
                        ),
                      ),

                    ],
                  ),
                ],
              )
            ],
          ),
        ),
        CryptoWallet(animation: _animation)
      ],
    );
  }
}

class CryptoWallet extends StatelessWidget {
  CryptoWallet({
    Key? key,
    required Animation<double> animation,
  })  : _animation = animation,
        super(key: key);

  final Animation<double> _animation;
  final dollarFormatter = NumberFormat('0,000.00');
  @override
  Widget build(BuildContext context) {
    double moneyInWallet = Provider.of<UserData>(context).amountInWalletUsd;
    return SizeTransition(
      sizeFactor: _animation,
      axis: Axis.vertical,
      axisAlignment: -1,
      child: Provider.of<UserData>(context).wallet.isNotEmpty?Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
        ),
        height: 170,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Wallet',
                  style: GoogleFonts.patuaOne(
                    textStyle: TextStyle(
                        color: Color(0xff8b4a6c),
                        letterSpacing: 3,
                        fontSize: 35,
                        fontWeight: FontWeight.w700),
                  ),
                ),
                Text(
                  '\$${moneyInWallet >= 1000 ? dollarFormatter.format(moneyInWallet) : (moneyInWallet).toStringAsFixed(2)}',
                  style: GoogleFonts.patuaOne(
                    textStyle: TextStyle(
                        color: Color(0xff8b4a6c),
                        letterSpacing: 1,
                        fontSize: 25,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
            Container(
              height: 120,
              child: ListView.builder(
                physics: BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return WalletTile(Provider.of<UserData>(context, listen: true)
                      .wallet[index]);
                },
                itemCount:
                    Provider.of<UserData>(context, listen: true).wallet.length,
              ),
            ),
          ],
        ),
      ):CustomShowCase(
        refKey: walletKey,
        description: showCaseDescriptions['wallet'].toString(),
        opacity: 0.1,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Wallet',
                  style: GoogleFonts.patuaOne(
                    textStyle: TextStyle(
                        color: Color(0xff8b4a6c),
                        letterSpacing: 3,
                        fontSize: 35,
                        fontWeight: FontWeight.w700),
                  ),
                ),
                CustomShowCase(
                  refKey: walletAmountKey,
                  description: showCaseDescriptions['walletAmount'].toString(),
                  child: Text(
                    '\$${1191.28+16511.61}',
                    style: GoogleFonts.patuaOne(
                      textStyle: TextStyle(
                          color: Color(0xff8b4a6c),
                          letterSpacing: 1,
                          fontSize: 25,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Lottie.asset('assets/images/wallet.json',height: 100),
                // SizedBox(width: 4,),
                WalletTilePlaceHolderShowCase('BTC','16511.61','https://assets.coingecko.com/coins/images/1/large/bitcoin.png?1547033579'),
                WalletTilePlaceHolder('ETH','1191.28','https://assets.coingecko.com/coins/images/279/large/ethereum.png?1595348880'),
                SizedBox(width: 4,),
                Text('Buy Crypto \nTo Get Started!',
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width*0.05, fontWeight: FontWeight.bold,color: Colors.grey.shade400)),

              ],
            ),
          ],
        ),
      ),
    );
  }
}


