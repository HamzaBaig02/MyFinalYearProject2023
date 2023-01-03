import 'package:crypto_trainer/constants/showcase_keys.dart';
import 'package:crypto_trainer/models/coin_data.dart';
import 'package:crypto_trainer/screens/loading.dart';
import 'package:crypto_trainer/screens/user_page.dart';
import 'package:crypto_trainer/widgets/bookmark_list.dart';
import 'package:crypto_trainer/widgets/crypto_list.dart';
import 'package:crypto_trainer/widgets/transaction_list.dart';
import 'package:crypto_trainer/widgets/welcome_bottomsheet.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:crypto_trainer/widgets/useInfo_card.dart';
import 'package:provider/provider.dart';
import 'package:showcaseview/showcaseview.dart';

import '../models/settings.dart';
import '../models/user_data.dart';
import '../services/functions.dart';
import '../widgets/custom_showcase.dart';
import 'login_signup.dart';

class UserHomePage extends StatefulWidget {
  List<CoinData> coinList;

  UserHomePage(this.coinList);

  @override
  _UserHomePageState createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage> {
  var searchBarBorderColor = Color(0xffc7c0c0);
  PageController _pageController = PageController();
  void startShowCase(){
    ShowCaseWidget.of(context).startShowCase([
      coinTileKey,
      coinTileValueKey,
      coinTilePercentageChangeKey,
      coinTilePercentageChangeKey2,
      searchBarKey,
      infoCardKey,
      walletButtonKey
    ]);
  }

 @override
  void initState() {
    // TODO: implement initState

    super.initState();
    
    WidgetsBinding.instance.addPostFrameCallback((_) async {

      int x = await loadShowedTutorial(name: 'homePage') ;

      if(x == 1){
        print("Tutorial Already Showed");
      }
      else if(x == 0) {
        showModalBottomSheet(context: context, builder: (BuildContext context) {
          return Container(
            child : Wrap(
              children: [WelcomeSheet(onTap:() async {
                Navigator.pop(context);
                await Future.delayed(Duration(milliseconds: 300));
                startShowCase();
              } ,),],
            ),
          );

        },backgroundColor: Colors.transparent,isScrollControlled: true);}
      storeShowedTutorial(value: 1, name: 'homePage');

    });





  }
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
                CustomShowCase(
                  refKey: infoCardKey,
                  description:showCaseDescriptions['userInfoCard'].toString(),
                  child: UserInfoCard(callback: (){

                    FirebaseAuth.instance.signOut();
                    Provider.of<Settings>(context, listen: false).setGuestUser(0);
                    saveSettingsToStorage(0);
                    Provider.of<UserData>(context, listen: false).clear();
                    Navigator.pop(context);
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => LoginSignUp()));
                  },),
                ),
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
                        UserPage(),
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
