import 'package:flutter/material.dart';
import 'package:crypto_trainer/models/transaction.dart';
import 'package:intl/intl.dart';

class TransactionTile extends StatelessWidget {
  Transaction transaction;

  TransactionTile(this.transaction);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 1),
      padding: EdgeInsets.all(5),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            child: Row(
              children: [
                CircleAvatar(
                  foregroundImage:
                      NetworkImage(transaction.crypto.coin.imageUrl),
                  backgroundColor: Colors.grey.shade100,
                ),
                Container(
                    width: 130,
                    padding: EdgeInsets.all(4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(transaction.crypto.coin.name),
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
          Container(
            width: 95,
            child: Text(
              '\$${transaction.crypto.valueUsd.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 15),
            ),
          ),
          Container(
            width: 70,
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
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
