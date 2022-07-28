import 'package:flutter/material.dart';

import '../models/coin_data.dart';


class CryptoDetails extends StatefulWidget {
  CoinData coinData;
  CryptoDetails(this.coinData);

  @override
  _CryptoDetailsState createState() => _CryptoDetailsState();
}

class _CryptoDetailsState extends State<CryptoDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:Colors.grey.shade200,
      body: SafeArea(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Flexible(
                fit: FlexFit.loose,
                child: Container(
                  margin: EdgeInsets.all(5.0),
                  decoration: BoxDecoration(
                    color: Colors.white
                  ),
                  child: Text(widget.coinData.symbol),

                ),
              ),
              Flexible(
                fit: FlexFit.tight,
                child: Container(
                  margin: EdgeInsets.all(5.0),
                  decoration: BoxDecoration(
                      color: Colors.white
                  ),
                  child: Text("Graph"),

                ),
              ),

              Container(),
              Container(),
              Container(),

            ],
          ),
        ),

      ),
    );
  }
}
