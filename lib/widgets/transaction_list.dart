import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'transaction_tile.dart';
import 'package:crypto_trainer/models/user_data.dart';

class TransactionList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Provider.of<UserData>(context, listen: true)
              .transactions
              .isNotEmpty
          ? ListView.builder(
              physics: ClampingScrollPhysics(),
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                return TransactionTile(
                    Provider.of<UserData>(context, listen: true).transactions[
                        (Provider.of<UserData>(context, listen: true)
                                    .transactions
                                    .length -
                                1) -
                            index]);
              },
              itemCount: Provider.of<UserData>(context, listen: true)
                  .transactions
                  .length,
            )
          : Center(
              child: Text('Transaction history is empty'),
            ),
    );
  }
}
