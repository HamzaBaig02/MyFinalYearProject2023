import 'package:crypto_trainer/models/crypto_currency.dart';

class Transaction {
  DateTime date;
  CryptoCurrency crypto;
  String type;
  double percentChange;


  Transaction(this.date, this.crypto, this.type,this.percentChange);

  Map<String, dynamic> toJson() {
    return {
      'date': date.toString(),
      'crypto': crypto,
      'type': type,
      'percentChange': percentChange,

    };
  }
  Map<String, dynamic> toJsonFireStore() {
    return {
      'date': date.toString(),
      'crypto': crypto.toJsonFireStore(),
      'type': type,
      'percentChange':percentChange,

    };
  }

  factory Transaction.fromJson(dynamic json) {
    return Transaction(DateTime.parse(json['date']),
        CryptoCurrency.fromJson(json['crypto']), json['type'],json['percentChange']??0);
  }

  @override
  String toString() {
    return 'Transaction{date: $date, crypto: $crypto, type: $type}';
  }
}
