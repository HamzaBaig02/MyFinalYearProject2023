import 'package:flutter/material.dart';
import 'package:crypto_trainer/models/transaction.dart';

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
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          CircleAvatar(
            foregroundImage: NetworkImage(transaction.crypto.coin.imageUrl),
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
              )),
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('\$${transaction.crypto.valueUsd}'),
                Text('${transaction.date}')
              ],
            ),
          )
        ],
      ),
    );
  }
}
