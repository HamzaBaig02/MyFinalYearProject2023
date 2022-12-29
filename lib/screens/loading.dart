import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:crypto_trainer/models/coin_data.dart';
import 'package:crypto_trainer/models/user_data.dart';
import 'package:crypto_trainer/services/crypto_network.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:crypto_trainer/screens/homepage.dart';
import 'package:crypto_trainer/models/settings.dart' as mySettings;
import 'package:showcaseview/showcaseview.dart';
import '../services/functions.dart';
import 'package:widget_circular_animator/widget_circular_animator.dart';


List<CoinData> fetchCoinList(String response) {
  List<CoinData> coinList = [];
  final jsonObject = jsonDecode(response) as List;

  for (int i = 0; i < jsonObject.length; i++) {
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

    CryptoNetwork myNetwork = CryptoNetwork();

    for(int i = 1;i <= 2;i++){
      await myNetwork.startNetwork(url: 'https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=250&page=$i&sparkline=false&price_change_percentage=1h%2C24h%2C7d%2C30d%2C1y');
      if(myNetwork.cryptoData.isNotEmpty){
        coinList = coinList + await compute(fetchCoinList, myNetwork.cryptoData);
      }

    }

    if (myNetwork.cryptoData.isNotEmpty &&
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

    if (myNetwork.cryptoData.isNotEmpty &&
        Provider.of<UserData>(context, listen: false).bookmarks.isNotEmpty) {

      Provider.of<UserData>(context, listen: false)
          .bookmarks
          .forEach((bookmarkElement) {

        coinList.forEach((element) {
          if (element.id == bookmarkElement.id)
            bookmarkElement = element;
        });
      });

    }

    Provider.of<UserData>(context,listen: false).updateBookmarks(coinList: coinList);
    Provider.of<UserData>(context, listen: false).calculateNetExpectedProfit();

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) {
        return MultiProvider(providers: [
          ChangeNotifierProvider(
            create: (context) => BottomNavigationBarProvider(),
          ),
        ],
          child: ShowCaseWidget(builder: Builder(builder: (context) => UserHomePage(coinList))),

        );
      }),
    );
  }

  getUserDataFromCloud()async{
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if(currentUser == null){
        print('User doesnt exists');
        UserData user = await fetchDataFromDisk();
        Provider.of<UserData>(context,
            listen: false).load(user);
      }
      else{
        if (Provider.of<mySettings.Settings>(context,
            listen: false).isGuest == false) {
          Provider.of<UserData>(context,
              listen: false).emailID = currentUser?.email??'';
          final docUser = FirebaseFirestore.instance.collection('users').doc(currentUser?.email);
          var snapShot;
          await docUser.get()
              .then((doc) {
            if(doc.exists) {
              print("exists");
              snapShot = doc;
              Provider.of<UserData>(context,
                  listen: false).loadFromCloud(doc);


            } else {
              print("doesnt exists");
            }
          });
        }
      }


    } on Exception catch (e) {
      print(e);
      // TODO
    }
  }

  void fetchData()async{
    await getUserDataFromCloud();
    await getCryptoData();
  }
  @override
  void initState() {
    super.initState();
    fetchData();

  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.shade300,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          WidgetCircularAnimator(size: 200,
              innerIconsSize: 3,
              outerIconsSize: 3,
              innerAnimation: Curves.easeInOutBack,
              outerAnimation: Curves.easeInOutBack,
              innerColor: Colors.deepPurple,
              outerColor: Colors.orangeAccent.shade700,
              innerAnimationSeconds: 10,
              outerAnimationSeconds: 10,child: Image.asset('assets/images/cryptotrainer.png',height: 120,)),
          // SpinKitCircle(
          //   color: Colors.black,
          //   size: 70,
          // ),
        ],
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
