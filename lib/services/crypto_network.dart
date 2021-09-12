import 'dart:convert';
import 'package:crypto_trainer/models/coin_data.dart';
import 'package:crypto_trainer/services/network.dart';
import 'package:flutter/cupertino.dart';

class CryptoNetwork {
  String _cryptoData = '';

  Future startNetwork({String url = 'https://api.coincap.io/v2/assets'}) async {
    Network cryptoNetwork = Network(url);
    _cryptoData = await cryptoNetwork.getData() ?? '';
  }

  String get cryptoData => _cryptoData;

  CoinData getCryptoDataByIndex(int index) {
    String name = jsonDecode(_cryptoData)['data'][index]['name'];
    String symbol = jsonDecode(_cryptoData)['data'][index]['symbol'];
    String id = jsonDecode(_cryptoData)['data'][index]['id'];
    double value =
        double.parse(jsonDecode(_cryptoData)['data'][index]['priceUsd']);
    double percentChange = double.parse(
        jsonDecode(_cryptoData)['data'][index]['changePercent24Hr']);
    String image =
        'https://static.coincap.io/assets/icons/${symbol.toLowerCase()}@2x.png';

    return CoinData(id, name, symbol, value, percentChange, image);
  }

  List<CoinData> getCoinList() {
    List<CoinData> coinDataList = [];

    if (_cryptoData != '') {
      coinDataList = List.generate(100, (index) {
        CoinData myCoin = getCryptoDataByIndex(index);
        return myCoin;
      });

      return coinDataList;
    }

    return [];
  }

  CoinData getCryptoDataByID() {
    String name = jsonDecode(_cryptoData)['data']['name'];
    String symbol = jsonDecode(_cryptoData)['data']['symbol'];
    String id = jsonDecode(_cryptoData)['data']['id'];
    double value = double.parse(jsonDecode(_cryptoData)['data']['priceUsd']);
    double percentChange =
        double.parse(jsonDecode(_cryptoData)['data']['changePercent24Hr']);
    String image =
        'https://static.coincap.io/assets/icons/${symbol.toLowerCase()}@2x.png';

    return CoinData(id, name, symbol, value, percentChange, image);
  }
}
