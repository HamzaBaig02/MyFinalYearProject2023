import 'package:crypto_trainer/Utilities/ErrorSnackBar.dart';
import 'package:crypto_trainer/screens/login_signup.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:async/async.dart';
import '../constants/colors.dart';
import '../models/coin_data.dart';
import '../models/settings.dart';
import '../models/user_data.dart';
import '../services/functions.dart';

class BookmarkButton extends StatefulWidget {
  final CoinData coin;


  BookmarkButton({required this.coin});

  @override
  State<BookmarkButton> createState() => _BookmarkButtonState();
}

class _BookmarkButtonState extends State<BookmarkButton> {
  bool functionTriggered = false;
  IconData icon = FontAwesomeIcons.bookmark;

  RestartableTimer? timer;

  bool isBookmarked(CoinData coin){
    List<CoinData> list = Provider.of<UserData>(context,listen:false).bookmarks;

    for(int i = 0;i < list.length;i++){
      if(list[i] == coin)
        return true;
    }

    return false;

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if(isBookmarked(widget.coin))
      icon = FontAwesomeIcons.solidBookmark;

  }

  void addBookmark(){
    Provider.of<UserData>(context,listen:false).addBookmark(widget.coin);

    if (Provider.of<Settings>(context,
        listen: false).isGuest == false) {
      storeUserDataOnCloud(context, Provider.of<UserData>(context,listen:false));
    }
    else{
      Provider.of<UserData>(context,listen: false).saveToStorage(Provider.of<UserData>(context,listen:false));
    }
    print('Bookmark Added');
    ErrorSnackBar().errorSnackBar(error: 'Bookmark Added', context: context,color: domColor);
    functionTriggered = false;
  }
  void removeBookmark(){
    Provider.of<UserData>(context,listen:false).removeBookmark(widget.coin);

    if (Provider.of<Settings>(context,
        listen: false).isGuest == false) {
      storeUserDataOnCloud(context, Provider.of<UserData>(context,listen:false));
    }
    else{
      Provider.of<UserData>(context,listen: false).saveToStorage(Provider.of<UserData>(context,listen:false));
    }
    print('Bookmark removed');
    ErrorSnackBar().errorSnackBar(error: 'Bookmark Removed', context: context,color: domColor);
    functionTriggered = false;
  }
  void buttonPressHandler(){
    if(icon == FontAwesomeIcons.bookmark){
      setState(() {
        icon = FontAwesomeIcons.solidBookmark;
      });
      if (timer?.isActive ?? false) {
        timer?.reset();
      } else {
        timer = RestartableTimer(Duration(milliseconds: 1500), addBookmark);
      }

    }
    else{
      setState(() {
        icon = FontAwesomeIcons.bookmark;
      });

      if (timer?.isActive ?? false) {
        timer?.reset();
      } else {
        timer = RestartableTimer(Duration(milliseconds: 1500), removeBookmark);
      }


    }
  }
  void buttonPressHandlerExit(){
    if(icon == FontAwesomeIcons.bookmark){

        icon = FontAwesomeIcons.solidBookmark;

      if (timer?.isActive ?? false) {
        timer?.reset();
      } else {
        timer = RestartableTimer(Duration(milliseconds: 1000), addBookmark);
      }

    }
    else{

        icon = FontAwesomeIcons.bookmark;


      if (timer?.isActive ?? false) {
        timer?.reset();
      } else {
        timer = RestartableTimer(Duration(milliseconds: 1000), removeBookmark);
      }


    }
  }



  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap:() {
        buttonPressHandler();
        },
      child: Icon(icon,color: Color(
          0xff8b4a6c),),
    );
  }
}