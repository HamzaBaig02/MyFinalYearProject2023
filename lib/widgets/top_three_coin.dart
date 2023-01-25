import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../services/functions.dart';

class TopThreeCoins extends StatelessWidget {
  final Map<String, dynamic> topThreeCoinData;
  const TopThreeCoins(this.topThreeCoinData);

  @override
  Widget build(BuildContext context) {
    List keys = topThreeCoinData.keys.toList();
    return Container(
      height: 140,
      child: ListView.builder(itemBuilder: (context,index){
        return Container(
          decoration: BoxDecoration(
            color: Color(0xff2e3340),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Color(0xff8b4a6c), width: 2),
          ),
          margin: EdgeInsets.all(2),
          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),

          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,

            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(backgroundColor: Colors.transparent,foregroundImage: NetworkImage(topThreeCoinData[keys[index]]['imageUrl']),radius: 15,),
                  Text(topThreeCoinData[keys[index]]['name'],style: TextStyle(color: Colors.white),),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Trades: ',style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500)),
                  Text('${topThreeCoinData[keys[index]]['count']}',style: TextStyle(color: Colors.white)),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [

                  Text('Investment: ',style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500)),
                  Text('\$${formatNumber(topThreeCoinData[keys[index]]['investment'])}',style: TextStyle(color: Colors.white)),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Text('Net Profit: ',style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500)),
                  Text('\$${formatNumber(topThreeCoinData[keys[index]]['netProfit'])}',style: TextStyle(color: percentColor(topThreeCoinData[keys[index]]['netProfit']))),
                ],
              ),

            ],),
        );
      },itemCount: 3,
          scrollDirection: Axis.horizontal),
    );;
  }
}
