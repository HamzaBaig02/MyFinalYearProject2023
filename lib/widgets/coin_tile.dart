import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:crypto_trainer/models/coin_data.dart';
import 'package:crypto_trainer/screens/crypto_cart.dart';

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
          margin: EdgeInsets.only(bottom: 1),
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: Colors.white,
          ),
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
                      Text('Owned: 0.02 BTC/\$ 25'),
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
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          width: 140,
          child: Row(
            children: [
              CircleAvatar(
                foregroundImage: NetworkImage(coinData.imageUrl),
                backgroundColor: Colors.grey.shade100,
              ),
              Container(
                padding: EdgeInsets.all(4),
                child: CoinNameSymbol(coinData: coinData),
              ),
            ],
          ),
        ),
        Container(
          width: 95,
          child: Text(
            '\$${formatter.format(
              coinData.value,
            )}',
            style: TextStyle(fontSize: 16),
          ),
        ),
        Container(
          width: 58,
          child: Text(
            '${coinData.percentChange.toStringAsFixed(2)}%',
            style: TextStyle(
                color: coinData.percentChange < 0 ? Colors.red : Colors.green),
          ),
        )
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
          width: 52,
          child: Text(
            coinData.name,
            style: TextStyle(fontSize: 10),
          ),
        ),
      ],
    );
  }
}
