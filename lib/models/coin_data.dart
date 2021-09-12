import 'package:flutter/material.dart';

class CoinData {
  String id = '';
  String name = '';
  String symbol = '';
  double value = 0;
  double percentChange = 0;
  String imageUrl = '';

  CoinData(this.id, this.name, this.symbol, this.value, this.percentChange,
      this.imageUrl);

  @override
  String toString() {
    return 'CoinData{name: $name, symbol: $symbol, value: $value, percentChange: $percentChange}';
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'symbol': symbol,
      'value': value,
      'percentChange': percentChange,
      'imageUrl': imageUrl,
    };
  }

  factory CoinData.fromJson(dynamic json) {
    return CoinData(
        json['id'] as String,
        json['name'] as String,
        json['symbol'] as String,
        json['value'] as double,
        json['percentChange'] as double,
        json['imageUrl'] as String);
  }
}
