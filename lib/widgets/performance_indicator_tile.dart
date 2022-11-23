import 'package:crypto_trainer/services/functions.dart';
import 'package:flutter/material.dart';


class IndicatorTile extends StatelessWidget {
  String title;
  String data;
  VoidCallback callback;
  bool isSelected;


  IndicatorTile(this.title, this.data,this.callback,this.isSelected);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: callback,
      child: Container(
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(7),
            border: Border.all(color: isSelected?Color(0xff8b4a6c):Colors.blueGrey, width: 2)
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(title,style: TextStyle(color: Colors.grey),),
            SizedBox(height: 5,),
            Text(data == 'null' ? 'N/A' : formatNumber(double.parse(data)),style: TextStyle(fontSize: getFontSize(context, 2.3)),),
          ],

        ),
      ),
    );
  }
}
