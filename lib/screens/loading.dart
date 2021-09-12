import 'package:flutter/material.dart';
import 'package:crypto_trainer/models/coin_data.dart';
import 'package:crypto_trainer/models/user_data.dart';
import 'package:crypto_trainer/services/crypto_network.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:crypto_trainer/screens/homepage.dart';

class Loading extends StatefulWidget {
  const Loading({Key? key}) : super(key: key);
  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  List<CoinData> coinList = [];

  getCryptoData() async {
    CryptoNetwork mynetwork = CryptoNetwork();
    await mynetwork.startNetwork();
    if (mynetwork.cryptoData != '') {
      coinList = List.generate(100, (index) {
        CoinData myCoin = mynetwork.getCryptoDataByIndex(index);
        return myCoin;
      });
    }
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) {
        return UserHomePage(coinList);
      }),
    );
  }

  @override
  void initState() {
    super.initState();
    getCryptoData();
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
  }
}
