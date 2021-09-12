import 'package:crypto_trainer/models/coin_data.dart';
import 'package:crypto_trainer/models/crypto_currency.dart';
import 'package:crypto_trainer/models/user_data.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class UserDatabase {
  late Database _db;

  initDb() async {
    final database = openDatabase(
      join(await getDatabasesPath(), 'myData.db'),
      onCreate: populateDb,
      version: 1,
    );
    return database;
  }

  void populateDb(Database database, int version) async {
    await _db.execute(
      'CREATE TABLE User(id INTEGER PRIMARY KEY, name TEXT, balance REAL,profit REAL,points REAL)',
    );
    await _db.execute(
      'CREATE TABLE Wallet(id INTEGER PRIMARY KEY,userID INTEGER,amount REAL)',
    );
    await _db.execute(
      'CREATE TABLE CoinData(id TEXT PRIMARY KEY,walletID INTEGER,name TEXT,symbol TEXT,value REAL,percentChange REAL,imageUrl TEXT)',
    );
  }

  // Future<int> createUser(UserData user) async {
  //   var result = await _db.rawInsert(
  //       "INSERT INTO User (userID, name, balance, profit, points)"
  //       " VALUES (${user.id},${user.name},${user.balance},${user.profit},${user.points})");
  //   return result;
  // }

  // Future<int> createWallet(int userID, CryptoCurrency wallet) async {
  //   var result = await _db.rawInsert("INSERT INTO Wallet (id, userID, amount)"
  //       " VALUES (${wallet.id},$userID,${wallet.amount})");
  //   return result;
  // }

  Future<int> insertCoin(CoinData coin, int walletID) async {
    var result = await _db.rawInsert(
        "INSERT INTO CoinData (id, walletID, name, symbol, value, percentChange, imageUrl)"
        " VALUES (${coin.id},$walletID,${coin.name},${coin.symbol},${coin.value},${coin.percentChange}${coin.imageUrl})");
    return result;
  }

  // Future<UserData> getUserDataFromDatabase(int userID) async {
  //   var userResults =
  //       await _db.rawQuery('SELECT * FROM User WHERE id = $userID');
  //   List<Map> walletResults =
  //       await _db.rawQuery('SELECT * FROM Wallet WHERE userID = $userID');
  //
  //   walletResults.forEach((element) {
  //
  //   });
  //   var coinDataResults =
  //
  // }

  Future<Database> get db async {
    if (_db != null) return _db;
    _db = await initDb();
    return _db;
  }
}
