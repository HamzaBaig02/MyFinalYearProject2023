
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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

String formatNumber(double number){
  var decimals = number.toString().split('.')[1];
  final formatter = NumberFormat('#,##,000.00');
  NumberFormat formatterBig = NumberFormat.compact();
  if(number >= 1000000)
    return formatterBig.format(number);
  else if(number >= 1000)
    return formatter.format(number);
  else if(number < 0)
    return number.toStringAsFixed(2);
  else if(number >= 0.1)
    return number.toStringAsFixed(2);
  else if(number <= 0.00000001)
    return number.toStringAsExponential();
  else
    return number.toStringAsFixed(7);
}

Color percentColor(double number){
  return number < 0 ? Colors.red : Colors.green;
}

Color predictionColor(String data){
  if(data.toLowerCase() == 'neutral' || data.toLowerCase() == 'null')
    return Colors.grey;
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