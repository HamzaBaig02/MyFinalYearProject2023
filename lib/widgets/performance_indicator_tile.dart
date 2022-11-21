import 'package:crypto_trainer/services/functions.dart';
import 'package:flutter/material.dart';


class IndicatorTile extends StatelessWidget {
  String title;
  String data;


  IndicatorTile(this.title, this.data);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(title,style: TextStyle(color: Colors.grey),),
          SizedBox(height: 5,),
          Text(data == 'null' ? 'N/A' : formatNumber(double.parse(data)),style: TextStyle(fontSize: getFontSize(context, 2.3)),),
        ],

      ),
    );
  }
}
