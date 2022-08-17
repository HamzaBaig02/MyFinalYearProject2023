import 'package:cached_network_image/cached_network_image.dart';
import 'package:crypto_trainer/screens/crypto_detail_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:crypto_trainer/models/coin_data.dart';


String formatNumber(double number){
  var decimals = number.toString().split('.')[1];
  final formatter = NumberFormat('#,##,000.00');
  NumberFormat formatterBig = NumberFormat.compact();
  if(number >= 1000000)
    return formatterBig.format(number);
  else if(number >= 1000)
    return formatter.format(number);
  else if(number >= 0.1)
    return number.toStringAsFixed(2);
  else if(number <= 0.00000001)
    return number.toStringAsExponential();
  else
    return number.toStringAsFixed(7);
}

class CoinTile extends StatefulWidget {
  CoinData coinData;

  CoinTile(this.coinData);

  @override
  _CoinTileState createState() => _CoinTileState();
}

class _CoinTileState extends State<CoinTile>{

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) {
            return CryptoDetails(widget.coinData);
          }),
        );
      },
      child: Container(
        //margin: EdgeInsets.only(bottom: 1),
          padding: EdgeInsets.all(5),
          child: Column(
            children: [
          Row(
          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
          Flexible(
          flex: 11,
            fit: FlexFit.tight,
            child: Container(


              child: Row(
                children: [
                  CircleAvatar(
                    foregroundImage: NetworkImage(widget.coinData.imageUrl),
                    radius: 17,
                    backgroundColor: Colors.grey.shade100,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Container(
                    padding: EdgeInsets.all(4),
                    child: CoinNameSymbol(coinData: widget.coinData),
                  ),
                ],
              ),
            ),
          ),
        Flexible(
          flex: 10,
          fit: FlexFit.tight,
          child: Container(

            child: Text(
              '\$${formatNumber(widget.coinData.value)}',
              style: TextStyle(fontSize: 14),
            ),
          ),
        ),
        Flexible(
          flex: 5,
          fit: FlexFit.tight,
          child: Container(
            //width: 58,
            child: Text(
              '${widget.coinData.percentChange.toStringAsFixed(2)}%',
              style: TextStyle(
                  color:
                  widget.coinData.percentChange < 0 ? Colors.red : Colors.green),
            ),
          ),
        ),
        ],
      ),

            ],
          )),
    );
  }
}



class CoinNameSymbol extends StatelessWidget {
  const CoinNameSymbol({
    Key? key,
    required this.coinData,
  }) : super(key: key);

  final CoinData coinData;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(coinData.symbol.toUpperCase()),
        Container(
          width: 90,
          child: Text(
            coinData.name,
            style: TextStyle(fontSize: 10),
          ),

        ),
      ],
    );
  }
}
