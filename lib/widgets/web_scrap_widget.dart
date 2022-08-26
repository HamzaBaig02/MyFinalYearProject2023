import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:html/parser.dart' as parser;
import 'package:intl/intl.dart';
import '../models/coin_data.dart';
import 'package:flutter/foundation.dart';

import '../services/functions.dart';

bool loading = true;



Future<Map<String,String>> extractData(CoinData coin) async {
//Getting the response from the targeted url
print(coin);
  var response =
  await http.Client().get(
      Uri.parse('https://coincodex.com/crypto/${coin.id}/price-prediction/'),headers:{"Access-Control-Allow-Origin": "*","Content-Type": "application/json"});
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
      print("Error fetching data for ${coin.id}");
      print(e);
      return {};
    }
  } else {
    print('ERROR: ${response.statusCode}.');
    return {};
  }
}


class WebScrapTile extends StatefulWidget {
  final CoinData coin;

  WebScrapTile(this.coin);

  @override
  _WebScrapTileState createState() => _WebScrapTileState();
}

class _WebScrapTileState extends State<WebScrapTile> {
  Map<String,String> webScrapData = {};
  Future fetchData(CoinData coin) async{
    webScrapData =  await compute(extractData,coin);
    print(webScrapData);
    if(mounted) {
      setState(() {
        loading = false;
      });
    }
  }

  List<String> labels = ["Sentiment","5-Day Prediction","1-Month Prediction"];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loading = true;
    fetchData(widget.coin);
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Row(
        children: [
          Flexible(
            fit: FlexFit.tight,
            child: web_scrap_tile(data: webScrapData['sentiment'].toString(),label: "Sentiment",),
          ),
          Flexible(
            fit: FlexFit.tight,
            child: web_scrap_tile(data: webScrapData['5dayprediction'].toString(),label: "5-Day",),
          ),
          Flexible(
            fit: FlexFit.tight,
            child: web_scrap_tile(data: webScrapData['1monthprediction'].toString(),label: "1-Month",),
          ),

        ],
      ),
    );
  }
}

class web_scrap_tile extends StatelessWidget {

  final String data;
  final String label;



  web_scrap_tile({required this.data, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      child:Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,style: TextStyle(color: Colors.grey),),
          SizedBox(height: 5,),
          loading ? Container(height:15,width:15,child: CircularProgressIndicator.adaptive()):Text(data == 'null' ? 'N/A' : (isNumeric(data)?'\$${formatNumber(double.parse(data.replaceAll(',', '')))}':data),style: TextStyle(fontSize: 16,color: predictionColor(data),),),
        ],
      ),
    );
  }
}
