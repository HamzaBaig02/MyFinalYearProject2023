import 'package:crypto_trainer/models/coin_data.dart';
import 'package:crypto_trainer/screens/graph_screen.dart';
import 'package:crypto_trainer/services/crypto_network.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class GraphLoading extends StatefulWidget {
  CoinData coin;

  GraphLoading(this.coin);

  @override
  _GraphLoadingState createState() => _GraphLoadingState();
}

class _GraphLoadingState extends State<GraphLoading> {
  void getGraphData() async {
    CryptoNetwork mynetwork = CryptoNetwork();
    List<FlSpot> nodes = await mynetwork.getGraphData(widget.coin);

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) {
        return GraphScreen(nodes,widget.coin);
      }),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getGraphData();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.shade300,
      child: Center(
        child: SpinKitCircle(
          color: Colors.black,
          size: 70,
        ),
      ),
    );
    ;
  }
}
