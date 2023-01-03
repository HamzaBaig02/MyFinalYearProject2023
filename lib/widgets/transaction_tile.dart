import 'package:flutter/material.dart';
import 'package:crypto_trainer/models/transaction.dart';
import 'package:intl/intl.dart';

import '../services/functions.dart';



class TransactionTile extends StatelessWidget {
  final Transaction transaction;
  final bool showPercent;

  TransactionTile({required this.transaction,this.showPercent = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 1),
      padding: EdgeInsets.all(5),
      child: Row(
        children: [
          Flexible(
            flex: 11,
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
              child: Row(
                children: [
                  Text(
                    '\$${formatNumber(transaction.crypto.valueUsd)}',
                    style: TextStyle(fontSize: 16),
                  ),
                  showPercent?transPercentWidget(transaction):SizedBox()

                ],
              ),
            ),
          ),
          Flexible(
            flex: 8,
            fit: FlexFit.tight,
            child: Container(

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${DateFormat('HH:mm').format(transaction.date)}',
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

Widget transPercentWidget(Transaction transaction){


      return transaction.type == 'Sold' ? Container(
        margin: EdgeInsets.only(left: 5),
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
        child: Text(
          '${transaction.percentChange.toStringAsFixed(2)}%',
          style: TextStyle(fontSize: 14,color: percentColor(transaction.percentChange)),
        ),
      ):SizedBox();



}
