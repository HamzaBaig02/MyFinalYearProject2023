import 'package:crypto_trainer/models/transaction.dart';
import 'package:flutter/services.dart';
import 'package:crypto_trainer/models/crypto_currency.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:crypto_trainer/models/user_data.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class Sell extends StatefulWidget {
  CryptoCurrency ownedCrypto;
  double amount = 0;
  double valueUsd = 0;
  Sell(this.ownedCrypto) {
    amount = ownedCrypto.amount;
    valueUsd = ownedCrypto.valueUsd;
  }

  @override
  _SellState createState() => _SellState();
}

class _SellState extends State<Sell> {
  var _controller = TextEditingController();
  // void saveToStorage() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String json = jsonEncode(Provider.of<UserData>(context, listen: false));
  //   prefs.setString('myData', json);
  //   //print(prefs.getString('myData'));
  // }

  double userInput = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          color: Colors.grey.shade200,
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    children: [
                      Container(
                        width: 350,
                        height: 255,
                      ),
                      Positioned.fill(
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                            ),
                            padding: EdgeInsets.all(10),
                            width: 318,
                            height: 220,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  child: Text(
                                    'REMAINING',
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Expanded(
                                      child: Container(
                                        alignment: Alignment.centerRight,
                                        child: SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Text(
                                            '${(widget.amount > 1 ? widget.amount.toStringAsFixed(2) : widget.amount)}',
                                            style: TextStyle(
                                              fontSize: 30,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Expanded(
                                      child: Container(
                                        child: Text(
                                          '${widget.ownedCrypto.coin.symbol.toUpperCase()}',
                                          style: TextStyle(
                                              fontSize: 30,
                                              color: Colors.grey,
                                              fontWeight: FontWeight.w300),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                Divider(
                                  thickness: 1.2,
                                ),
                                Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: Container(
                                            alignment: Alignment.centerRight,
                                            child: SingleChildScrollView(
                                              scrollDirection: Axis.horizontal,
                                              child: Text(
                                                '${widget.valueUsd.toStringAsFixed(2)}',
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                          child: Container(
                                            child: Text(
                                              'USD',
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.grey,
                                                  fontWeight: FontWeight.w300),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Positioned.fill(
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: Hero(
                            tag: '${widget.ownedCrypto.coin.id}',
                            child: CircleAvatar(
                              backgroundColor: Colors.transparent,
                              radius: 30,
                              foregroundImage: NetworkImage(
                                  widget.ownedCrypto.coin.imageUrl),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 40),
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Colors.black12,
                        width: 2,
                      ),
                    ),
                    child: TextField(
                      controller: _controller,
                      // inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      keyboardType: TextInputType.number,
                      onChanged: (value) {

                        setState(() {

                          value.isEmpty ? value = 0.toString() : value;
                          userInput = double.parse(value);
                          widget.amount = widget.ownedCrypto.amount -
                              (double.parse(value)) /
                                  widget.ownedCrypto.coin.value;
                          widget.valueUsd = widget.ownedCrypto.valueUsd -
                              (double.parse(value));
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Enter Amount In USD',
                        prefixIcon: Icon(
                          FontAwesomeIcons.dollarSign,
                          color: Colors.black12,
                        ),
                        suffixIcon: IconButton(icon:Icon(FontAwesomeIcons.angleDoubleUp,
                            color: Colors.black12),onPressed: (){
                          String value = widget.ownedCrypto.valueUsd.toString();
                          _controller.text = value;

                          setState(() {

                            value.isEmpty ? value = 0.toString() : value;
                            userInput = double.parse(value);
                            widget.amount = widget.ownedCrypto.amount -
                                (double.parse(value)) /
                                    widget.ownedCrypto.coin.value;
                            widget.valueUsd = widget.ownedCrypto.valueUsd -
                                (double.parse(value));
                          });




                        },),
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 120,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ShopButton('Sell', () {
                        if (userInput > widget.ownedCrypto.valueUsd ||
                            userInput <= 0) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Insufficient Crypto Balance'),
                            ),
                          );
                        } else {
                          CryptoCurrency currency = CryptoCurrency(
                              widget.ownedCrypto.coin, widget.amount);
                          Transaction transaction = Transaction(
                              DateTime.now(),
                              CryptoCurrency(widget.ownedCrypto.coin,
                                  widget.ownedCrypto.amount - widget.amount),
                              'Sold');
                          Provider.of<UserData>(context, listen: false)
                              .sellCrypto(currency);
                          Provider.of<UserData>(context, listen: false)
                              .addTransaction(transaction);
                          print('Transaction: $transaction');
                          Provider.of<UserData>(context,listen: false).saveToStorage(Provider.of<UserData>(context,listen:false));

                          Navigator.pop(context);
                        }
                      }, Colors.green.shade400),
                      SizedBox(
                        width: 60,
                      ),
                      ShopButton('Cancel', () {
                        Navigator.pop(context);
                      }, Colors.red.shade400),
                    ],
                  ),
                ],
              ),
            ),
          )),
    );
  }
}

class ShopButton extends StatelessWidget {
  String label;
  VoidCallback onPressed;
  Color color;

  ShopButton(this.label, this.onPressed, this.color);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.w300),
        ),
        height: 50,
        width: 100,
        decoration: BoxDecoration(
            color: color, borderRadius: BorderRadius.circular(20)),
      ),
    );
  }
}
