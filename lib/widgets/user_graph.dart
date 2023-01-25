import 'dart:async';

import 'package:crypto_trainer/models/transaction.dart';
import 'package:crypto_trainer/services/user_graph_comparrison_functions.dart';
import 'package:crypto_trainer/widgets/price_graph.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:async/async.dart';
import '../models/graph_persistant_value.dart';
import '../models/user_data.dart';
import 'graph_button.dart';
import '../services/transaction_sorting_functions.dart';

// Future<List<List<FlSpot>>> fetchUserGraphData(List<Transaction> transactions) async{
//   List<List<FlSpot>> graphList = [[],[],[],[]];
//   double x = 0;
//   double y = 0;
//
//   try {
//
//     for(int i = 0;i < transactions.length;i++){
//
//       y = (transactions[i].percentChange / 100) * (transactions[i].crypto.valueUsd);
//       x = double.parse(transactions[i].date.millisecondsSinceEpoch.toString());
//
//       FlSpot spot = FlSpot(x, y);
//
//     if(transactions[i].type == 'Sold')
//       {
//         if (sameDay(transactions[i].date)) graphList[0].add(spot);
//         if (sameWeek(transactions[i].date)) graphList[1].add(spot);
//         if (sameMonth(transactions[i].date)) graphList[2].add(spot);
//         if (sameYear(transactions[i].date)) graphList[3].add(spot);
//       }
//     }
//
//   }catch (e) {
//     print("User Graph Error:$e");
//     return graphList = [];
//   }
//   print(graphList[1]);
//   return graphList;
// }

Future<List<FlSpot>> fetchUserGraphData(DateSorterObjectData data) async{

   if(data.days == 0) return getRecentTransactions(data.transactions);
   else return getRecentWeekMonthYearTransactions(data.transactions, data.days);

}

class UserGraph extends StatefulWidget {
  const UserGraph({Key? key}) : super(key: key);

  @override
  _UserGraphState createState() => _UserGraphState();
}

class _UserGraphState extends State<UserGraph> {
  List<List<FlSpot>> nodesList = [[],[],[],[]];
  Timer? timer;
  int nodeIndex = 0;
  int currentSelectedIndex = 0;
  bool enableTouch = false;
  bool loading = true;
  List<String> names = ['Day','Week','Month','Year'];

  void getUserGraphData(int days,int listIndex) async {
    setState(() {
      loading = true;
    });
  if(mounted == false) return;
  List <FlSpot> list = await compute(fetchUserGraphData,DateSorterObjectData(transactions: Provider.of<UserData>(context, listen: false).transactions, days: days));
  print(list);
  setState(() {
    nodesList[listIndex] = list;
    loading = false;
  });
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
      timer = Timer(Duration(seconds: 2), () {
        getUserGraphData(0, 0);
      });


  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    timer?.cancel();
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      height: 310,
      child: Column(
        children: [
          Flexible(
              fit: FlexFit.tight,
              flex: 2,
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

                              if(nodesList[index].isNotEmpty) return;

                              else if(nodeIndex == 0)getUserGraphData(0,0);
                              else if(nodeIndex == 1)getUserGraphData(7,1);
                              else if(nodeIndex == 2)getUserGraphData(30, 2);
                              else if(nodeIndex == 3)getUserGraphData(365, 3);





                            });


                          });
                    }),
              )),
          SizedBox(
            height: 18,
          ),
          Flexible(
            flex: 15,
            fit: FlexFit.tight,
            child: loading
                ? Center(child: CircularProgressIndicator())
                :
            nodesList.length <= nodeIndex?Center(child: Text('Not enough Data'),):
            nodesList[nodeIndex].length < 2 ?Center(child: Text('Not enough Data'),) :ChangeNotifierProvider(
              create:(context)=>GraphPersistentValue(displayPersistent: true),
              child: Stack(children: [

                PriceGraph(showTooltipIndicatorsAtIndexes: true,nodesList: nodesList, nodeIndex: nodeIndex,percentSymbol: false,),
                IgnorePointer(child: PriceGraph(showTooltipIndicatorsAtIndexes: false,nodesList: nodesList, nodeIndex: nodeIndex,percentSymbol: false,),),

              ],),
            ),
          ),
        ],
      ),
    );
  }
}

class DateSorterObjectData{
  final List<Transaction> transactions;
  final int days;

  DateSorterObjectData({required this.transactions,required this.days});


}