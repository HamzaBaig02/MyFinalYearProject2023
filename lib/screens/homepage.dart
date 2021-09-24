import 'package:crypto_trainer/widgets/crypto_list.dart';
import 'package:crypto_trainer/widgets/transaction_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:crypto_trainer/widgets/useInfo_card.dart';
import 'package:crypto_trainer/services/crypto_network.dart';

class UserHomePage extends StatefulWidget {
  CryptoNetwork mynetwork;

  UserHomePage(this.mynetwork);

  @override
  _UserHomePageState createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage> {
  int _selectedIndex = 0;
  PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.user),
              label: 'User',
            ),
            BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.moneyBillWave),
              label: 'Transactions',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Color(0xff8b4a6c),
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
              _pageController.jumpToPage(index);
            });
          },
        ),
        backgroundColor: Colors.grey.shade200,
        body: SafeArea(
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 0, horizontal: 3),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                UserInfoCard(),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                      ),
                    ),
                    child: PageView(
                      controller: _pageController,
                      children: <Widget>[
                        CryptoList(widget.mynetwork),
                        Center(
                          child: Container(
                            child: Text('User Information'),
                          ),
                        ),
                        TransactionList()
                      ],
                      onPageChanged: (page) {
                        setState(() {
                          _selectedIndex = page;
                        });
                      },
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
