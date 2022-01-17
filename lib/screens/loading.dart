import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:crypto_trainer/models/coin_data.dart';
import 'package:crypto_trainer/models/user_data.dart';
import 'package:crypto_trainer/services/crypto_network.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:crypto_trainer/screens/homepage.dart';



List<CoinData> fetchCoinList(String response){

  final jsonObject = jsonDecode(response) as Map<String, dynamic>;

  List<CoinData> coinList = List.generate(500, (index){
    final dataMap = jsonObject['data'][index] as Map<String, dynamic>;
    String symbol = dataMap['symbol'];
    return CoinData(int.parse(dataMap['rank']),
      dataMap['id'] as String,
      dataMap['name'] as String,
      dataMap['symbol'] as String,
      double.parse(dataMap['priceUsd'] as String),
      double.parse(dataMap['changePercent24Hr'] as String),
        'https://static.coincap.io/assets/icons/${symbol.toLowerCase()}@2x.png'
    );
  });
  return coinList;
}

class Loading extends StatefulWidget {
  const Loading({Key? key}) : super(key: key);
  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  List<CoinData> coinList = [];

  Future <List<CoinData>> createComputeFunction(String response) async {
print("Inside isolate");
    return compute(fetchCoinList,response);

  }

  getCryptoData() async {
    CryptoNetwork mynetwork = CryptoNetwork();

    //re-establishing api connection if it fails
    for (int i = 0; i < 3; i++) {
      await mynetwork.startNetwork();
      if (mynetwork.cryptoData.isNotEmpty) break;
      print('Restarting Network...');
    }

    if(mynetwork.cryptoData.isNotEmpty){
  print("making coinlist");
      coinList = await createComputeFunction(mynetwork.cryptoData);

    }


    if (mynetwork.cryptoData.isNotEmpty &&
        Provider.of<UserData>(context, listen: false).wallet.isNotEmpty) {
      CoinData updatedCoin;

      Provider.of<UserData>(context, listen: false)
          .wallet
          .forEach((walletElement) {
        updatedCoin = mynetwork.getCryptoDataByIndex(walletElement.coin.rank - 1);
//if the currency rank hasn't changed
        if (walletElement.coin.id == updatedCoin.id) {
          walletElement.updateCoin(updatedCoin);
        } else {
          print(
              'Currencny rank of ${walletElement.coin.name} changed...updating coin data...');

          for (int i = 0; i < 500; i++) {
            if (walletElement.coin.id == mynetwork.getCryptoDataByIndex(i).id) {
              walletElement.updateCoin(mynetwork.getCryptoDataByIndex(i));
              break;
            }
          }
        }
      });
    }

    Provider.of<UserData>(context, listen: false).calculateNetExpectedProfit();

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) {
        return ChangeNotifierProvider(
            create: (context) => BottomNavigationBarProvider(),
            child: UserHomePage(coinList));
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

class BottomNavigationBarProvider extends ChangeNotifier {
  int currentIndex = 0;

  void setCurrentIndex(int index) {
    currentIndex = index;
    notifyListeners();
  }
}
