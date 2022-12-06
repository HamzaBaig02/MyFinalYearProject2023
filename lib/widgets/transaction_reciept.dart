import 'package:crypto_trainer/services/functions.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import '../models/transaction.dart';

class TransactionInvoice extends StatelessWidget {
  Transaction transaction;


  TransactionInvoice({required this.transaction});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(15),topRight: Radius.circular(15))
      ),
      child: Column(

        children: [
          Center(child: Icon(FontAwesomeIcons.checkCircle,color: Colors.green,size: getFontSize(context, 7),),),
          SizedBox(height: 10,),
          Center(child: Text('Transaction Complete',style: TextStyle(fontSize: getFontSize(context, 4),fontWeight: FontWeight.w500),)),
          SizedBox(height: 10,),
          Text('\$${formatNumber(transaction.crypto.valueUsd)}',style: TextStyle(fontSize: getFontSize(context, 2.8),fontWeight: FontWeight.w400),),
          Text(transaction.type,style: TextStyle(fontSize: getFontSize(context, 2.8),fontWeight: FontWeight.w500),),
          Text('@\$${formatNumber(transaction.crypto.coin.value)}',style: TextStyle(fontSize: getFontSize(context, 2.8),fontWeight: FontWeight.w400),),
          Text(
            '${DateFormat('kk:mm').format(transaction.date)}',
            style: TextStyle(fontSize: getFontSize(context, 2.2), color: Colors.grey.shade600),
          ),
          Text(
            '${DateFormat('yyyy-MM-dd').format(transaction.date)}',
            style: TextStyle(fontSize: getFontSize(context, 2.2), color: Colors.grey),
          ),

        ],
      ),
    );
  }
}
