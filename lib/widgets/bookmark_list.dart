import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/coin_data.dart';
import '../models/user_data.dart';
import 'coin_tile.dart';

class BookMarkList extends StatelessWidget {

  List<CoinData> filteredList = [];


  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 5, 0, 0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(10),
            topLeft: Radius.circular(10),
          ),
          color: Colors.white),
      child: ListView.separated(
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.vertical,
        itemBuilder: (context, index) {
          return filteredList.isNotEmpty ? CoinTile(
              filteredList[index]
          ):CoinTile(
              Provider.of<UserData>(context,listen:true).bookmarks[
              Provider.of<UserData>(context,listen:true).bookmarks.length - 1 -
                index]
          );
        },
        itemCount: filteredList.isEmpty ? Provider.of<UserData>(context,listen:true).bookmarks.length : filteredList.length,
        separatorBuilder: (context, index) {
          return Divider(
            height: 1,
            thickness: 1,
            color: Colors.grey.shade100,
          );
        },
      ),
    );
  }
}
