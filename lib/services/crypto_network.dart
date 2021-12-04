import 'dart:convert';
import 'package:crypto_trainer/models/coin_data.dart';
import 'package:crypto_trainer/services/network.dart';
import 'package:fl_chart/fl_chart.dart';

class CryptoNetwork {
  String _cryptoData = '';

  Future startNetwork({String url = 'https://api.coincap.io/v2/assets'}) async {
    Network cryptoNetwork = Network(url);
    _cryptoData = await cryptoNetwork.getData() ?? '';
  }

  String get cryptoData => _cryptoData;

  CoinData getCryptoDataByIndex(int index) {
    int rank = int.parse(jsonDecode(_cryptoData)['data'][index]['rank']);
    String name = jsonDecode(_cryptoData)['data'][index]['name'];
    String symbol = jsonDecode(_cryptoData)['data'][index]['symbol'];
    String id = jsonDecode(_cryptoData)['data'][index]['id'];
    double value =
        double.parse(jsonDecode(_cryptoData)['data'][index]['priceUsd']);
    double percentChange = double.parse(
        jsonDecode(_cryptoData)['data'][index]['changePercent24Hr']);
    String image =
        'https://static.coincap.io/assets/icons/${symbol.toLowerCase()}@2x.png';

    return CoinData(rank, id, name, symbol, value, percentChange, image);
  }

  getGraphData(CoinData coin) async {
    Network cryptoNetwork = Network(
        'https://api.coincap.io/v2/assets/${coin.id}/history?interval=m1');
    String _cryptoData = '';

    for (int i = 0; i < 3; i++) {
      _cryptoData = await cryptoNetwork.getData();
      if (_cryptoData.isNotEmpty) break;
    }
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
