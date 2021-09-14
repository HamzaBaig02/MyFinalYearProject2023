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

  void addCrypto(CryptoCurrency currency) {
    bool notPresent = true;
    wallet.forEach((element) {
      if (element.coin.id == currency.coin.id) {
        element.amount += currency.amount;
        notPresent = false;
        notifyListeners();
        return;
      }
    });
    if (notPresent) {
      wallet.add(currency);
      notifyListeners();
    }
  }

  void changeBalance(double balance, bool add) {
    add ? (this.balance += balance) : (this.balance -= balance);
    notifyListeners();
  }

  void calculateProfit() {}
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
