import 'package:flutter/material.dart';

import '../models/coin_data.dart';
import 'graph.dart';

class CryptoGraph extends StatelessWidget {
  final CoinData coin;

  CryptoGraph(this.coin);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.55,

      child: Graph(coin),
    );
  }
}