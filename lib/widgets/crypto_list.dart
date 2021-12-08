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
  List<CoinData> coinList = List.generate(100, (index){
    int rank = int.parse(jsonDecode(response)['data'][index]['rank']);
    String name = jsonDecode(response)['data'][index]['name'];
    String symbol = jsonDecode(response)['data'][index]['symbol'];
    String id = jsonDecode(response)['data'][index]['id'];
    double value =
    double.parse(jsonDecode(response)['data'][index]['priceUsd']);
    double percentChange = double.parse(
        jsonDecode(response)['data'][index]['changePercent24Hr']);
    String image =
        'https://static.coincap.io/assets/icons/${symbol.toLowerCase()}@2x.png';

    return CoinData(rank, id, name, symbol, value, percentChange, image);
  });
  return coinList;
}


class CryptoList extends StatefulWidget {

  CryptoNetwork mynetwork = CryptoNetwork();
  List<CoinData>cryptoList;
  CryptoList(this.cryptoList);

  @override
  _CryptoListState createState() => _CryptoListState();
}

class _CryptoListState extends State<CryptoList>
    with AutomaticKeepAliveClientMixin<CryptoList> {
  bool loading = false;



  Future <List<CoinData>> createComputeFunction() async {
    String response = widget.mynetwork.cryptoData;
    print("inside Isolate 2");
    return compute(fetchCoinList,response);

  }



  //Update Wallet Data
  Future<void> fetchData() async {
    setState(() {
      loading = true;
    });

    for (int i = 0; i < 3; i++) {
      await widget.mynetwork.startNetwork();
      if (widget.mynetwork.cryptoData.isNotEmpty) break;
      print('Restarting Network...');
    }

   if(widget.mynetwork.cryptoData.isNotEmpty){
print("creating list 2");
     widget.cryptoList = await createComputeFunction();

   }


    if (widget.mynetwork.cryptoData.isNotEmpty &&
        Provider.of<UserData>(context, listen: false).wallet.isNotEmpty) {
      CoinData updatedCoin;
      Provider.of<UserData>(context, listen: false)
          .wallet
          .forEach((walletElement) {
        updatedCoin =
            widget.mynetwork.getCryptoDataByIndex(walletElement.coin.rank - 1);
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
    if(_textController.text.length > 0 && filteredList.isEmpty)
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
        ),
        Flexible(
          child: search ? Padding(
            padding: const EdgeInsets.all(20),
            child: Text("No results found...",style: TextStyle(fontSize: 20),),
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
                      itemCount: filteredList.isEmpty ? 100 : filteredList.length,
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
