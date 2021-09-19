import 'package:crypto_trainer/models/crypto_currency.dart';
import 'package:crypto_trainer/models/transaction.dart';
import 'package:flutter/cupertino.dart';

class UserData extends ChangeNotifier {
  List<CryptoCurrency> wallet;

  String name;
  double balance;
  double profit;
  int points;
  List<Transaction> transactions = [];

  UserData(this.name, this.wallet, this.balance, this.profit, this.points);

  void refresh() {
    notifyListeners();
  }

  void buyCrypto(CryptoCurrency currency) {
    bool notPresent = true;
    for (int i = 0; i < wallet.length; i++) {
      if (wallet[i].coin.id == currency.coin.id) {
        wallet[i].amount += currency.amount;
        wallet[i].buyingPrice = currency.buyingPrice;
        wallet[i].valueUsd = currency.coin.value * wallet[i].amount;
        wallet[i].setPercentChanged(currency.coin.value);
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
        wallet[i].setPercentChanged(currency.coin.value);
        wallet[i].valueUsd = currency.amount * currency.coin.value;
        if (wallet[i].amount <= 0) wallet.removeAt(i);

        notifyListeners();

        break;
      }
    }
  }

  void changeBalance(double amount, bool add) {
    add ? (this.balance += amount) : (this.balance -= amount);
    notifyListeners();
  }

  void calculateNetExpectedProfit() {
    if (wallet.isNotEmpty) {
      double sumRevenue = 0;
      double sumExpenditure = 0;

      wallet.forEach((element) {
        sumRevenue += element.valueUsd;
        sumExpenditure += element.buyingPrice * element.amount;
        print('is not empty');
      });

      profit = sumRevenue - sumExpenditure;
    } else {
      profit = 0;
      print('is empty');
    }
    notifyListeners();
  }

  void addTransaction() {}
  void calculatePoints() {}

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'balance': balance,
      'profit': profit,
      'points': points,
      'wallet': wallet,
    };
  }

  factory UserData.fromJson(dynamic json) {
    var tagObjsJson = json['wallet'] as List;
    List<CryptoCurrency> wallet =
        tagObjsJson.map((tagJson) => CryptoCurrency.fromJson(tagJson)).toList();

    return UserData(json['name'] as String, wallet, json['balance'] as double,
        json['profit'] as double, json['points'] as int);
  }
}
