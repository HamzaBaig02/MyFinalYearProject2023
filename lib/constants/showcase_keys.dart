import 'dart:math';

import 'package:crypto_trainer/constants/colors.dart';
import 'package:flutter/material.dart';


final GlobalKey infoCardKey = GlobalKey();
final GlobalKey coinTileKey = GlobalKey();
final GlobalKey coinTileKey2 = GlobalKey();
final GlobalKey coinTileValueKey = GlobalKey();
final GlobalKey coinTilePercentageChangeKey = GlobalKey();
final GlobalKey coinTilePercentageChangeKey2 = GlobalKey();
final GlobalKey infoCardWalletKey = GlobalKey();
final GlobalKey searchBarKey = GlobalKey();
final GlobalKey walletButtonKey = GlobalKey();
final GlobalKey walletKey = GlobalKey();
final GlobalKey walletAmountKey = GlobalKey();
final GlobalKey walletTileKey = GlobalKey();
final GlobalKey assetAmountKey = GlobalKey();
final GlobalKey assetValueKey = GlobalKey();
final GlobalKey assetPercentageChangeKey = GlobalKey();
final GlobalKey cryptoDetailsPriceAndPercentKey = GlobalKey();
final GlobalKey coinDetails24hrLowKey = GlobalKey();
final GlobalKey coinDetails24hrLowHighVolKey = GlobalKey();
final GlobalKey coinDetails24hrHighKey = GlobalKey();
final GlobalKey coinDetails24hrVolKey = GlobalKey();

final GlobalKey cryptoDetailsFloatingButtonKey = GlobalKey();
final GlobalKey cryptoDetailsGraphKey = GlobalKey();
final GlobalKey cryptoDetailsPercentagesKey = GlobalKey();
final GlobalKey cryptoDetailsSentimentKey = GlobalKey();
final GlobalKey cryptoDetailsNewsKey = GlobalKey();


final Map<String,String> showCaseDescriptions={
  'search':'You can search for cryptocurrencies by name or symbol',
  'userInfoCard':'Your fiat balance and total portfolio profit/loss are displayed here',
  'coinTileValue':'This is the current market value of this cryptocurrency'
  ,'coinTilePercentage':'This is the percentage change of the value in the last 24 hours',
   'coinTilePercentage2':'Green indicates increase in value\nRed indicates decrease in value',
  'walletButton':'Press the wallet icon to reveal your portfolio',
  'wallet':'Cryptocurrency assets that you purchase will be displayed here',
  'walletAmount':'This is the total value of all of your assets in the wallet',
  'walletTile':'This is the cryptocurrency you have purchased',
  'assetAmount':'This is the amount of this asset you are holding',
  'assetValue':'This is its value in USD',
  'assetPercentageChange':'This is the percentage by which this asset\'s value has change since the last time you bought it',
  'coinTile':'Tap here to view more details about this cryptocurrency',
  'cryptoDetailsPriceAndPercent':'This is the crypto\'s current value and percentage change in the last 24hrs',
  'coinDetails24hrLow':'This is the lowest value this crypto dropped to in the past 24 hours',
  'coinDetails24hrHigh':'This is the highest value this crypto reached in the past 24 hours',
  'coinDetails24hrVol':'This is the volume of trade that occurred with this coin in the past 24hrs',
  'cryptoDetailsFloatingButton':'Tap here to Buy this Asset and view other options',
  'cryptoDetailsGraph':'Daily,Weekly, Monthly and Yearly trends of this coin are displayed here',
  'cryptoDetailsPercentages':'These are percentage change in the assets value',
  'cryptoDetailsSentiment':'This is what the community(Reddit,CoinGecko) feels about this crypto',
  'cryptoDetailsNews':'Trending news regarding this crypto',
  'coinDetails24hrLowHighVol':'24hr Low: Lowest value the coin dipped to in the past 24 hours\n24hr High: Highest value the coin reached in the past 24 hours\n24hr Vol: Total volume of the trades made with this coin in the past 24 hours'
};


Color getRandomShowCaseColor(){
  List<Color> showCaseColors = [
    domColor,
    Color(0xff009688),
    Color(0xff9C27B0),
    Color(0xff673AB7),
    Color(0xff8BC34A),
    Color(0xffFFC107),
    Color(0xffFF5722),
    Color(0xff00BCD4),
    Color(0xff795548),
    Color(0xff3F51B5)

  ];

  Random random = new Random();

  return showCaseColors[random.nextInt(showCaseColors.length)];

}