import 'package:crypto_trainer/models/coin_data.dart';

class CryptoCurrency {
  CoinData coin;
  double amount = 0;
  double valueUsd = 0;
  double percentChange = 0;

  CryptoCurrency(this.coin, this.amount) {
    //percentChange = ((amount * coin.value) - valueUsd) / valueUsd;
    valueUsd = amount * coin.value;
  }

  setPercentChanged(double coinValue) {
    percentChange = ((amount * coinValue) - valueUsd) / valueUsd;
  }

  setValueUSD(double coinValue) {
    valueUsd = amount * coin.value;
  }

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
