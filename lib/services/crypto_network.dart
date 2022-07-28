import 'dart:convert';
import 'package:crypto_trainer/models/coin_data.dart';
import 'package:crypto_trainer/services/network.dart';
import 'package:fl_chart/fl_chart.dart';

class CryptoNetwork {
  String _cryptoData = '';
  late final decodedData;


  Future startNetwork({String url = 'https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=250&page=1&sparkline=false&price_change_percentage=1h%2C24h%2C7d'}) async {
    Uri link = Uri.parse(url);
    //link = link.replace(queryParameters: <String, String>{'limit': '1000'});
    Network cryptoNetwork = Network(link,{"accept": "application/json"});
    _cryptoData = await cryptoNetwork.getData() ?? "";
    if(_cryptoData.isNotEmpty)
    decodedData = jsonDecode(_cryptoData);
  }

  String get cryptoData => _cryptoData;

  CoinData getCryptoDataByIndex(int index) {

    final dataMap = decodedData[index];
    return CoinData(
        dataMap['market_cap_rank'] as int,
        dataMap['id'] as String,
        dataMap['name'] as String,
        dataMap['symbol'] as String,
        double.parse(dataMap['current_price'].toString()),
        double.parse(dataMap['price_change_percentage_24h'].toString()),
        dataMap['image'] as String
    );
  }

  getGraphData(CoinData coin) async {
    Uri link = Uri.parse('https://api.coincap.io/v2/assets/${coin.id}/history?interval=m1');
    Network cryptoNetwork = Network(link,{"Authorization": "02ef9c70-91de-4a4f-bd48-2e8ab0a7b595"});
    String _cryptoData = '';


    _cryptoData = await cryptoNetwork.getData();

    await cryptoNetwork.getData() ?? '';
    List<FlSpot> nodes = [];
    List response = jsonDecode(_cryptoData)['data'];
    if (_cryptoData.isNotEmpty) {
      print("graph api response length:${response.length}");
      for (int index = response.length - 60; index < response.length; index++) {
        String priceUSD =
            double.parse(jsonDecode(_cryptoData)['data'][index]['priceUsd']).toStringAsFixed(6);
        double time = double.parse(
            jsonDecode(_cryptoData)['data'][index]['time'].toString());

        nodes.add(FlSpot(time, double.parse(priceUSD)));
      }
    }
    return nodes;
  }
}
