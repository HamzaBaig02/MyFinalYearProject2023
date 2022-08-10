import 'package:flutter/material.dart';
import 'package:crypto_trainer/models/transaction.dart';
import 'package:intl/intl.dart';

String formatNumber(double number){
  final formatter = NumberFormat('#,##,000.00');
  NumberFormat formatterBig = NumberFormat.compact();

  return ( number >= 1000000?formatterBig.format(number): (number >= 1000 ? formatter.format(
      number) : (number<0.0001?number.toStringAsExponential(3):number.toStringAsFixed(2)).toString()));
}


class TransactionTile extends StatelessWidget {
  Transaction transaction;

  TransactionTile(this.transaction);
  var formatter = NumberFormat('#,##,000.00');
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 1),
      padding: EdgeInsets.all(5),
      color: Colors.white,
      child: Row(
        children: [
          Flexible(
            flex: 10,
            child: Container(
              child: Row(
                children: [
                  CircleAvatar(
                    foregroundImage:
                        NetworkImage(transaction.crypto.coin.imageUrl),
                    backgroundColor: Colors.grey.shade100,
                    radius: 15,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Container(
                      padding: EdgeInsets.all(4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(transaction.crypto.coin.symbol.toUpperCase()),
                          Container(
                            child: Text(
                              transaction.type,
                              style: TextStyle(fontSize: 10),
                            ),
                          ),
                        ],
                      ))
                ],
              ),
            ),
          ),
          Flexible(
            flex: 10,
            fit: FlexFit.tight,
            child: Container(
              //width: 95,
              child: Text(
                '\$${formatNumber(transaction.crypto.valueUsd)}',
                style: TextStyle(fontSize: 15),
              ),
            ),
          ),
          Flexible(
            flex: 6,
            fit: FlexFit.tight,
            child: Container(
              //width: 70,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${DateFormat('kk:mm').format(transaction.date)}',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                  Text(
                    '${DateFormat('yyyy-MM-dd').format(transaction.date)}',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  Text(
                    transaction.type == 'Bought'?'@ \$${formatNumber(transaction.crypto.buyingPricePerCoin)}':'@ \$${formatNumber(transaction.crypto.coin.value)}',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
