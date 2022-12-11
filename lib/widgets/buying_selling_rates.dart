import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/user_data.dart';
import '../screens/login_signup.dart';
import '../services/functions.dart';

class BuyingSellingRates extends StatelessWidget {
  const BuyingSellingRates({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      child: ListView.builder(itemBuilder: (context,index){
        List wallet = Provider.of<UserData>(context).wallet;
        Map myMap = Provider.of<UserData>(context).calculateIndividualRates(wallet[index].coin.id);
        return Container(
          decoration: BoxDecoration(
            color: Color(0xff2e3340),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Color(0xff8b4a6c), width: 2),
          ),
          margin: EdgeInsets.all(2),
          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),

          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CircleAvatar(backgroundColor: Colors.transparent,foregroundImage: NetworkImage(Provider.of<UserData>(context).wallet[index].coin.imageUrl),radius: 15,),
              Text(wallet[index].coin.name,style: TextStyle(color: Colors.white),),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Buying: ',style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500)),
                  Text('\$${formatNumber(myMap['buying'])}',style: TextStyle(color: Colors.white)),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Selling: ',style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500)),
                  Text('\$${myMap['selling']==0?'N/A':formatNumber(myMap['selling'])}',style: TextStyle(color: Colors.white)),
                ],
              )
            ],),
        );
      },itemCount: Provider.of<UserData>(context).wallet.length,
          scrollDirection: Axis.horizontal),
    );
  }
}