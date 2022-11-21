import 'package:crypto_trainer/models/user_data.dart';
import 'package:crypto_trainer/screens/loading.dart';
import 'package:crypto_trainer/services/coin_information_stats.dart';
import 'package:crypto_trainer/services/functions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  UserData user = await fetchDataFromDisk();
  CoinInfo coinInfo = CoinInfo(coinId: '');
  runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => user,
          ),
          ChangeNotifierProvider(
            create: (context) => coinInfo ,
          ),
        ],
        child: MyApp(),

  )
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      theme: ThemeData(
        accentColor: Color(0xff8b4a6c),
      ),
      home: Loading(),
    );
  }
}

