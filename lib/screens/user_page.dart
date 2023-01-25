
import 'dart:async';

import 'package:crypto_trainer/widgets/top_three_coin.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../constants/colors.dart';
import '../models/user_data.dart';
import '../services/functions.dart';
import '../services/transaction_sorting_functions.dart';
import '../widgets/buying_selling_rates.dart';
import '../widgets/portfolio_pie_chart.dart';
import '../widgets/user_graph.dart';
import 'login_signup.dart';


class UserPage extends StatefulWidget {
  const UserPage({Key? key}) : super(key: key);

  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  Map<String, dynamic> topThreeCoinData = {};
  Timer? timer;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    timer?.cancel();
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    timer = Timer(Duration(seconds: 2), () {
      getTopThreeCoins();
    });

  }


  getTopThreeCoins() async {
    topThreeCoinData = await compute(topThreeCoins,Provider.of<UserData>(context, listen: false).transactions);
    setState(() {
    print(topThreeCoinData);
    });
  }

  @override
  Widget build(BuildContext context) {

    return Provider.of<UserData>(context,listen:true).wallet.isEmpty?
    Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
    Lottie.asset('assets/images/astronaut.json',
    height: MediaQuery.of(context).size.height * 0.3),
    // SizedBox(width: 4,),
    Text('Nothing to see here...\nBuy crypto to get started',
    style: TextStyle(
    fontSize: getFontSize(context, 2), fontWeight: FontWeight.bold,color: domColor)),
    ],
    ):SingleChildScrollView(

           child: Container(
          margin: EdgeInsets.symmetric(vertical: 5),
          decoration: BoxDecoration(borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10)),color: Colors.white),



            child: Wrap(
                runSpacing: 8,
              children: [
                //Text('Portfolio Distribution',style: TextStyle(color: domColor,fontWeight: FontWeight.w300,fontSize: getFontSize(context, 4)),),
                SizedBox(height: 10,),
                Container(
                    decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(10)),
                    padding: EdgeInsets.all(10),
                    child: PortfolioPieChart()),
                //Text('Buying/Selling Rates',style: TextStyle(fontSize: getFontSize(context, 4),fontWeight: FontWeight.bold,color: domColor),),
                // BuyingSellingRates(),
                SizedBox(height: 10,),
                Text('Trading Performance',style: TextStyle(color: domColor,fontWeight: FontWeight.w300,fontSize: getFontSize(context, 4)),),
                Container(
                    decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(10)),
                    padding: EdgeInsets.all(10),
                    child: UserGraph()),
                (topThreeCoinData.isEmpty && Provider.of<UserData>(context, listen: false).wallet.length < 3)?SizedBox():Text('Top Three Coins',style: TextStyle(color: domColor,fontWeight: FontWeight.w300,fontSize: getFontSize(context, 4)),),
                (topThreeCoinData.isEmpty && Provider.of<UserData>(context, listen: false).wallet.length < 3)?SizedBox():
                TopThreeCoins(topThreeCoinData)

              ],
            ),),);
  }
}

