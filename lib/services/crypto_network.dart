import 'dart:convert';
import 'package:crypto_trainer/models/coin_data.dart';
import 'package:crypto_trainer/services/network.dart';
import 'package:crypto_trainer/widgets/graph.dart';
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



  Future<List<FlSpot>> getGraphData({required CoinData coin, required String days, required String interval}) async {
    Uri link = Uri.parse('https://api.coingecko.com/api/v3/coins/${coin.id}/market_chart?vs_currency=usd&days=$days&interval=$interval');
    print(link.toString());
    Network cryptoNetwork = Network(link,{"accept": "application/json"});
    String _cryptoData = '';

    _cryptoData = await cryptoNetwork.getData() ?? " ";

    List<FlSpot> nodes = [];
    List response = jsonDecode(_cryptoData)['prices'];
    if (_cryptoData.isNotEmpty) {
      for (int index = 0; index < response.length; index++) {
        double priceUSD = double.parse((response[index][1]).toString());
        double time = double.parse(response[index][0].toString());

        nodes.add(FlSpot(time,priceUSD));
      }
    }
    return nodes;
  }

Future<List<FlSpot>> getGraphDataSMA({required CoinData coin,required int smaDays,required int intervalDays}) async {
  Uri link = Uri.parse("https://api.coingecko.com/api/v3/coins/${coin
      .id}/market_chart?vs_currency=usd&days=max&interval=daily");
  Network cryptoNetwork = Network(link, {"accept": "application/json"});
  String _cryptoData = '';

  _cryptoData = await cryptoNetwork.getData() ?? " ";

  if (_cryptoData.isNotEmpty) {
    final jsonObject = jsonDecode(_cryptoData);
    List dataMap = jsonObject["prices"];
    double sum = 0;
    List<double> sma = [];


    for (int i = dataMap.length - intervalDays - smaDays; i <
        dataMap.length - intervalDays; i++) {
      sum = sum + dataMap[i][1];
    }
    sma.add(sum / smaDays);
    int j = 0;
    for (int i = dataMap.length - intervalDays; i < dataMap.length; i++) {
      sum = sum - dataMap[dataMap.length - intervalDays - smaDays + j][1] +
          dataMap[dataMap.length - intervalDays + j][1];
      sma.add(sum / smaDays);
      j++;
    }

    List<FlSpot> smaNodes = [];

    for(int i = dataMap.length - intervalDays; i<dataMap.length;i++){

      smaNodes.add(FlSpot(dataMap[i][2],sma[i]));

    }


    return smaNodes;
  }
  else
    return [];
}

}
