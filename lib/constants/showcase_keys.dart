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

final Map<String,String> showCaseDescriptions={
  'search':'You can search for cryptocurrencies by name or symbol',
  'userInfoCard':'Your fiat balance and total portfolio profit/loss are displayed here',
  'coinTileValue':'This is the current market value of this cryptocurrency'
  ,'coinTilePercentage':'This is the percentage change of the value in the last 24 hours',
   'coinTilePercentage2':'Green indicates increase in value\nRed indicates decrease in value',
  'walletButton':'Press the wallet icon to reveal your portfolio',
  'coinTile':'Tap here to view more details about this cryptocurrency',
};