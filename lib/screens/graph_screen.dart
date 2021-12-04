import 'package:crypto_trainer/models/coin_data.dart';
import 'package:crypto_trainer/screens/homepage.dart';
import 'package:crypto_trainer/widgets/graph.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class GraphScreen extends StatelessWidget {
  List<FlSpot> nodes;
  CoinData coin;

  GraphScreen(this.nodes,this.coin);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => true,
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(coin.imageUrl),
              radius: 30,
              backgroundColor: Colors.transparent,
            )
            ,
            Text("${coin.name}",
            style: TextStyle(
              fontSize: 24,
            ),),
            Container(
              color: Colors.grey.shade100,
              padding: EdgeInsets.all(10),
              height: 300,
              width: 400,
              child: Graph(nodes),
            ),
          ],
        ),
      ),
    );
  }
}
