import 'package:crypto_trainer/models/coin_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:crypto_trainer/widgets/useInfo_card.dart';
import 'package:crypto_trainer/widgets/coin_tile.dart';
import 'package:crypto_trainer/services/crypto_network.dart';

class UserHomePage extends StatefulWidget {
  List<CoinData> coinDataList = [];
  UserHomePage(this.coinDataList);

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

    CryptoNetwork mynetwork = CryptoNetwork();
    await mynetwork.startNetwork();

    if (mynetwork.getCoinList().isNotEmpty)
      widget.coinDataList = mynetwork.getCoinList();

    await Future.delayed(Duration(seconds: 2));

    setState(() {
      widget.coinDataList;
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
                  child: widget.coinDataList.isEmpty
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
                              return CoinTile(widget.coinDataList[index]);
                            },
                            itemCount: widget.coinDataList.length,
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
