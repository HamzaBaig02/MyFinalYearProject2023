import 'package:flutter/material.dart';
import 'package:crypto_trainer/models/coin_data.dart';
import 'package:crypto_trainer/models/user_data.dart';
import 'package:crypto_trainer/services/crypto_network.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:crypto_trainer/screens/homepage.dart';

class Loading extends StatefulWidget {
  const Loading({Key? key}) : super(key: key);
  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  getCryptoData() async {
    CryptoNetwork mynetwork = CryptoNetwork();

    for (int i = 0; i < 3; i++) {
      await mynetwork.startNetwork();
      if (mynetwork.cryptoData.isNotEmpty) break;
      print('Restarting Network...');
    }

    if (mynetwork.cryptoData.isNotEmpty &&
        Provider.of<UserData>(context, listen: false).wallet.isNotEmpty) {
      CoinData updatedCoin;

      Provider.of<UserData>(context, listen: false)
          .wallet
          .forEach((walletElement) {
        updatedCoin = mynetwork.getCryptoDataByIndex(walletElement.coin.index);
//if the currency rank hasn't changed
        if (walletElement.coin.id == updatedCoin.id) {
          walletElement.coin.value = updatedCoin.value;
          walletElement.setValueUSD(updatedCoin.value);
          walletElement.setPercentChanged(updatedCoin.value);
        } else {
          print(
              'Currencny rank of ${walletElement.coin.name} changed...updating coin data...');

          for (int i = 0; i < 100; i++) {
            if (walletElement.coin.id == mynetwork.getCryptoDataByIndex(i).id) {
              walletElement
                  .setValueUSD(mynetwork.getCryptoDataByIndex(i).value);
              walletElement
                  .setPercentChanged(mynetwork.getCryptoDataByIndex(i).value);
              walletElement.coin.index =
                  mynetwork.getCryptoDataByIndex(i).index;
              walletElement.coin.value =
                  mynetwork.getCryptoDataByIndex(i).value;
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
        return UserHomePage(mynetwork);
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
