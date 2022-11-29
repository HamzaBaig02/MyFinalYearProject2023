import 'package:crypto_trainer/models/user_data.dart';
import 'package:crypto_trainer/screens/loading.dart';
import 'package:crypto_trainer/screens/login_signup.dart';
import 'package:crypto_trainer/screens/verify_email_page.dart';
import 'package:crypto_trainer/services/coin_information_stats.dart';
import 'package:crypto_trainer/services/functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

import 'models/settings.dart';


Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  //UserData user = await fetchDataFromDisk();
  Settings settings = Settings();
  settings.setGuestUser(await fetchSettingsFromDisk());
  CoinInfo coinInfo = CoinInfo(coinId: '');
  runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => UserData('',[],10000,0,0,[],'Guest User',[]),
          ),
          ChangeNotifierProvider(
            create: (context) => coinInfo ,
          ),
          ChangeNotifierProvider(
            create: (context) => settings ,
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
      initialRoute: '/',
      theme: ThemeData(
        accentColor: Color(0xff8b4a6c),
      ),
      routes: {
        '/': (context) => StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot){
              if(snapshot.hasData)
                return VerifyEmail();
              else
                return LoginSignUp();
            }),
        '/loginSignup':(context)=>LoginSignUp()
      },
      // home: StreamBuilder<User?>(
      //   stream: FirebaseAuth.instance.authStateChanges(),
      //     builder: (context, snapshot){
      //     if(snapshot.hasData)
      //       return VerifyEmail();
      //     else
      //       return LoginSignUp();
      //     }),

    );
  }
}
//Loading()
