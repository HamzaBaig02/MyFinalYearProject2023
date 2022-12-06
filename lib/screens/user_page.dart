
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/user_data.dart';
import '../widgets/portfolio_pie_chart.dart';


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
          // margin: EdgeInsets.symmetric(vertical: 5),
          // decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10))),
          // padding: EdgeInsets.only(left: 5,top: 5,right: 5),
            height: MediaQuery.of(context).size.height-200,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //Text('Asset Distribution',style: TextStyle(fontSize: getFontSize(context, 4)),),
                Flexible(fit:FlexFit.loose,child: PortfolioPieChart()),


                //Flexible(flex:1,fit: FlexFit.loose,child: Text('Buying/Selling Rates'))
              ],
            ),),);
  }
}

