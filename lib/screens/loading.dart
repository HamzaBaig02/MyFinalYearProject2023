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
    await mynetwork.startNetwork();

    if (mynetwork.cryptoData.isNotEmpty) {
      Provider.of<UserData>(context, listen: false)
          .wallet
          .forEach((walletElement) {
        CoinData updatedCoin =
            mynetwork.getCryptoDataByIndex(walletElement.coin.index);

        if (walletElement.coin.id == updatedCoin.id) {
          walletElement.setValueUSD(updatedCoin.value);
          walletElement.setPercentChanged(updatedCoin.value);
        } else {
          print('The Api has changed Indexes of the coins kindly update code');
        }
      });
    }

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
