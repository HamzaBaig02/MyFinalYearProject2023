import 'package:crypto_trainer/models/crypto_currency.dart';

class Transaction {
  DateTime date;
  String transactionID;
  CryptoCurrency crypto;
  double price;

  Transaction(this.date, this.transactionID, this.crypto, this.price);
}
