import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../models/coin_data.dart';
import '../models/user_data.dart';

class BookmarkButton extends StatefulWidget {
  final CoinData coin;


  BookmarkButton({required this.coin});

  @override
  State<BookmarkButton> createState() => _BookmarkButtonState();
}

class _BookmarkButtonState extends State<BookmarkButton> {

  IconData icon = FontAwesomeIcons.bookmark;

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

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: (){
        if(icon == FontAwesomeIcons.bookmark){
          setState(() {
            icon = FontAwesomeIcons.solidBookmark;
          });

          Provider.of<UserData>(context,listen:false).bookmarks.add(widget.coin);
          Provider.of<UserData>(context,listen: false).saveToStorage(Provider.of<UserData>(context,listen:false));
        }
        else{
          setState(() {
            icon = FontAwesomeIcons.bookmark;
          });

          Provider.of<UserData>(context,listen:false).bookmarks.remove(widget.coin);
          Provider.of<UserData>(context,listen: false).saveToStorage(Provider.of<UserData>(context,listen:false));
        }
      },
      child: Icon(icon,color: Color(
          0xff8b4a6c),),
    );
  }
}