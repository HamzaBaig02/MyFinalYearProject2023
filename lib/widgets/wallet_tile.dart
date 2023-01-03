import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/crypto_currency.dart';
import '../screens/asset_details.dart';


class WalletTile extends StatelessWidget {
  CryptoCurrency currency;

  WalletTile(this.currency);

  var cryptoFormatter = NumberFormat('0.00000');
  var dollarFormatter = NumberFormat('0,000.00');

  double dollars = 0;

  @override
  Widget build(BuildContext context) {
    dollars = currency.valueUsd;

    return GestureDetector(
      onTap: () {
        print('Wallet Tile pressed');
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) {
            return AssetDetailsScreen(asset: currency,);
          }),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xff2e3340),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Color(0xff8b4a6c), width: 2),
        ),
        margin: EdgeInsets.all(2),
        padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                Hero(
                  tag: '${currency.coin.id}',
                  child: CircleAvatar(
                    backgroundColor: Colors.transparent,
                    foregroundImage:
                    NetworkImage(currency.coin.imageUrl, scale: 2),
                    radius: 15,
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                Text(
                  '${currency.coin.symbol.toUpperCase()}',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
            Column(
              children: [
                Text(
                  '${cryptoFormatter.format(currency.amount)}',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
                SizedBox(
                  height: 2,
                ),
                Row(
                  children: [
                    Text(
                      '\$${dollars >= 1000 ? dollarFormatter.format(dollars) : (dollars).toStringAsFixed(2)}',
                      style: TextStyle(color: Colors.white),
                    ),
                    SizedBox(width: 3),
                    Text(
                      '${currency.percentChange.toStringAsFixed(2)}%',
                      style: TextStyle(
                        fontSize: 10,
                        color: currency.percentChange > 0
                            ? Colors.green
                            : Colors.red,
                      ),
                    )
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}