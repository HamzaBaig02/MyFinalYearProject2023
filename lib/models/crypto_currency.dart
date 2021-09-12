import 'package:crypto_trainer/models/coin_data.dart';

class CryptoCurrency {
  CoinData coin;
  double amount = 0;

  CryptoCurrency(this.coin, this.amount);

  @override
  String toString() {
    return 'CryptoCurrency{coin: $coin, amount: $amount}';
  }

  Map<String, dynamic> toJson() {
    return {
      'coin': coin,
      'amount': amount,
    };
  }

  factory CryptoCurrency.fromJson(dynamic json) {
    return CryptoCurrency(
        CoinData.fromJson(json['coin']), json['amount'] as double);
  }
}
