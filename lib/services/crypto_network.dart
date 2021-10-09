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
    String name = jsonDecode(_cryptoData)['data'][index]['name'];
    String symbol = jsonDecode(_cryptoData)['data'][index]['symbol'];
    String id = jsonDecode(_cryptoData)['data'][index]['id'];
    double value =
        double.parse(jsonDecode(_cryptoData)['data'][index]['priceUsd']);
    double percentChange = double.parse(
        jsonDecode(_cryptoData)['data'][index]['changePercent24Hr']);
    String image =
        'https://static.coincap.io/assets/icons/${symbol.toLowerCase()}@2x.png';

    return CoinData(index, id, name, symbol, value, percentChange, image);
  }

  getGraphData(CoinData coin) async {
    Network cryptoNetwork = Network(
        'https://api.coincap.io/v2/assets/${coin.id}/history?interval=m5');
    String _cryptoData = '';

    for (int i = 0; i < 3; i++) {
      _cryptoData = await cryptoNetwork.getData();
      if (_cryptoData.isNotEmpty) break;
    }
    await cryptoNetwork.getData() ?? '';
    List<FlSpot> nodes = [];
    if (_cryptoData.isNotEmpty) {
      for (int index = 1410; index < 1440; index++) {
        double priceUSD =
            double.parse(jsonDecode(_cryptoData)['data'][index]['priceUsd']);
        double time = double.parse(
            jsonDecode(_cryptoData)['data'][index]['time'].toString());

        nodes.add(FlSpot(time, priceUSD));
      }
    }
    return nodes;
  }
}
