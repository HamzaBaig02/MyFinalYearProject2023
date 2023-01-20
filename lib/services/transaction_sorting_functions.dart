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
      double currentTransactionProfitAmount = (currentTransaction.percentChange/100) * currentTransaction.crypto.valueUsd;
      double nextTransactionProfitAmount = (nextTransaction.percentChange/100) * nextTransaction.crypto.valueUsd;
      if(count >= 3){
        //avgProfit =((currentTransactionProfitAmount* (count - 1)) + nextTransactionProfitAmount)/count;
        avgProfit = (currentTransactionProfitAmount + nextTransactionProfitAmount);
      }
      else
      {
        avgProfit = (currentTransactionProfitAmount + nextTransactionProfitAmount);
      }
      currentTransaction.percentChange = avgProfit;
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


  filteredTransactions.forEach((element) {flSpotList.add(FlSpot(double.parse(element.date.millisecondsSinceEpoch.toString()),element.percentChange));});

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
      double currentTransactionProfitAmount = (currentTransaction.percentChange/100) * currentTransaction.crypto.valueUsd;
      double nextTransactionProfitAmount = (nextTransaction.percentChange/100) * nextTransaction.crypto.valueUsd;

      if(count >= 3){
        avgProfit = (currentTransactionProfitAmount + nextTransactionProfitAmount);
        //avgProfit =((currentTransactionProfitAmount * (count - 1)) + nextTransactionProfitAmount)/count;
      }
      else
      {
        avgProfit = (currentTransactionProfitAmount + nextTransactionProfitAmount);
        //avgProfit = (currentTransactionProfitAmount + nextTransactionProfitAmount)/2;
      }
      currentTransaction.percentChange = avgProfit;
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

  filteredTransactions.forEach((element) {flSpotList.add(FlSpot(double.parse(element.date.millisecondsSinceEpoch.toString()),element.percentChange));});

  return flSpotList;
}