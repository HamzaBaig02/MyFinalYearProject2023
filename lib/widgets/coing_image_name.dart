import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../models/coin_data.dart';


class CoinImageAndName extends StatelessWidget {
  final CoinData coinData;


  CoinImageAndName({required this.coinData});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10)
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
                      fontSize: 20,
                      fontWeight: FontWeight.w500
                  ),
                ),
                Text(coinData.symbol.toUpperCase(),
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey
                  ),),

              ],
            ),
          ),
          Flexible(child: Icon(FontAwesomeIcons.bookmark,color: Color(
              0xff8b4a6c),))

        ],
      ),
    );
  }
}