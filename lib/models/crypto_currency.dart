import 'package:crypto_trainer/models/coin_data.dart';

class CryptoCurrency {
  CoinData coin;
  double amount = 0;
  double valueUsd = 0;
  double percentChange = 0;
  double buyingPricePerCoin = 0;

  CryptoCurrency(this.coin, this.amount) {
    valueUsd = amount * coin.value;
    buyingPricePerCoin = coin.value;
  }

  CryptoCurrency.fromFile(this.coin, this.amount, this.buyingPricePerCoin) {
    valueUsd = amount * coin.value;
  }

  void updateCoin(CoinData coin) {
    this.coin = coin;
    valueUsd = coin.value * amount;
    percentChange = ((valueUsd - (buyingPricePerCoin * amount)) /
            (buyingPricePerCoin * amount)) *
        100;
  }

  @override
  String toString() {
    return 'CryptoCurrency{coin: $coin, amount: $amount, valueUsd: $valueUsd}';
  }

  Map<String, dynamic> toJson() {
    return {
      'coin': coin,
      'amount': amount,
      'buyingPricePerCoin': buyingPricePerCoin,
    };
  }

  factory CryptoCurrency.fromJson(dynamic json) {
    return CryptoCurrency.fromFile(CoinData.fromJson(json['coin']),
        json['amount'] as double, json['buyingPricePerCoin'] as double);
  }
}
