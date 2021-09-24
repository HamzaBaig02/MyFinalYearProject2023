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
        children: [
          Expanded(
            flex: 40,
            child: Row(
              children: [
                CircleAvatar(
                  foregroundImage:
                      NetworkImage(transaction.crypto.coin.imageUrl),
                  backgroundColor: Colors.grey.shade100,
                ),
                Container(
                    padding: EdgeInsets.all(4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(transaction.crypto.coin.name),
                        Container(
                          width: 52,
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
          Expanded(
            flex: 20,
            child: Container(
              child: Text(
                '\$${transaction.crypto.valueUsd.toStringAsFixed(2)}',
                style: TextStyle(fontSize: 15),
              ),
            ),
          ),
          Expanded(
            flex: 30,
            child: Container(
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
            ),
          )
        ],
      ),
    );
  }
}
