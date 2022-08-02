import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:crypto_trainer/models/coin_data.dart';
import 'package:crypto_trainer/models/user_data.dart';
import 'package:crypto_trainer/services/crypto_network.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:crypto_trainer/screens/homepage.dart';

List<CoinData> fetchCoinList(String response) {
  List<CoinData> coinList = [];
  final jsonObject = jsonDecode(response);

  for (int i = 0; i < 250; i++) {
    final dataMap = jsonObject[i];


    if (dataMap['market_cap_rank'] == null ||
        dataMap['current_price'] == null ||
        dataMap['price_change_percentage_24h'] == null ||
        dataMap['id'] == null ||
        dataMap['name'] == null ||
        dataMap['symbol'] == null) {
      print('${dataMap['name']} contains null values, not including');
      continue;
    }

    CoinData coin = CoinData(
        dataMap['market_cap_rank'] as int,
        dataMap['id'] as String,
        dataMap['name'] as String,
        dataMap['symbol'] as String,
        double.parse(dataMap['current_price'].toString()),
        double.parse(dataMap['price_change_percentage_24h'].toString()),
        double.parse((dataMap['price_change_percentage_1h_in_currency']??0).toString()),
        double.parse((dataMap['price_change_percentage_7d_in_currency']??0).toString()),
        double.parse((dataMap['price_change_percentage_30d_in_currency']??0).toString()),
        double.parse((dataMap['price_change_percentage_1y_in_currency']??0).toString()),
        double.parse((dataMap['atl_change_percentage']??0).toString()),
        double.parse((dataMap['ath_change_percentage']??0).toString()),
        dataMap['image'] as String,
        double.parse((dataMap['high_24h']??0).toString()),
        double.parse((dataMap['low_24h']??0).toString()),
        double.parse((dataMap['total_volume']??0).toString()),
        double.parse((dataMap['ath']??0).toString()),
        double.parse((dataMap['atl']??0).toString())

    );

    coinList.add(coin);
  }
  return coinList;
}

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

    if (mynetwork.cryptoData.isNotEmpty) {
      print("making coinlist");
      coinList = await compute(fetchCoinList, mynetwork.cryptoData);
    }

    if (mynetwork.cryptoData.isNotEmpty &&
        Provider.of<UserData>(context, listen: false).wallet.isNotEmpty) {
      Provider
          .of<UserData>(context, listen: false)
          .wallet
          .forEach((walletElement) {
        coinList.forEach((element) {
          if (element.id == walletElement.coin.id)
            walletElement.updateCoin(element);
        });
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
