
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/user_data.dart';
import '../services/functions.dart';
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


  @override
  void initState() {
    // TODO: implement initState
    super.initState();


  }


  @override
  Widget build(BuildContext context) {

    return SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 5),
          decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10))),
          padding: EdgeInsets.only(left: 5,top: 5,right: 5),


            child: Wrap(
                runSpacing: 8,
              children: [
                PortfolioPieChart(),
                Text('Buying/Selling Rates',style: TextStyle(fontSize: getFontSize(context, 4),fontWeight: FontWeight.bold,color: domColor),),
                Provider.of<UserData>(context).wallet.isEmpty?SizedBox():BuyingSellingRates(),

              ],
            ),),);
  }
}

