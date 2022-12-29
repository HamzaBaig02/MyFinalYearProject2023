import 'package:crypto_trainer/models/transaction.dart';
import 'package:crypto_trainer/widgets/price_graph.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/graph_persistant_value.dart';
import '../models/user_data.dart';
import 'graph_button.dart';

Future<List<FlSpot>> fetchUserGraphData(UserGraphData userGraphData) async{
  List<FlSpot> graphList = [];

  double x = 0;
  double y = 0;
  try {
    y = userGraphData.transactions[0].percentChange;
    x = double.parse(userGraphData.transactions[0].date.millisecondsSinceEpoch.toString());

    FlSpot spot = FlSpot(x, y);

    graphList.add(spot);


    for(int i = 1;i < userGraphData.transactions.length;i++){

      y = (userGraphData.transactions[i].percentChange / 100) * (userGraphData.transactions[i].crypto.valueUsd);
      x = double.parse(userGraphData.transactions[i].date.millisecondsSinceEpoch.toString());

      FlSpot spot = FlSpot(x, y);

      if(userGraphData.transactions[i].date.day > userGraphData.transactions[i-1].date.day)
      graphList.add(spot);

    }



  }catch (e) {
    print("User Graph Error:$e");
    graphList = [];
  }

  return graphList;
}



class UserGraph extends StatefulWidget {
  const UserGraph({Key? key}) : super(key: key);

  @override
  _UserGraphState createState() => _UserGraphState();
}

class _UserGraphState extends State<UserGraph> {
  List<List<FlSpot>> nodesList = [];
  int nodeIndex = 0;
  int currentSelectedIndex = 0;
  bool enableTouch = false;
  List<String> names = ['7','30','60','100'];

  void getUserGraphData() async {
  if(mounted) {
      nodesList.add(await compute(
          fetchUserGraphData,
          UserGraphData(
              transactions:
                  Provider.of<UserData>(context, listen: false).transactions,
              numberOfTrades: 10)));
      setState(() {});
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserGraphData();
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      child: Column(
        children: [
          Flexible(
              fit: FlexFit.tight,
              flex: 1,
              child: Container(
                child: ListView.builder(
                    itemExtent: 85,
                    scrollDirection: Axis.horizontal,
                    itemCount: 4,
                    itemBuilder: (context, index) {
                      return GraphButton(
                          text: names[index],
                          index: index,
                          isSelected: currentSelectedIndex == index,
                          onSelect: () {
                            setState(() {
                              currentSelectedIndex = index;
                              nodeIndex = index;
                            });


                          });
                    }),
              )),
          SizedBox(
            height: 18,
          ),
          Flexible(
            flex: 10,
            fit: FlexFit.tight,
            child: nodesList.isEmpty
                ? Center(child: CircularProgressIndicator())
                : ChangeNotifierProvider(
              create:(context)=>GraphPersistentValue(displayPersistent: true),
              child: Stack(children: [

                PriceGraph(showTooltipIndicatorsAtIndexes: true,nodesList: nodesList, nodeIndex: nodeIndex),
                IgnorePointer(child: PriceGraph(showTooltipIndicatorsAtIndexes: false,nodesList: nodesList, nodeIndex: nodeIndex),),

              ],),
            ),
          ),
        ],
      ),
    );
  }
}

class UserGraphData{
  final List<Transaction> transactions;
  final int numberOfTrades;

  UserGraphData({required this.transactions,required this.numberOfTrades});


}