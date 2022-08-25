import 'package:flutter/material.dart';

import '../models/coin_data.dart';
import 'coin_tile.dart';

class BookMarkList extends StatelessWidget {
  List<CoinData> coinList;
  List<CoinData> filteredList = [];

  BookMarkList(this.coinList);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.separated(
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.vertical,
        itemBuilder: (context, index) {
          return filteredList.isNotEmpty ? CoinTile(
              filteredList[index]
          ):CoinTile(
              coinList[index]
          );
        },
        itemCount: filteredList.isEmpty ? coinList.length : filteredList.length,
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
