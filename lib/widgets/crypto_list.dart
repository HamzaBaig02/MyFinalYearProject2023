import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:crypto_trainer/services/crypto_network.dart';
import 'package:crypto_trainer/widgets/coin_tile.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:crypto_trainer/models/user_data.dart';
import 'package:crypto_trainer/models/coin_data.dart';
import 'package:flutter/foundation.dart';

import '../models/settings.dart';

List<CoinData> fetchCoinList(String response){
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



class CryptoList extends StatefulWidget {

  List<CoinData>coinList;
  CryptoList(this.coinList);

  @override
  _CryptoListState createState() => _CryptoListState(coinList);
}

class _CryptoListState extends State<CryptoList>
    with AutomaticKeepAliveClientMixin<CryptoList> {
  bool loading = false;
  List<CoinData> cryptoList;

  _CryptoListState(this.cryptoList);

  //Update Wallet Data
  Future<void> fetchData() async {
    if(mounted) {
      setState(() {
        loading = true;
      });
    }

    CryptoNetwork myNetwork = CryptoNetwork();
    List<CoinData> coinList = [];
    for(int i = 1;i <= 2;i++){
      await myNetwork.startNetwork(url: 'https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=250&page=$i&sparkline=false&price_change_percentage=1h%2C24h%2C7d%2C30d%2C1y');
      if(myNetwork.cryptoData.isNotEmpty){
        coinList = coinList + await compute(fetchCoinList, myNetwork.cryptoData);
      }
    }

    if(coinList.isNotEmpty){
      cryptoList = coinList;
    }


    if (myNetwork.cryptoData.isNotEmpty &&
        Provider.of<UserData>(context, listen: false).wallet.isNotEmpty) {

      Provider.of<UserData>(context, listen: false)
          .wallet
          .forEach((walletElement) {

          cryptoList.forEach((element) {
            if (element.id == walletElement.coin.id)
              walletElement.updateCoin(element);
          });
      });
    }


    Provider.of<UserData>(context,listen: false).updateBookmarks(coinList: cryptoList);

    Provider.of<UserData>(context, listen: false).calculateNetExpectedProfit();

    if(mounted) {
      setState(() {
        loading = false;
      });
    }
  }

  void Search(String value){
    filteredList.clear();
    setState(() {

      cryptoList.forEach((element) {
        if(element.name.toLowerCase().contains(value.toLowerCase()) || element.symbol.toLowerCase().contains(value.toLowerCase()))
          filteredList.add(element);


      });

      if(value.isEmpty)
        filteredList.clear();


    });
  }
  Timer? timer;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

      timer = Timer.periodic(Duration(seconds: 40), (Timer t) => fetchData()
      );


  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    timer?.cancel();

  }


  TextEditingController _textController = TextEditingController();
  bool search = false;
  List<CoinData> filteredList = [];



  @override
  Widget build(BuildContext context) {


    print('crypto list rebuilt');
    if(_textController.text.isNotEmpty && filteredList.isEmpty)
      search = true;
    else
      search = false;


    super.build(context);
    return Column(
      children: [
        Container(

          margin: EdgeInsets.symmetric(vertical: 5),
          decoration: BoxDecoration(
            color: Colors.white70,
            borderRadius: BorderRadius.circular(10),

          ),
          child: TextField(
            controller: _textController,
            style: TextStyle(
                fontSize: 14.0,
                height: 1.0,
                color: Colors.black
            ),

            // inputFormatters: [FilteringTextInputFormatter.digitsOnly],

            onChanged:Search,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(0, 20, 0,15),
              hintText: 'Search...',
              prefixIcon: Icon(
                FontAwesomeIcons.search,
                size: 18,
                color: Colors.black12,
              ),
              suffixIcon: IconButton(icon:Icon(FontAwesomeIcons.timesCircle,
                size: 18,
                color: _textController.text.isNotEmpty ? Colors.red : Colors.black12,),onPressed:(){setState(() {
                _textController.clear();
                filteredList.clear();
              });}

              ),
              border:InputBorder.none,
              focusedBorder:OutlineInputBorder(
                borderSide: const BorderSide(color: Color(0xff8b4a6c), width: 2.0),
                borderRadius: BorderRadius.circular(10),
              ),
              //enabledBorder: InputBorder.none,
            ),
          ),
        ),//Search Bar
        Flexible(
          child: search ? Padding(
            padding: const EdgeInsets.all(20),
            child: Text("No results found...",style: TextStyle(fontSize: 20,color: Colors.grey),),
          ) : Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(10),
                  topLeft: Radius.circular(10),
                ),
                color: Colors.white),
            child: cryptoList.isEmpty
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
                :
            RefreshIndicator(
              onRefresh: fetchData,
              child: ListView.separated(
                physics: BouncingScrollPhysics(),
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  return filteredList.isNotEmpty ? CoinTile(
                      filteredList[index]
                  ):CoinTile(
                      cryptoList[index]
                  );
                },
                itemCount: filteredList.isEmpty ? cryptoList.length : filteredList.length,
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

class SearchBar extends StatelessWidget {

  final Function(String)? Search;
  final TextEditingController _textController;


  SearchBar(this.Search, this._textController);

  @override
  Widget build(BuildContext context) {
    return Container(

      margin: EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white70,
        borderRadius: BorderRadius.circular(25),

      ),
      child: TextField(
        controller: _textController,
        style: TextStyle(
        fontSize: 14.0,
        height: 1.0,
        color: Colors.black
    ),

        // inputFormatters: [FilteringTextInputFormatter.digitsOnly],

        onChanged:Search,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(0, 20, 0,15),
          hintText: 'Search...',
          prefixIcon: Icon(
            FontAwesomeIcons.search,
            size: 18,
            color: Colors.black12,
          ),
          suffixIcon: IconButton(icon:Icon(FontAwesomeIcons.timesCircle,
              size: 18,
              color: Colors.black12),onPressed: (){

          },),
          border:InputBorder.none,
          focusedBorder:OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xff8b4a6c), width: 2.0),
            borderRadius: BorderRadius.circular(25.0),
          ),
          //enabledBorder: InputBorder.none,
        ),
      ),
    );
  }
}
