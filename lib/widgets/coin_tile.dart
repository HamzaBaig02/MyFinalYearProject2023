import 'package:cached_network_image/cached_network_image.dart';
import 'package:crypto_trainer/constants/showcase_keys.dart';
import 'package:crypto_trainer/screens/crypto_detail_screen.dart';
import 'package:crypto_trainer/widgets/custom_showcase.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:crypto_trainer/models/coin_data.dart';
import 'package:showcaseview/showcaseview.dart';

import '../screens/crypto_details_screen_showcase.dart';
import '../services/functions.dart';


class CoinTile extends StatefulWidget {
  CoinData coinData;

  CoinTile(this.coinData);

  @override
  _CoinTileState createState() => _CoinTileState();
}

class _CoinTileState extends State<CoinTile>{



  @override
  Widget build(BuildContext context) {
    return widget.coinData.rank == 1 ? CustomShowCase(refKey:coinTileKey,description:'${widget.coinData.name} is one of the many cryptocurrencies available in this app',opacity:0.1,child: ShowCaseCoinTile(coinData: widget.coinData,)):NormalCoinTile(coinData: widget.coinData);
  }
}

class ShowCaseCoinTile extends StatelessWidget {

  final CoinData coinData;
  ShowCaseCoinTile({required this.coinData});


  @override
  Widget build(BuildContext context) {
    return CustomShowCase(
      disposeOnTap: true,
      onTargetClick: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) {
          return ShowCaseWidget(enableAutoScroll:true,builder: Builder(builder: (context) =>  CoinDetailsShowCase(coinData)));
        }),
      ),
      refKey: coinTileKey2,
      opacity: 0.1,
      description: showCaseDescriptions['coinTile'].toString(),
      child: GestureDetector(
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) {
              return CryptoDetails(coinData);
            }),
          ),
        child: Container(
          //margin: EdgeInsets.only(bottom: 1),
            padding: EdgeInsets.all(5),
            child: Column(
              children: [
            Row(
            //mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
            Flexible(
            flex: 11,
              fit: FlexFit.tight,
              child: Container(


                child: Row(
                  children: [
                    CircleAvatar(
                      foregroundImage: NetworkImage(coinData.imageUrl),
                      radius: 17,
                      backgroundColor: Colors.grey.shade100,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Container(
                      padding: EdgeInsets.all(4),
                      child: CoinNameSymbol(coinData: coinData),
                    ),
                  ],
                ),
              ),
            ),
          Flexible(
            flex: 10,
            fit: FlexFit.tight,
            child: CustomShowCase(
              refKey: coinTileValueKey,
              description: showCaseDescriptions['coinTileValue'].toString(),
              targetPadding: 5,
              child: Container(
                child: Text(
                  '\$${formatNumber(coinData.value)}',
                  style: TextStyle(fontSize: getFontSize(context, 2.1)),
                ),
              ),
            ),
          ),
          Flexible(
            flex: 5,
            fit: FlexFit.tight,
            child: CustomShowCase(
              refKey: coinTilePercentageChangeKey2,
              description: showCaseDescriptions['coinTilePercentage2'].toString(),
              child: CustomShowCase(
                refKey: coinTilePercentageChangeKey,
                description: showCaseDescriptions['coinTilePercentage'].toString(),
                targetPadding: 5,
                child: Container(
                  //width: 58,
                  child: Text(
                    '${coinData.percentChange.toStringAsFixed(2)}%',
                    style: TextStyle(
                        color: percentColor(coinData.percentChange)),
                  ),
                ),
              ),
            ),
          ),
          ],
        ),

              ],
            )),
      ),
    );
  }
}

class NormalCoinTile extends StatelessWidget {
  final CoinData coinData;

  NormalCoinTile({required this.coinData});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) {
            return CryptoDetails(coinData);
          }),
        );
      },
      child: Container(
        //margin: EdgeInsets.only(bottom: 1),
          padding: EdgeInsets.all(5),
          child: Column(
            children: [
              Row(
                //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    flex: 11,
                    fit: FlexFit.tight,
                    child: Container(


                      child: Row(
                        children: [
                          CircleAvatar(
                            foregroundImage: NetworkImage(coinData.imageUrl),
                            radius: 17,
                            backgroundColor: Colors.grey.shade100,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Container(
                            padding: EdgeInsets.all(4),
                            child: CoinNameSymbol(coinData: coinData),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 10,
                    fit: FlexFit.tight,
                    child: Container(

                      child: Text(
                        '\$${formatNumber(coinData.value)}',
                        style: TextStyle(fontSize: getFontSize(context, 2.1)),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 5,
                    fit: FlexFit.tight,
                    child: Container(
                      //width: 58,
                      child: Text(
                        '${coinData.percentChange.toStringAsFixed(2)}%',
                        style: TextStyle(
                            color: percentColor(coinData.percentChange)),
                      ),
                    ),
                  ),
                ],
              ),

            ],
          )),
    );
  }
}




class CoinNameSymbol extends StatelessWidget {
  const CoinNameSymbol({
    Key? key,
    required this.coinData,
  }) : super(key: key);

  final CoinData coinData;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(coinData.symbol.toUpperCase()),
        Container(
          width: 90,
          child: Text(
            coinData.name,
            style: TextStyle(fontSize: 10),
          ),

        ),
      ],
    );
  }
}
