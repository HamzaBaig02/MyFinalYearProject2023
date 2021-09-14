import 'package:crypto_trainer/models/crypto_currency.dart';
import 'package:crypto_trainer/models/user_data.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class UserInfoCard extends StatefulWidget {
  @override
  _UserInfoCardState createState() => _UserInfoCardState();
}

class _UserInfoCardState extends State<UserInfoCard>
    with TickerProviderStateMixin {
  double balance = 10000;
  double profit = 245;

  var formatter = NumberFormat('#,##,000.00');

  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.fastLinearToSlowEaseIn,
    );
  }

  _toggleContainer() {
    print(_animation.status);
    if (_animation.status != AnimationStatus.completed) {
      _controller.forward();
    } else {
      _controller.animateBack(0, duration: Duration(milliseconds: 500));
    }
  }

  @override
  Widget build(BuildContext context) {
    balance = Provider.of<UserData>(context, listen: true).balance;
    profit = Provider.of<UserData>(context, listen: true).profit;
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            image: DecorationImage(
              fit: BoxFit.fill,
              image: AssetImage('assets/images/cardWavy.png'),
            ),
          ),
          padding: EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(Provider.of<UserData>(context, listen: true).name,
                      style: GoogleFonts.patuaOne(
                        textStyle: TextStyle(
                            color: Colors.white,
                            letterSpacing: .75,
                            fontSize: 25),
                      )),
                  SizedBox(
                    height: 5,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Balance',
                        style: TextStyle(
                            color: Colors.white,
                            letterSpacing: 1,
                            fontSize: 15),
                      ),
                      Text(
                        '\$ ${formatter.format(balance)}',
                        style: TextStyle(
                            letterSpacing: 1,
                            color: Colors.white,
                            fontSize: balance > 99999
                                ? (30 - balance.toString().length * 1.0)
                                : 25),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Estimated Profit',
                        style: TextStyle(
                            color: Colors.white,
                            letterSpacing: 1,
                            fontSize: 15),
                      ),
                      Text(
                        '\$ ${profit.toStringAsFixed(2)}',
                        style: TextStyle(
                            color: Colors.white,
                            letterSpacing: 1,
                            fontSize: profit > 99999
                                ? (30 - profit.toString().length * 1.0)
                                : 25),
                      ),
                    ],
                  )
                ],
              ),
              Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  CircleAvatar(
                    radius: 45,
                    backgroundColor: Colors.white,
                    child: CircleAvatar(
                      backgroundColor: Colors.grey.shade400,
                      radius: 40,
                      foregroundImage: AssetImage('assets/images/mfaraday.jpg'),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  MaterialButton(
                    shape: CircleBorder(),
                    onPressed: () {
                      print('Wallet Button Pressed');
                      _toggleContainer();
                    },
                    child: Icon(
                      FontAwesomeIcons.wallet,
                      color: Colors.white,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
        CryptoWallet(animation: _animation)
      ],
    );
  }
}

class CryptoWallet extends StatelessWidget {
  const CryptoWallet({
    Key? key,
    required Animation<double> animation,
  })  : _animation = animation,
        super(key: key);

  final Animation<double> _animation;

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor: _animation,
      axis: Axis.vertical,
      axisAlignment: -1,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
        ),
        height: 170,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Wallet',
              style: GoogleFonts.patuaOne(
                textStyle: TextStyle(
                    color: Color(0xff8b4a6c),
                    letterSpacing: 3,
                    fontSize: 35,
                    fontWeight: FontWeight.w700),
              ),
            ),
            Container(
              height: 120,
              child: ListView.builder(
                physics: BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return WalletTile(Provider.of<UserData>(context, listen: true)
                      .wallet[index]);
                },
                itemCount:
                    Provider.of<UserData>(context, listen: true).wallet.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WalletTile extends StatelessWidget {
  CryptoCurrency currency;

  WalletTile(this.currency);

  var cryptoFormatter = NumberFormat('0.00000');
  var dollarFormatter = NumberFormat('0,000.00');

  double dollars = 0;

  @override
  Widget build(BuildContext context) {
    dollars = currency.valueUsd;

    return Container(
      decoration: BoxDecoration(
        color: Color(0xff2e3340),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Color(0xff8b4a6c), width: 2),
      ),
      margin: EdgeInsets.all(2),
      padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            backgroundColor: Colors.white,
            radius: 16,
            child: CircleAvatar(
              backgroundColor: Colors.transparent,
              foregroundImage: NetworkImage(currency.coin.imageUrl),
              radius: 15,
            ),
          ),
          Column(
            children: [
              Text(
                '${currency.coin.symbol}',
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                '${cryptoFormatter.format(currency.amount)}',
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
              SizedBox(
                height: 2,
              ),
              Row(
                children: [
                  Text(
                    '\$${dollars > 999 ? dollarFormatter.format(dollars) : (dollars).toStringAsFixed(2)}',
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(width: 3),
                  Text(
                    '${currency.percentChange.toStringAsFixed(2)}%',
                    style: TextStyle(
                      fontSize: 10,
                      color: currency.percentChange > 0
                          ? Colors.green
                          : Colors.red,
                    ),
                  )
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
