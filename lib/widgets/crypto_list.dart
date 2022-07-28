import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:crypto_trainer/services/crypto_network.dart';
import 'package:crypto_trainer/widgets/coin_tile.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:crypto_trainer/models/user_data.dart';
import 'package:crypto_trainer/models/coin_data.dart';
import 'package:flutter/foundation.dart';

List<CoinData> fetchCoinList(String response){
  List<CoinData> coinList = [];
  final jsonObject = jsonDecode(response) as Map<String, dynamic>;

  for(int i = 0;i < 1000;i++) {

    final dataMap = jsonObject['data'][i] as Map<String, dynamic>;
    String symbol = dataMap['symbol'];

    if(dataMap['rank'] == null || dataMap['priceUsd'] == null || dataMap['changePercent24Hr'] == null || dataMap['id'] == null|| dataMap['name'] == null|| dataMap['symbol'] == null)
      continue;

    CoinData coin = CoinData(
        int.parse(dataMap['rank']),
        dataMap['id'] as String,
        dataMap['name'] as String,
        dataMap['symbol'] as String,
        double.parse(dataMap['priceUsd'] as String),
        double.parse(dataMap['changePercent24Hr'] as String),
        'https://static.coincap.io/assets/icons/${symbol.toLowerCase()}@2x.png'
    );

    coinList.add(coin);


  }
  return coinList;
}



class CryptoList extends StatefulWidget {

  List<CoinData>cryptoList;
  CryptoList(this.cryptoList);

  @override
  _CryptoListState createState() => _CryptoListState();
}

class _CryptoListState extends State<CryptoList>
    with AutomaticKeepAliveClientMixin<CryptoList> {
  bool loading = false;


  //Update Wallet Data
  Future<void> fetchData() async {


    CryptoNetwork mynetwork = CryptoNetwork();

    setState(() {
      loading = true;
    });


      await mynetwork.startNetwork();


   if(mynetwork.cryptoData.isNotEmpty){

     widget.cryptoList = await compute(fetchCoinList,mynetwork.cryptoData);

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
              'Currency rank of ${walletElement.coin.name} changed...updating coin data...');

          widget.cryptoList.forEach((element) {
            if (element.id == walletElement.coin.id)
              walletElement.updateCoin(element);
          });
        }
      });
    }

    Provider.of<UserData>(context, listen: false).calculateNetExpectedProfit();

    setState(() {
      loading = false;
    });
  }

  void Search(String value){
    filteredList.clear();
    setState(() {

      widget.cryptoList.forEach((element) {
        if(element.name.toLowerCase().contains(value.toLowerCase()) || element.symbol.toLowerCase().contains(value.toLowerCase()))
          filteredList.add(element);


      });

      if(value.isEmpty)
        filteredList.clear();


    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();


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
                color: _textController.text.isNotEmpty ? Colors.red : Colors.black12,),onPressed:(){setState(() {
                _textController.clear();
                filteredList.clear();
              });}

              ),
              border:InputBorder.none,
              focusedBorder:OutlineInputBorder(
                borderSide: const BorderSide(color: Color(0xff8b4a6c), width: 2.0),
                borderRadius: BorderRadius.circular(25.0),
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
            child: widget.cryptoList.isEmpty
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
                      widget.cryptoList[index]
                  );
                },
                itemCount: filteredList.isEmpty ? widget.cryptoList.length : filteredList.length,
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
