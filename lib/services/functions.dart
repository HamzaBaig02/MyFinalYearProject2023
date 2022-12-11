
import 'dart:convert';
import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sentiment_dart/sentiment_dart.dart';

import '../models/user_data.dart';
import 'network.dart';

double calculateRSI(List response){
  List<double> temp = [];
  double posAverage = 0;
  double negAverage = 0;
  int pos = 0;
  int neg = 0;
  double rs;

  for(int i = response.length - 14;i < response.length - 1;i++){
    temp.add(response[i+1][1] - response[i][1]);
  }

  temp.forEach((element) {
    if(element > 0) {
      posAverage = posAverage + element;
      pos++;
    }
    else if(element < 0) {
      negAverage = negAverage + element;
      neg++;
    }
  });

  posAverage = posAverage / pos;
  negAverage = negAverage / neg;
  rs = posAverage / negAverage;

  return 100 - (100/(1-rs));

}

double calculateEMA(List response, int days){
  double weightFactor = 2 / (days + 1);
  double sma = calculateSMA(response, days);
  double initialEMA = weightFactor * (response[0][1] - sma) + sma;
  print('ema grpah data ${response[response.length-1][1]}');

  return initialEMA;

}


String formatNumber(double number){
  var decimals = number.toString().split('.')[1];
  final formatter = NumberFormat('#,##,000.00');
  NumberFormat formatterBig = NumberFormat.compact();
  if(number >= 1000000)
    return formatterBig.format(number);
  else if(number >= 1000)
    return formatter.format(number);
  else if(number == 0)
    return number.toString();
  else if(number < 0)
    return number.toStringAsFixed(2);
  else if(number >= 0.1)
    return number.toStringAsFixed(2);
  else if(number <= 0.00000001)
    return number.toStringAsExponential(5);
  else
    return number.toStringAsFixed(7);
}

Color percentColor(double number){
  return number < 0 ? Colors.red : Colors.green;
}

Color predictionColor(String data){
  if(data.toLowerCase() == 'neutral' || data.toLowerCase() == 'null')
    return Colors.grey.shade600;
  else if(data.toLowerCase() == 'bullish')
    return Colors.green;
  else if(data.toLowerCase() == 'bearish')
    return Colors.red;
  else return Colors.black;
}

bool isNumeric(String str) {

  str = str.replaceAll(',','');
  print(str);

  if(str == null) {
    return false;
  }
  return double.tryParse(str) != null;
}

double calculateSMA(List response,int days){

  double sum = 0;

  for(int i = response.length - days ;i < response.length;i++){

    sum = sum + response[i][1];

  }

  return sum/days;

}

bool showDot (FlSpot spot,LineChartBarData barData){

  double max = barData.spots[0].y;
  double min = barData.spots[0].y;

  for(int i = 0;i < barData.spots.length;i++){


    if(max < barData.spots[i].y){

      max = barData.spots[i].y;

    }

    if(min > barData.spots[i].y){

      min = barData.spots[i].y;

    }

  }



  if(spot.y == max || spot.y == min)
    return true;
  else
    return false;



}


Map<String,int> maxminDot (List<FlSpot> barData){

  double max = barData[0].y;
  double min = barData[0].y;

  int maxIndex = 0;
  int minIndex = 0;

  for(int i = 0;i < barData.length;i++){


    if(max < barData[i].y){

      max = barData[i].y;
      maxIndex = i;

    }

    if(min > barData[i].y){

      min = barData[i].y;
      minIndex = i;
    }

  }


  return {"max":maxIndex,"min":minIndex};

}

fetchDataFromDisk()async{
  //data from disk
  SharedPreferences pref = await SharedPreferences.getInstance();
  String data = '';
  try {
    data = pref.getString('myData') ?? '';
  } on Exception catch (e) {
    print(e);
  }

  UserData user;

  if (data.isNotEmpty) {
    Map json = jsonDecode(data);
    user = UserData.fromJson(json);
  } else {
    user = UserData('Hi, User', [], 10000, 0, 0, [],"Guest User",[]);
  }
 return user;
}

fetchSettingsFromDisk()async{
  SharedPreferences pref = await SharedPreferences.getInstance();
  String data = '';
  int isGuest = 0;
  try {
    data = pref.getString('mySettings') ?? '';
  } on Exception catch (e) {
    print(e);
  }
  if (data.isNotEmpty) {
    Map json = jsonDecode(data);
    print(data);
     isGuest = json['isGuest'];
  } else {
    isGuest = 0;
  }
  return isGuest;

}

void saveSettingsToStorage(int isGuest) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String json = jsonEncode({'isGuest':isGuest});
  prefs.setString('mySettings', json);



  print(json);


}

storeUserDataOnCloud(BuildContext context,UserData data)async{

  try {

    final currentUser = FirebaseAuth.instance.currentUser;
    if(currentUser == null){
      print('User doesnt exists');
    }
    else{
      final docUser = FirebaseFirestore.instance.collection('users').doc(currentUser?.email);
      var snapShot;
      docUser.get()
          .then((doc) {
        if(doc.exists) {
          print("exists,updating...");
          snapShot = doc;
          docUser.update(data.toJsonFireStore());


        } else {
          print("doesn't exists, creating...");
          docUser.set(data.toJsonFireStore());
        }
      });
    }


  } on Exception catch (e) {
    print(e);
    // TODO
  }
}


double getFontSize(BuildContext context,multiplier){
  double unitHeightValue = MediaQuery.of(context).size.height * 0.01;
  double fontSize = multiplier * unitHeightValue;
  return fontSize;
}


double doubleNullCheck(dynamic x){
  double y = 0;
  try {
    y = x;
    return y;
  } catch(e){

    return 0;
  }

}

void getCoinSentiment(String coinId) async {
  try {
    Uri link = Uri.parse("https://api.pushshift.io/reddit/comment/search/?q=$coinId&subreddit=$coinId&before=2d&size=25&score=%3E25&filter=body");
    Network cryptoNetwork = Network(link, {"accept": "application/json"});
    String _cryptoData = '';

    _cryptoData = await cryptoNetwork.getData() ?? " ";
    List response = jsonDecode(_cryptoData)['data'];
 double score = 0;
 int positive = 0;
 int negative = 0;
 int neutral = 0;
    for(int i = 0;i < 25;i++) {
      SentimentResult x = Sentiment.analysis(response[i]['body']);
      if(x.score > 0)
        positive++;
      else if(x.score < 0)
        negative++;
      else
        neutral++;

    }
 int total = 25;
    print("$positive $negative");
  print("Positive : ${positive/total * 100}  Negative: ${negative/total * 100}");


  } on Exception catch (e) {
    print(e);
  }


}



