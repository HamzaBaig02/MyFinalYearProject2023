import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import '../constants/colors.dart';
import '../services/functions.dart';
import 'transaction_tile.dart';
import 'package:crypto_trainer/models/user_data.dart';

class TransactionList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 5, 0, 0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(10),
            topLeft: Radius.circular(10),
          ),
          color: Colors.white),
      child: Provider.of<UserData>(context, listen: true)
              .transactions
              .isNotEmpty
          ? ListView.separated(
            separatorBuilder: (context, index) {
            return Divider(
            height: 1,
            thickness: 1,
            color: Colors.grey.shade100,
            );
            },
              physics: ClampingScrollPhysics(),
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                return TransactionTile(
                    transaction: Provider.of<UserData>(context, listen: true).transactions[
                    (Provider.of<UserData>(context, listen: true)
                        .transactions
                        .length -
                        1) -
                        index],);
              },
              itemCount: Provider.of<UserData>(context, listen: true)
                  .transactions
                  .length,
            )
          : Column(
        mainAxisAlignment: MainAxisAlignment.center,

        children: [
          Lottie.asset('assets/images/astronaut.json',
              height: MediaQuery.of(context).size.height * 0.3),
          // SizedBox(width: 4,),
          Text('Nothing to see here...',
              style: TextStyle(
                  fontSize: getFontSize(context, 2), fontWeight: FontWeight.bold,color: domColor)),
        ],
      ),
    );
  }
}
