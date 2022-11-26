import 'package:crypto_trainer/models/crypto_currency.dart';

class Transaction {
  DateTime date;
  CryptoCurrency crypto;
  String type;

  Transaction(this.date, this.crypto, this.type);

  Map<String, dynamic> toJson() {
    return {
      'date': date.toString(),
      'crypto': crypto,
      'type': type,
    };
  }
  Map<String, dynamic> toJsonFireStore() {
    return {
      'date': date.toString(),
      'crypto': crypto.toJsonFireStore(),
      'type': type,
    };
  }

  factory Transaction.fromJson(dynamic json) {
    return Transaction(DateTime.parse(json['date']),
        CryptoCurrency.fromJson(json['crypto']), json['type']);
  }

  @override
  String toString() {
    return 'Transaction{date: $date, crypto: $crypto, type: $type}';
  }
}
