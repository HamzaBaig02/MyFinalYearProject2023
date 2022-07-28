import 'package:crypto_trainer/models/user_data.dart';
import 'package:crypto_trainer/screens/loading.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //data from disk
  SharedPreferences pref = await SharedPreferences.getInstance();
  String data = '';
  try {
    data = pref.getString('myData') ?? '';
  } on Exception catch (e) {
    print(e);
  }

  UserData user;

  if (data.isNotEmpty) {
    Map json = jsonDecode(data);
    user = UserData.fromJson(json);
  } else {
    user = UserData('Hamza Baig', [], 10000, 0, 0, [],"baighamza02@gmail.com");
  }



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

