import 'package:flutter/material.dart';
import 'package:crypto_trainer/services/crypto_network.dart';
import 'package:crypto_trainer/widgets/coin_tile.dart';
import 'package:provider/provider.dart';
import 'package:crypto_trainer/models/user_data.dart';
import 'package:crypto_trainer/models/coin_data.dart';

class CryptoList extends StatefulWidget {
  CryptoNetwork mynetwork;
  CryptoList(this.mynetwork);

  @override
  _CryptoListState createState() => _CryptoListState();
}

class _CryptoListState extends State<CryptoList>
    with AutomaticKeepAliveClientMixin<CryptoList> {
  bool loading = false;
  Future<void> fetchData() async {
    setState(() {
      loading = true;
    });

    for (int i = 0; i < 3; i++) {
      await widget.mynetwork.startNetwork();
      if (widget.mynetwork.cryptoData.isNotEmpty) break;
      print('Restarting Network...');
    }

    await Future.delayed(Duration(seconds: 2));

    if (widget.mynetwork.cryptoData.isNotEmpty &&
        Provider.of<UserData>(context, listen: false).wallet.isNotEmpty) {
      Provider.of<UserData>(context, listen: false)
          .wallet
          .forEach((walletElement) {
        CoinData updatedCoin =
            widget.mynetwork.getCryptoDataByIndex(walletElement.coin.index);

        if (walletElement.coin.id == updatedCoin.id) {
          walletElement.coin.value = updatedCoin.value;
          walletElement.setValueUSD(updatedCoin.value);
          walletElement.setPercentChanged(updatedCoin.value);
        } else {
          print(
              'Currencny rank changed of ${walletElement.coin.name}....updating coin data...');

          for (int i = 0; i < 100; i++) {
            if (walletElement.coin.id ==
                widget.mynetwork.getCryptoDataByIndex(i).id) {
              walletElement
                  .setValueUSD(widget.mynetwork.getCryptoDataByIndex(i).value);
              walletElement.setPercentChanged(
                  widget.mynetwork.getCryptoDataByIndex(i).value);
              walletElement.coin.index =
                  widget.mynetwork.getCryptoDataByIndex(i).index;
              walletElement.coin.value =
                  widget.mynetwork.getCryptoDataByIndex(i).value;
              break;
            }
          }
        }
      });
    }

    Provider.of<UserData>(context, listen: false).calculateNetExpectedProfit();

    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
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
                  Text('Something went wrong...try refreshing.'),
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
                    widget.mynetwork.getCryptoDataByIndex(index),
                  );
                },
                itemCount: 100,
              ),
            ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
