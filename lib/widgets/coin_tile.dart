import 'package:crypto_trainer/screens/buy_screen.dart';
import 'package:crypto_trainer/screens/graph_loading_screen.dart';
import 'package:crypto_trainer/screens/graph_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:crypto_trainer/models/coin_data.dart';

class CoinTile extends StatefulWidget {
  CoinData coinData;

  CoinTile(this.coinData);

  @override
  _CoinTileState createState() => _CoinTileState();
}

class _CoinTileState extends State<CoinTile> with TickerProviderStateMixin {
  var formatter = NumberFormat('#,##,000.00');
  late AnimationController _controller;
  late Animation<double> _animation;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
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
      _controller.animateBack(0, duration: Duration(milliseconds: 300));
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _toggleContainer();
      },
      child: Container(
        //margin: EdgeInsets.only(bottom: 1),
          padding: EdgeInsets.all(5),
          child: Column(
            children: [
              CollapsedTile(coinData: widget.coinData, formatter: formatter),
              SizeTransition(
                sizeFactor: _animation,
                axis: Axis.vertical,
                axisAlignment: -1,
                child: Container(
                  padding: EdgeInsets.all(3),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Temporary Sample Text'),
                      Container(
                        width: 58,
                        child: MaterialButton(
                          shape: CircleBorder(),
                          onPressed: () {
                            print('Cart Button Pressed');
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) {
                                return Buy(widget.coinData);
                              }),
                            );
                          },
                          child: Icon(Icons.shopping_bag_outlined),
                        ),
                      ),
                      Container(
                        width: 58,
                        child: MaterialButton(
                          shape: CircleBorder(),
                          onPressed: () {
                            print('Cart Button Pressed');
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) {
                                return GraphLoading(widget.coinData);
                              }),
                            );
                          },
                          child: Icon(Icons.auto_graph_outlined),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          )),
    );
  }
}

class CollapsedTile extends StatelessWidget {
  const CollapsedTile({
    Key? key,
    required this.coinData,
    required this.formatter,
  }) : super(key: key);

  final CoinData coinData;
  final NumberFormat formatter;

  @override
  Widget build(BuildContext context) {
    return Row(
      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          flex: 10,
          fit: FlexFit.tight,
          child: Container(
            //width: 140,

            child: Row(
              children: [
                CircleAvatar(
                  foregroundImage: NetworkImage(coinData.imageUrl),
                  radius: 15,
                  backgroundColor: Colors.grey.shade100,
                ),
                SizedBox(
                  width: 5,
                ),
                Container(
                  padding: EdgeInsets.all(4),
                  child: CoinNameSymbol(coinData: coinData),
                ),
              ],
            ),
          ),
        ),
        Flexible(
          flex: 10,
          fit: FlexFit.tight,
          child: Container(
            //width: 95,
            child: Text(
              '\$${coinData.value >= 1000 ? formatter.format(
                coinData.value,
              ) : coinData.value.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 16),
            ),
          ),
        ),
        Flexible(
          flex: 5,
          fit: FlexFit.tight,
          child: Container(
            //width: 58,
            child: Text(
              '${coinData.percentChange.toStringAsFixed(2)}%',
              style: TextStyle(
                  color:
                  coinData.percentChange < 0 ? Colors.red : Colors.green),
            ),
          ),
        ),
      ],
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
        Text(coinData.symbol),
        Container(
          width: 78,
          child: Text(
            coinData.name,
            style: TextStyle(fontSize: 10),
          ),
        ),
      ],
    );
  }
}
