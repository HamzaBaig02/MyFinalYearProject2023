import 'package:crypto_trainer/models/user_data.dart';
import 'package:crypto_trainer/screens/loading.dart';
import 'package:crypto_trainer/services/functions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  UserData user = await fetchDataFromDisk();
  runApp(
    ChangeNotifierProvider(
      create: (context) => user,
      child: MyApp(),
    ),
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

