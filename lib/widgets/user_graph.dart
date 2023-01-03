import 'package:crypto_trainer/models/transaction.dart';
import 'package:crypto_trainer/services/user_graph_comparrison_functions.dart';
import 'package:crypto_trainer/widgets/price_graph.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/graph_persistant_value.dart';
import '../models/user_data.dart';
import 'graph_button.dart';

Future<List<List<FlSpot>>> fetchUserGraphData(List<Transaction> transactions) async{
  List<List<FlSpot>> graphList = [[],[],[],[]];
  double x = 0;
  double y = 0;

  try {

    for(int i = 0;i < transactions.length;i++){

      y = (transactions[i].percentChange / 100) * (transactions[i].crypto.valueUsd);
      x = double.parse(transactions[i].date.millisecondsSinceEpoch.toString());

      FlSpot spot = FlSpot(x, y);

    if(transactions[i].type == 'Sold')
      {
        if (sameDay(transactions[i].date)) graphList[0].add(spot);
        if (sameWeek(transactions[i].date)) graphList[1].add(spot);
        if (sameMonth(transactions[i].date)) graphList[2].add(spot);
        if (sameYear(transactions[i].date)) graphList[3].add(spot);
      }
    }

  }catch (e) {
    print("User Graph Error:$e");
    return graphList = [];
  }
  print(graphList[1]);
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
  List<String> names = ['Day','Week','Month','Year'];

  void getUserGraphData() async {
  if(mounted) {
      List list = await compute(fetchUserGraphData,Provider.of<UserData>(context, listen: false).transactions);
      setState(() {
        nodesList.add(list[0]);
        nodesList.add(list[1]);
        nodesList.add(list[2]);
        nodesList.add(list[3]);
        //print(nodesList[0]);
      });
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
                :
            nodesList.length <= nodeIndex?Center(child: Text('Not enough Data'),):
            nodesList[nodeIndex].length < 2 ?Center(child: Text('Not enough Data'),) :ChangeNotifierProvider(
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
