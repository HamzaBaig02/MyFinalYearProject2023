
import 'dart:convert';
import 'package:crypto_trainer/models/coin_data.dart';
import 'package:crypto_trainer/services/crypto_network.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;

class CoinInfo extends ChangeNotifier {

  String coinId;
  Map<String, String> performanceIndicators = {};
  Map<String, String> pricePrediction = {};
  String aboutCoin = '';
  Map<String, String> developerSentiment = {};
  bool loading = true;

  CoinInfo({required this.coinId});

  getCoinInfo() async {
    performanceIndicators = {};
    pricePrediction = {};
    loading = true;
    performanceIndicators = await compute(extractData2,coinId);
    pricePrediction =  await compute(extractData,coinId);
    print(performanceIndicators);
    print(pricePrediction);
    loading = false;
    notifyListeners();
  }




}

Future<Map<String,String>> extractData(String coinId) async {
//Getting the response from the targeted url
  var response =
  await http.Client().get(
      Uri.parse('https://coincodex.com/crypto/${coinId}/price-prediction/'),headers:{"Access-Control-Allow-Origin": "*","Content-Type": "application/json"});
  //Status Code 200 means response has been received successfully
  if (response.statusCode == 200) {
    //Getting the html document from the response

    var document = parser.parse(utf8.decode(response.bodyBytes));

    try { //Scraping the first article title
      var responseString1 = document
          .getElementsByClassName('data-sentiment')[0]
          .children[1];

      var responseString2 = document
          .getElementsByClassName('prediction-ranges')[0]
          .children[0]
          .children[1];

      var responseString3 = document
          .getElementsByClassName('prediction-ranges')[0]
          .children[1]
          .children[1];

      String day5 = responseString2.text.trim();
      day5 = day5.substring(1,day5.length).trim();
      String month1 = responseString3.text.trim();
      month1 = month1.substring(1,month1.length).trim();

      return {"sentiment":responseString1.text.trim(),"5dayprediction":day5,"1monthprediction":month1};

    } catch (e) {
      print("Error fetching data for ${coinId}");
      print(e);
      return {};
    }
  } else {
    print('ERROR: ${response.statusCode}.');
    return {};
  }
}

Future<Map<String,String>> extractData2(String coinId) async{
  return CryptoNetwork().getPerformanceIndicators(coinId: coinId);
}