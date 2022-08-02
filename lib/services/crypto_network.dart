import 'dart:convert';
import 'package:crypto_trainer/models/coin_data.dart';
import 'package:crypto_trainer/services/network.dart';
import 'package:fl_chart/fl_chart.dart';

class CryptoNetwork {
  String _cryptoData = '';
  late final decodedData;


  Future startNetwork({String url = 'https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=250&page=1&sparkline=false&price_change_percentage=1h%2C24h%2C7d%2C30d%2C1y'}) async {
    Uri link = Uri.parse(url);
    //link = link.replace(queryParameters: <String, String>{'limit': '1000'});
    Network cryptoNetwork = Network(link,{"accept": "application/json"});
    _cryptoData = await cryptoNetwork.getData() ?? "";
    if(_cryptoData.isNotEmpty)
    decodedData = jsonDecode(_cryptoData);
  }

  String get cryptoData => _cryptoData;



  Future<List<FlSpot>> getGraphData({required CoinData coin, int days = 1, String interval = "hourly"}) async {
    Uri link = Uri.parse('https://api.coingecko.com/api/v3/coins/${coin.id}/market_chart?vs_currency=usd&days=$days&interval=$interval');
    Network cryptoNetwork = Network(link,{"accept": "application/json"});
    String _cryptoData = '';

    _cryptoData = await cryptoNetwork.getData() ?? " ";

    List<FlSpot> nodes = [];
    List response = jsonDecode(_cryptoData)['prices'];
    if (_cryptoData.isNotEmpty) {
      for (int index = 0; index < 25; index++) {
        double priceUSD = double.parse((response[index][1]).toStringAsFixed(4));
        double time = double.parse(response[index][0].toString());

        nodes.add(FlSpot(time,priceUSD));
      }
    }
    return nodes;
  }
}
