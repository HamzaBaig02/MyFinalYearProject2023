import 'package:crypto_trainer/models/crypto_currency.dart';
import 'package:crypto_trainer/screens/sell_screen.dart';
import 'package:crypto_trainer/services/functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../models/settings.dart';
import '../models/transaction.dart';
import '../models/user_data.dart';
import '../widgets/transaction_tile.dart';
class AssetDetailsScreen extends StatefulWidget {

  CryptoCurrency asset;


  AssetDetailsScreen({required this.asset});

  @override
  _AssetDetailsScreenState createState() => _AssetDetailsScreenState();
}

class _AssetDetailsScreenState extends State<AssetDetailsScreen> {

  List<Transaction> transactionList = [];

  void generateList(){

      transactionList = [];
      Provider.of<UserData>(context,listen: false).transactions.forEach((element) {
        if(element.crypto.coin.id == widget.asset.coin.id)
          transactionList.add(element);
      });

  }

  void updateList(){
    if(mounted)
    {
      if (Provider.of<Settings>(context, listen: true).sold) {
        generateList();
      }
    }
  }

 @override
  void initState() {
    // TODO: implement initState
    super.initState();
    generateList();
  }

  @override
  Widget build(BuildContext context) {
    print('Asset Screen rebuilt');
    Map myMap = Provider.of<UserData>(context).calculateIndividualRates(widget.asset.coin.id);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xff8b4a6c),
        child: Icon(FontAwesomeIcons.minusCircle,color: Colors.white,size: 25,),
        onPressed: (){
          Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) {
            return Sell(widget.asset);
          }),
        );
      },),
        body: SafeArea(child: Container(
      padding: EdgeInsets.all(5),
      child:Wrap(
        runSpacing: 5,
        children: [
          Row(
            children: [Hero(tag:'${widget.asset.coin.id}',child: CircleAvatar(radius: getFontSize(context, 5),backgroundColor: Colors.grey.shade200,foregroundImage: NetworkImage(widget.asset.coin.imageUrl),)),SizedBox(width: 5,),Text(widget.asset.coin.name,style: TextStyle(color: Colors.grey,fontWeight: FontWeight.w300,fontSize: getFontSize(context, 4.2
            )),)],
          ),
          SizedBox(height: 16,width:10),

          Row(children: [Text('${formatNumber(widget.asset.amount)}',style: TextStyle(color: Colors.grey.shade700,fontSize: getFontSize(context, 3.8)),),
            SizedBox(width: 3,),
            Text(widget.asset.coin.symbol.toUpperCase(),style: TextStyle(color: Colors.grey,letterSpacing: 0.6,fontSize: getFontSize(context, 2.8)),)],),

          Row(
            children: [
              Text('\$${formatNumber(widget.asset.valueUsd)}',style: TextStyle(color:Colors.black,fontSize: getFontSize(context, 5.7),fontWeight: FontWeight.bold)),
              SizedBox(width: 10,),
              Text('${widget.asset.percentChange.toStringAsFixed(2)}%',style: TextStyle(fontSize: getFontSize(context, 2.8),color: percentColor(widget.asset.percentChange)),)

            ],
          ),


          Row(
            children: [
              Expanded(
                child: Material(
                  //borderRadius:BorderRadius.all(Radius.circular(10)),
                  elevation: 1,
                  color: Colors.white,
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      children: [
                        Text('Buying Rate',style: TextStyle(color: Colors.grey.shade700,fontSize: getFontSize(context, 3.0))),
                        SizedBox(height: 5,),
                        Text('\$${formatNumber(myMap['buying'])}',style: TextStyle(color: Colors.black,fontSize: getFontSize(context, 3.3)))
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(width: 2,),
              Expanded(
                child: Material(
                  //borderRadius:BorderRadius.all(Radius.circular(10)),
                  elevation: 1,
                  color: Colors.white,
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('Selling Rate',style: TextStyle(color: Colors.grey.shade700,fontSize: getFontSize(context, 3.0))),
                        SizedBox(height: 5,),
                        Text('\$${formatNumber(myMap['selling'])}',style: TextStyle(color: Colors.black,fontSize: getFontSize(context, 3.3)))
                      ],
                    ),
                  ),
                ),
              ),

            ],
          ),

          Text('Trade History',style: TextStyle(fontWeight: FontWeight.w400,fontSize: getFontSize(context,4.4),letterSpacing: 1,color: Colors.grey.shade700),),
          Material(
            //borderRadius:BorderRadius.only(bottomLeft: Radius.circular(10),bottomRight: Radius.circular(10)),
            color: Colors.transparent,

            child: AssetTransactionList(transactionList: transactionList,),
          ),

        ],
      )

    ))
    );
  }
}

class InfoTile extends StatelessWidget {

  final String title;
  final double amount;
  final bool addDollarSign;
  final bool addPercent;


  InfoTile({required this.title, required this.amount,this.addDollarSign = true,this.addPercent = false});

  @override
  Widget build(BuildContext context) {
    return Row(children: [Text('$title: ',style: TextStyle(fontSize: getFontSize(context, 3),color: Colors.grey.shade600,letterSpacing:0.5),),addPercent?Text('${formatNumber(amount)}%',style: TextStyle(color: percentColor(amount),fontSize: getFontSize(context, 2.6)),)
        :Text(addDollarSign?'\$${formatNumber(amount)}':'${formatNumber(amount)}',style: TextStyle(fontSize: getFontSize(context, 2.6))),]);
  }
}


class AssetTransactionList extends StatelessWidget {
  final List<Transaction> transactionList;

  AssetTransactionList({required this.transactionList});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10),bottomRight: Radius.circular(10)),
          color: Colors.white),
      child: transactionList
          .isNotEmpty
          ? ListView.separated(
        separatorBuilder: (context, index) {
          return Divider(
            height: 1,
            thickness: 1,
            color: Colors.grey.shade100,
          );
        },
        physics: ClampingScrollPhysics(),
        scrollDirection: Axis.vertical,
        itemBuilder: (context, index) {
          return TransactionTile(
              transaction: transactionList[
              (transactionList
                  .length - 1) -
                  index],showPercent: true,);
        },
        itemCount:transactionList.length,
      )
          : Center(
        child: Text('Transaction history is empty'),
      ),
    );
  }
}