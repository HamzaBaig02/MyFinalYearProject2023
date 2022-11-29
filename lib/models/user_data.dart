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
  String emailID = "Guest";
  double balance;
  double profit;
  int points = 0;
  List<Transaction> transactions = [];
  double amountInWalletUsd = 0;

  UserData(this.name, this.wallet, this.balance, this.profit, this.points,
      this.transactions,this.emailID,this.bookmarks);


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

    print(json);


  }

  void updateBookmarks({required List<CoinData> coinList}) {


    for(int i = 0;i < bookmarks.length;i++){
      for(int j = 0;j < coinList.length;j++){

        if(bookmarks[i].id == coinList[j].id){
          bookmarks[i] = coinList[j];
        }
      }
    }

    notifyListeners();

  }

  void addBookmark(CoinData coin){
    for(int i = 0;i < bookmarks.length;i++){
      if(bookmarks[i].id == coin.id){
        return;
      }
    }
    bookmarks.add(coin);
    notifyListeners();
  }
  void removeBookmark(CoinData coin){
    bookmarks.remove(coin);
    notifyListeners();
  }

  Map<String,double> calculateIndividualRates(String coinId){

    int buyCount = 0;
    int sellCount = 0;
    double buyingSum = 0;
    double sellingSum = 0;
    double avgBuyingRate = 0;
    double avgSellingRate = 0;

      for (int j = 0; j < this.transactions.length; j++) {
        if (coinId == transactions[j].crypto.coin.id) {
          if (transactions[j].type == 'Bought') {
            buyingSum = buyingSum + transactions[j].crypto.buyingPricePerCoin;
            buyCount++;
          }
          else if (transactions[j].type == 'Sold') {
            sellingSum = sellingSum + transactions[j].crypto.coin.value;
            sellCount++;
          }
        }
      }

      avgBuyingRate = buyingSum / buyCount;
      avgSellingRate = sellingSum / sellCount;

  return {'buying': avgBuyingRate, 'selling': avgSellingRate.isNaN ? 0 : avgSellingRate};
  }

  Map<String,Map<String,double>> calculateRates(){
    Map<String,Map<String,double>> myMap= {};
    int buyCount = 0;
    int sellCount = 0;
    double buyingSum = 0;
    double sellingSum = 0;
    double avgBuyingRate = 0;
    double avgSellingRate = 0;
    for(int i = 0;i < this.wallet.length;i++) {
      for (int j = 0; j < this.transactions.length; j++) {
        if (wallet[i].coin.id == transactions[j].crypto.coin.id) {
          if (transactions[j].type == 'Bought') {
            buyingSum = buyingSum + transactions[j].crypto.buyingPricePerCoin;
            buyCount++;
          }
          else if (transactions[j].type == 'Sold') {
            sellingSum = sellingSum + transactions[j].crypto.coin.value;
            sellCount++;
          }
        }
      }

      avgBuyingRate = buyingSum / buyCount;
      avgSellingRate = sellingSum / sellCount;
      myMap[wallet[i].coin.id] =
      {'buying': avgBuyingRate, 'selling': avgSellingRate};

      buyCount = 0;
      sellCount = 0;
      buyingSum = 0;
      sellingSum = 0;
      avgBuyingRate = 0;
      avgSellingRate = 0;
    }

    print(myMap);
    return myMap;
  }




  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'emailID': emailID,
      'balance': balance,
      'profit': profit,
      'points': points,
      'wallet': wallet,
      'transactions': transactions,
      'bookmarks': bookmarks,
    };
  }

  Map<String, dynamic> toJsonFireStore() {
    return {
      'name': name,
      'emailID': emailID,
      'balance': balance,
      'profit': profit,
      'points': points,
      'wallet': wallet.map((i) => i.toJsonFireStore()).toList(),
      'transactions': transactions.map((i) => i.toJsonFireStore()).toList(),
      'bookmarks': bookmarks.map((i) => i.toJson()).toList(),
    };
  }

  void loadFromCloud(dynamic  json){
   print(json);
    var tagObjsJson = json['wallet'] as List;
    var tagObjsJson2 = json['transactions'] as List;
    var tagObjsJson3 = (json['bookmarks'] ?? [ ]) as List;

    List<CryptoCurrency> wallet =
    tagObjsJson.map((tagJson) => CryptoCurrency.fromJson(tagJson)).toList();
    List<Transaction> transactions =
    tagObjsJson2.map((tagJson) => Transaction.fromJson(tagJson)).toList();
    List<CoinData> bookmarks =
    tagObjsJson3.map((tagJson) => CoinData.fromJson(tagJson)).toList();

    this.name = json['name'] as String;
    this.wallet = wallet;
    this.balance = json['balance'] as double;
    this.profit = json['profit'] as double;
    this.points = json['points'] as int??0;
    this.transactions = transactions;
    this.emailID = json['emailID'] as String ?? '';
    this.bookmarks = bookmarks;

    notifyListeners();

  }


  void clear(){
    this.name = 'User';
    this.wallet = [];
    this.balance = 10000;
    this.profit = 0;
    this.points = 0;
    this.transactions = [];
    this.emailID = 'Guest User';
    this.bookmarks = [];
    notifyListeners();
  }

  void load(UserData user){
    this.name = user.name ?? 'User';
    this.wallet = user.wallet ?? [];
    this.balance = user.balance ?? 10000;
    this.profit = user.profit ?? 0;
    this.points = user.points ?? 0;
    this.transactions = user.transactions ?? [];
    this.emailID = user.emailID ?? 'Guest User';
    this.bookmarks = user.bookmarks ?? [];
    notifyListeners();
  }

  factory UserData.fromJson(dynamic json) {
    var tagObjsJson = json['wallet'] as List;
    var tagObjsJson2 = json['transactions'] as List;
    var tagObjsJson3 = (json['bookmarks'] ?? [ ]) as List;




    List<CryptoCurrency> wallet =
    tagObjsJson.map((tagJson) => CryptoCurrency.fromJson(tagJson)).toList();
    List<Transaction> transactions =
    tagObjsJson2.map((tagJson) => Transaction.fromJson(tagJson)).toList();
    List<CoinData> bookmarks =
    tagObjsJson3.map((tagJson) => CoinData.fromJson(tagJson)).toList();


    return UserData(json['name'] as String, wallet, json['balance'] as double,
        json['profit'] as double, json['points'] as int, transactions,"Guest User", bookmarks);
  }
}
