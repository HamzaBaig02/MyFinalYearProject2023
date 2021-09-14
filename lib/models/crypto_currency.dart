import 'package:crypto_trainer/models/coin_data.dart';

class CryptoCurrency {
  CoinData coin;
  double amount = 0;
  double valueUsd = 0;
  double percentChange = 0;
  double buyingPrice = 0;

  CryptoCurrency(this.coin, this.amount) {
    //percentChange = ((amount * coin.value) - valueUsd) / valueUsd;
    valueUsd = amount * coin.value;
    buyingPrice += valueUsd;
    percentChange = ((amount * coin.value) - buyingPrice) / buyingPrice * 100;
  }

  setPercentChanged(double coinValue) {
    percentChange = ((amount * coinValue) - buyingPrice) / buyingPrice * 100;
  }

  setValueUSD(double coinValue) {
    valueUsd = amount * coinValue;
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
