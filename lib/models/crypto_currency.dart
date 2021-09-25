import 'package:crypto_trainer/models/coin_data.dart';

class CryptoCurrency {
  CoinData coin;
  double amount = 0;
  double valueUsd = 0;
  double percentChange = 0;
  double buyingPrice = 0;

  CryptoCurrency(this.coin, this.amount) {
    valueUsd = amount * coin.value;
    buyingPrice = coin.value;
    // percentChange = ((amount * coin.value) - (buyingPrice * amount)) /
    //     (buyingPrice * amount) *
    //     100;
  }

  setPercentChanged() {
    percentChange =
        ((valueUsd) - (buyingPrice * amount)) / (buyingPrice * amount) * 100;
  }

  setValueUSD() {
    valueUsd = amount * coin.value;
  }

  @override
  String toString() {
    return 'CryptoCurrency{coin: $coin, amount: $amount, valueUsd: $valueUsd}';
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
