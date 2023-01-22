import 'package:fl_chart/fl_chart.dart';

import '../models/transaction.dart';
import 'package:flutter/material.dart';
List<FlSpot> getRecentTransactions(List<Transaction> transactions) {
  final now = DateTime.now();
  final oneDayAgo = now.subtract(Duration(days: 1));
  final filteredTransactions = transactions
      .where((transaction) => transaction.date.isAfter(oneDayAgo) && transaction.type == 'Sold')
      .toList();
  List<FlSpot> flSpotList = [];
  int count = 1;

  for (var i = 0; i < filteredTransactions.length - 1; i++) {
    final currentTransaction = filteredTransactions[i];
    final nextTransaction = filteredTransactions[i + 1];
    final difference = nextTransaction.date.difference(currentTransaction.date).inMinutes;
    if (difference < 60) {
      count++;
      final avgProfit;
      if(count >= 3){
        avgProfit =((currentTransaction.percentChange * (count - 1)) + nextTransaction.percentChange)/count;
      }
      else
      {
        avgProfit = (currentTransaction.percentChange + nextTransaction.percentChange)/2;
      }
      currentTransaction.percentChange = avgProfit;
      //currentTransaction.crypto.valueUsd = currentTransaction.profitAmount + nextTransaction.profitAmount;
      filteredTransactions[i] = currentTransaction;
      filteredTransactions.removeAt(i + 1);
      i--;
      print(avgProfit);
      print(count);
    }
    else{
      count = 1;
    }

  }


  filteredTransactions.forEach((element) {flSpotList.add(FlSpot(double.parse(element.date.millisecondsSinceEpoch.toString()),element.profitAmount));});

  return flSpotList;
}

List<FlSpot> getRecentWeekMonthYearTransactions(List<Transaction> transactions,int days) {
  final now = DateTime.now();
  final specifiedDays = now.subtract(Duration(days: days));
  final filteredTransactions = transactions
      .where((transaction) => transaction.date.isAfter(specifiedDays) && transaction.type == 'Sold')
      .toList();
  List<FlSpot> flSpotList = [];
  int count = 1;

  for (var i = 0; i < filteredTransactions.length - 1; i++) {
    final currentTransaction = filteredTransactions[i];
    final nextTransaction = filteredTransactions[i + 1];
    final difference = nextTransaction.date.difference(currentTransaction.date).inHours;
    if (difference < 24) {
      count++;
      final avgProfit;
      if(count >= 3){
        avgProfit =((currentTransaction.percentChange * (count - 1)) + nextTransaction.percentChange)/count;
      }
      else
      {
        avgProfit = (currentTransaction.percentChange + nextTransaction.percentChange)/2;
      }
      currentTransaction.percentChange = avgProfit;

      currentTransaction.profitAmount = currentTransaction.profitAmount + nextTransaction.profitAmount;
      filteredTransactions[i] = currentTransaction;
      filteredTransactions.removeAt(i + 1);
      i--;
      print(avgProfit);
      print(count);
    }
    else{
      count = 1;
    }
  }

  filteredTransactions.forEach((element) {flSpotList.add(FlSpot(double.parse(element.date.millisecondsSinceEpoch.toString()),element.profitAmount));});

  return flSpotList;
}

Map<String, dynamic> topThreeCoins(List<Transaction> transactions) {
  Map<String, dynamic> coinData = {};
  Map<String, dynamic> topThreeCoinData = {};
  for (var transaction in transactions) {
    var coin = transaction.crypto.coin.id;
    if (!coinData.containsKey(coin)) {
      coinData[coin] = { 'count': 0, 'name': '${transaction.crypto.coin.name}', 'imageUrl': '${transaction.crypto.coin.imageUrl}','investment': 0.0, 'profit': 0.0, 'loss': 0.0 };
    }
    if(transaction.type == 'Bought')
      coinData[coin]['investment'] += transaction.crypto.valueUsd;
    if(transaction.type == 'Sold' && transaction.percentChange >= 0)
      coinData[coin]['profit'] += (transaction.crypto.valueUsd * (transaction.percentChange/100));
    if(transaction.type == 'Sold' && transaction.percentChange < 0)
      coinData[coin]['loss'] += (transaction.crypto.valueUsd * (transaction.percentChange/100));

    coinData[coin]['count'] += 1;
  }
  // Sort the coins by count
  var sortedCoins = coinData.keys.toList()..sort((a, b) => coinData[b]['count'] - coinData[a]['count']);
  // Take the top 3 coins
  var topThree = sortedCoins.sublist(0, 3);
  // Calculate the average profit and loss for each top coin
  for (var coin in topThree) {
    if (!topThreeCoinData.containsKey(coin))
      topThreeCoinData[coin] = { 'count': 0,'investment': 0.0, 'profit': 0.0, 'loss': 0.0 };
    topThreeCoinData[coin] = coinData[coin];
  }

  return topThreeCoinData;
}