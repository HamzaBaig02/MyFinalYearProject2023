import 'package:crypto_trainer/models/coin_data.dart';
import 'package:crypto_trainer/models/crypto_currency.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:crypto_trainer/models/user_data.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class Buy extends StatefulWidget {
  CoinData coinData;
  Buy(this.coinData);

  @override
  _BuyState createState() => _BuyState();
}

class _BuyState extends State<Buy> {
  double amount = 0;

  void saveToStorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String json = jsonEncode(Provider.of<UserData>(context, listen: false));
    prefs.setString('myData', json);
    print(prefs.getString('myData'));
  }

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
                  ShopInfoCard(widget.coinData, amount),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 30),
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color: Colors.green.shade400,
                        width: 2,
                      ),
                    ),
                    child: TextField(
                      onChanged: (value) {
                        setState(() {
                          value.isEmpty
                              ? amount = 0
                              : amount = (double.parse(value.toString()) /
                                  widget.coinData.value);
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Enter amount in USD',
                        prefixIcon: Icon(
                          FontAwesomeIcons.dollarSign,
                          color: Colors.green,
                        ),
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
                      ShopButton('Buy', () {
                        Provider.of<UserData>(context, listen: false).addCrypto(
                          CryptoCurrency(widget.coinData, amount),
                        );
                        Provider.of<UserData>(context, listen: false)
                            .changeBalance(
                                widget.coinData.value * amount, false);

                        Navigator.pop(context);
                        saveToStorage();
                      }, Colors.green.shade400),
                      SizedBox(
                        width: 40,
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

class ShopInfoCard extends StatelessWidget {
  final CoinData coinData;
  double amount = 0;

  ShopInfoCard(this.coinData, this.amount);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 350,
          height: 228,
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
              height: 200,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: Text(
                      'HOW MUCH ?',
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  CryptoAmountCard(amount: amount, coinData: coinData),
                  Divider(
                    thickness: 1.2,
                  ),
                  DollarAmountCard(coinData: coinData, amount: amount),
                ],
              ),
            ),
          ),
        ),
        Positioned.fill(
          child: Align(
            alignment: Alignment.topCenter,
            child: CircleAvatar(
              backgroundColor: Colors.transparent,
              radius: 30,
              foregroundImage: NetworkImage(coinData.imageUrl),
            ),
          ),
        )
      ],
    );
  }
}

class DollarAmountCard extends StatelessWidget {
  const DollarAmountCard({
    Key? key,
    required this.coinData,
    required this.amount,
  }) : super(key: key);

  final CoinData coinData;
  final double amount;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: Container(
            alignment: Alignment.centerRight,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Text(
                '${(coinData.value * amount).toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          width: 6,
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
    );
  }
}

class CryptoAmountCard extends StatelessWidget {
  const CryptoAmountCard({
    Key? key,
    required this.amount,
    required this.coinData,
  }) : super(key: key);

  final double amount;
  final CoinData coinData;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: Container(
            alignment: Alignment.centerRight,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Text(
                '${(amount > 1 ? amount.toStringAsFixed(2) : amount)}',
                style: TextStyle(
                  fontSize: 40,
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
              '${coinData.symbol}',
              style: TextStyle(
                  fontSize: 40,
                  color: Colors.grey,
                  fontWeight: FontWeight.w300),
            ),
          ),
        )
      ],
    );
  }
}
