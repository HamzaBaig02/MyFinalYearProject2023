import 'package:crypto_trainer/models/coin_data.dart';
import 'package:crypto_trainer/models/user_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:crypto_trainer/widgets/useInfo_card.dart';
import 'package:crypto_trainer/widgets/coin_tile.dart';
import 'package:crypto_trainer/services/crypto_network.dart';

class UserHomePage extends StatefulWidget {
  CryptoNetwork mynetwork;

  UserHomePage(this.mynetwork);

  @override
  _UserHomePageState createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage> {
  int points = 25678;

  bool loading = false;

  Future<void> fetchData() async {
    setState(() {
      loading = true;
    });

    await widget.mynetwork.startNetwork();

    await Future.delayed(Duration(seconds: 2));

    if (widget.mynetwork.cryptoData.isNotEmpty) {
      Provider.of<UserData>(context, listen: false)
          .wallet
          .forEach((walletElement) {
        CoinData updatedCoin =
            widget.mynetwork.getCryptoDataByIndex(walletElement.coin.index);

        if (walletElement.coin.id == updatedCoin.id) {
          walletElement.setValueUSD(updatedCoin.value);
          walletElement.setPercentChanged(updatedCoin.value);
        } else {
          print('The Api has changed Indexes of the coins kindly update code');
        }
      });
    }

    setState(() {
      widget.mynetwork;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.all(3),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              UserInfoCard(),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                  ),
                  child: widget.mynetwork.cryptoData.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              loading
                                  ? CircularProgressIndicator()
                                  : MaterialButton(
                                      color: Colors.white,
                                      elevation: 1,
                                      child: Text('Refresh'),
                                      onPressed: () async {
                                        fetchData();
                                      }),
                              Text(
                                  'Crypto-Currency data unavailable at the moment'),
                            ],
                          ),
                        )
                      : RefreshIndicator(
                          onRefresh: fetchData,
                          child: ListView.builder(
                            physics: BouncingScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            itemBuilder: (context, index) {
                              return CoinTile(
                                  widget.mynetwork.getCryptoDataByIndex(index));
                            },
                            itemCount: 100,
                          ),
                        ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
