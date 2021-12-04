import 'package:flutter/material.dart';
import 'package:crypto_trainer/services/crypto_network.dart';
import 'package:crypto_trainer/widgets/coin_tile.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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



    if (widget.mynetwork.cryptoData.isNotEmpty &&
        Provider.of<UserData>(context, listen: false).wallet.isNotEmpty) {
      CoinData updatedCoin;
      Provider.of<UserData>(context, listen: false)
          .wallet
          .forEach((walletElement) {
        updatedCoin =
            widget.mynetwork.getCryptoDataByIndex(walletElement.coin.rank);
//if the currency rank hasn't changed
        if (walletElement.coin.id == updatedCoin.id) {
          walletElement.updateCoin(updatedCoin);
        } else {
          print(
              'Currencny rank of ${walletElement.coin.name} changed...updating coin data...');

          for (int i = 0; i < 100; i++) {
            if (walletElement.coin.id ==
                widget.mynetwork.getCryptoDataByIndex(i).id) {
              walletElement
                  .updateCoin(widget.mynetwork.getCryptoDataByIndex(i));
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
    print('crypto list rebuilt');
    super.build(context);
    return Column(
      children: [
        Container(

          margin: EdgeInsets.symmetric(vertical: 5),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25),

          ),
          child: TextField(

            // inputFormatters: [FilteringTextInputFormatter.digitsOnly],

            onChanged: (value) {

            },
            decoration: InputDecoration(
              hintText: 'Search...',
              prefixIcon: Icon(
                FontAwesomeIcons.search,
                color: Colors.black12,
              ),
              suffixIcon: IconButton(icon:Icon(FontAwesomeIcons.timesCircle,
                  color: Colors.black12),onPressed: (){




              },),
              border: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.grey, width: 2.0),
                borderRadius: BorderRadius.circular(25.0),
              ),
              focusedBorder:OutlineInputBorder(
                borderSide: const BorderSide(color: Color(0xff8b4a6c), width: 2.0),
                borderRadius: BorderRadius.circular(25.0),
              ),
              //enabledBorder: InputBorder.none,
            ),
          ),
        ),
        Flexible(
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(10),
                  topLeft: Radius.circular(10),
                ),
                color: Colors.white),
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
                    child: ListView.separated(
                      physics: BouncingScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      itemBuilder: (context, index) {
                        return CoinTile(
                          widget.mynetwork.getCryptoDataByIndex(index),
                        );
                      },
                      itemCount: 100,
                      separatorBuilder: (context, index) {
                        return Divider(
                          height: 1,
                          thickness: 1,
                          color: Colors.grey.shade100,
                        );
                      },
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
