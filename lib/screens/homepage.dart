import 'package:crypto_trainer/models/coin_data.dart';
import 'package:crypto_trainer/screens/loading.dart';
import 'package:crypto_trainer/widgets/bookmark_list.dart';
import 'package:crypto_trainer/widgets/crypto_list.dart';
import 'package:crypto_trainer/widgets/portfolio_pie_chart.dart';
import 'package:crypto_trainer/widgets/transaction_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:crypto_trainer/widgets/useInfo_card.dart';
import 'package:crypto_trainer/services/crypto_network.dart';
import 'package:provider/provider.dart';

import '../models/user_data.dart';

class UserHomePage extends StatefulWidget {
  List<CoinData> coinList;

  UserHomePage(this.coinList);

  @override
  _UserHomePageState createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage> {
  var searchBarBorderColor = Color(0xffc7c0c0);
  PageController _pageController = PageController();
  @override
  Widget build(BuildContext context) {

    print('homepage rebuilt');
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        bottomNavigationBar: MyBottomNavBar(onTappedBar),
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
                        CryptoList(widget.coinList),
                        Center(
                          child: Container(
                            child: PortfolioPieChart(),
                          ),
                        ),
                        TransactionList(),
                        BookMarkList(),
                      ],
                      onPageChanged: (page) {
                        Provider.of<BottomNavigationBarProvider>(context,
                                listen: false)
                            .setCurrentIndex(page);
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

  void onTappedBar(int value) {
    Provider.of<BottomNavigationBarProvider>(context, listen: false)
        .setCurrentIndex(value);
    _pageController.animateToPage(value,
        duration: Duration(milliseconds: 250), curve: Curves.ease);
  }
}

class MyBottomNavBar extends StatelessWidget {
  final Function(int)? onTapped;

  MyBottomNavBar(this.onTapped);

  @override
  Widget build(BuildContext context) {
    print('bottom nav bar rebuilt');
    return BottomNavigationBar(
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
        BottomNavigationBarItem(
          icon: Icon(FontAwesomeIcons.bookmark),
          label: 'Favorites',
        ),
      ],
      type: BottomNavigationBarType.fixed,
      currentIndex:
          Provider.of<BottomNavigationBarProvider>(context).currentIndex,
      selectedItemColor: Color(0xff8b4a6c),
      unselectedItemColor: Colors.grey.shade500,
      showUnselectedLabels: true,
      onTap: onTapped,
    );
  }
}
