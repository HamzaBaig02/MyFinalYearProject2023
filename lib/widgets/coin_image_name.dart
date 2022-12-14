import 'package:crypto_trainer/services/functions.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../models/coin_data.dart';
import '../models/user_data.dart';
import 'bookmark_button.dart';


class CoinImageAndName extends StatelessWidget {
  final CoinData coinData;


  CoinImageAndName({required this.coinData});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,

      ),
      child: Row(
        children: [
          CircleAvatar(
            foregroundImage: NetworkImage(coinData.imageUrl),
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(coinData.name,
                  style: TextStyle(
                      fontSize: getFontSize(context, 2.8),
                      fontWeight: FontWeight.w500
                  ),
                ),
                Text(coinData.symbol.toUpperCase(),
                  style: TextStyle(
                      fontSize: getFontSize(context, 2.5),
                      color: Colors.grey
                  ),),

              ],
            ),
          ),
          Flexible(child: BookmarkButton(coin: coinData,))

        ],
      ),
    );
  }
}




