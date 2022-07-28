import 'dart:convert';
import 'package:crypto_trainer/models/coin_data.dart';
import 'package:crypto_trainer/services/network.dart';
import 'package:fl_chart/fl_chart.dart';

class CryptoNetwork {
  String _cryptoData = '';
  late Map<String,dynamic> decodedData;


  Future startNetwork({String url = 'https://api.coincap.io/v2/assets'}) async {
    Uri link = Uri.parse(url);
    link = link.replace(queryParameters: <String, String>{'limit': '1000'});
    Network cryptoNetwork = Network(link,{"Authorization": "02ef9c70-91de-4a4f-bd48-2e8ab0a7b595"});
    _cryptoData = await cryptoNetwork.getData() ?? "";
    if(_cryptoData.isNotEmpty)
    decodedData = jsonDecode(_cryptoData) as Map<String, dynamic>;
  }

  String get cryptoData => _cryptoData;

  CoinData getCryptoDataByIndex(int index) {

    final dataMap = decodedData['data'][index] as Map<String, dynamic>;
    String symbol = dataMap['symbol'];
    return CoinData(int.parse(dataMap['rank']),
        dataMap['id'] as String,
        dataMap['name'] as String,
        dataMap['symbol'] as String,
        double.parse(dataMap['priceUsd'] as String),
        double.parse(dataMap['changePercent24Hr'] as String),
        'https://static.coincap.io/assets/icons/${symbol.toLowerCase()}@2x.png'
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
