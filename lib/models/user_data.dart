import 'dart:convert';

import 'package:crypto_trainer/models/coin_data.dart';
import 'package:crypto_trainer/models/crypto_currency.dart';
import 'package:crypto_trainer/models/transaction.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserData extends ChangeNotifier {
  List<CryptoCurrency> wallet;
  List<CoinData> bookmarks = [];

  String name;
  String emailID = "baighamza02@gmail.com";
  double balance;
  double profit;
  int points;
  List<Transaction> transactions = [];
  double amountInWalletUsd = 0;

  UserData(this.name, this.wallet, this.balance, this.profit, this.points,
      this.transactions,this.emailID);

  void refresh() {
    notifyListeners();
  }

  void buyCrypto(CryptoCurrency currency) {
    bool notPresent = true;
    for (int i = 0; i < wallet.length; i++) {
      if (wallet[i].coin.id == currency.coin.id) {
        wallet[i].amount += currency.amount;
        wallet[i].buyingPricePerCoin = currency.buyingPricePerCoin;
        wallet[i].updateCoin(currency.coin);
        notPresent = false;
        notifyListeners();
        break;
      }
    }
    if (notPresent) {
      wallet.add(currency);
      notifyListeners();
    }
  }

  void sellCrypto(CryptoCurrency currency) {
    for (int i = 0; i < wallet.length; i++) {
      if (wallet[i].coin.id == currency.coin.id) {
        balance += (wallet[i].amount - currency.amount) * currency.coin.value;
        wallet[i].amount = currency.amount;
        wallet[i].valueUsd = wallet[i].amount * currency.coin.value;
        if (wallet[i].amount <= 0) wallet.removeAt(i);
        notifyListeners();

        break;
      }
    }
  }

  void changeBalance(double amount, bool add) {
    add ? (balance += amount) : (balance -= amount);
    notifyListeners();
  }

  void calculateNetExpectedProfit() {
    if (wallet.isNotEmpty) {
      double sumRevenue = 0;
      double sumExpenditure = 0;

      wallet.forEach((element) {
        sumRevenue += element.valueUsd;
        sumExpenditure += element.buyingPricePerCoin * element.amount;
        print('is not empty');
      });
      amountInWalletUsd = sumRevenue;
      profit = sumRevenue - sumExpenditure;
    } else {
      profit = 0;
      print('is empty');
    }
    notifyListeners();
  }

  void addTransaction(transaction) {
    transactions.add(transaction);
    notifyListeners();
  }
  void saveToStorage(UserData data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String json = jsonEncode(data);
    prefs.setString('myData', json);

    String url = "http://192.168.10.4:3000/users/baighamza02@gmail.com";


    Response response = await patch(
        Uri.parse(url),
        body:json,
        headers:{
          'Content-Type':
          'application/json',
        }
    );

    print(response.statusCode);
    print(response.body);
    print(json);


  }

  void calculatePoints() {}

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'emailID': emailID,
      'balance': balance,
      'profit': profit,
      'points': points,
      'wallet': wallet,
      'transactions': transactions,
    };
  }

  factory UserData.fromJson(dynamic json) {
    var tagObjsJson = json['wallet'] as List;
    var tagObjsJson2 = json['transactions'] as List;
    List<CryptoCurrency> wallet =
    tagObjsJson.map((tagJson) => CryptoCurrency.fromJson(tagJson)).toList();
    List<Transaction> transactions =
    tagObjsJson2.map((tagJson) => Transaction.fromJson(tagJson)).toList();

    return UserData(json['name'] as String, wallet, json['balance'] as double,
        json['profit'] as double, json['points'] as int, transactions,"baighmza02@gmail.com");
  }
}
