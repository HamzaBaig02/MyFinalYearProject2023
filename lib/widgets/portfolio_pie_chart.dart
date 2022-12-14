import 'dart:math';
import 'package:crypto_trainer/services/functions.dart';
import 'package:crypto_trainer/widgets/user_graph.dart';
import 'package:sizer/sizer.dart';
import 'package:crypto_trainer/models/crypto_currency.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:crypto_trainer/constants/colors.dart';
import '../models/user_data.dart';
import '../screens/login_signup.dart';

class PortfolioPieChart extends StatefulWidget {
  const PortfolioPieChart({Key? key}) : super(key: key);

  @override
  _PortfolioPieChartState createState() => _PortfolioPieChartState();
}

class _PortfolioPieChartState extends State<PortfolioPieChart> {
  int touchedIndex = 0;
  List<PieChartAssetData> assetData = [];


  List<PieChartSectionData> showingSections() {
    assetData = [];
    double totalWalletValue = 0;

    for(int i = 0;i < Provider.of<UserData>(context, listen: false).wallet.length ;i++){
      CryptoCurrency x = Provider.of<UserData>(context, listen: false).wallet[i];
      assetData.add(PieChartAssetData(name: x.coin.name, value: x.valueUsd, imageUrl: x.coin.imageUrl));
    }
    assetData.sort((b, a) => a.compareTo(b)); //sorting assets in descending order
    
    if(assetData.length > 4 ){
      double x = 0;
      for(int i = 4;i < assetData.length; i++){
        x = x + assetData[i].value;
      }
      assetData = assetData.sublist(0,4);
      assetData.add(PieChartAssetData(name: 'Others', value: x, imageUrl: 'assets/images/others.png'));
      
    }
    
    Provider.of<UserData>(context, listen: false).wallet.forEach((element) {
      totalWalletValue = totalWalletValue + element.valueUsd;
    });


    
    return List.generate(assetData.length, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? getFontSize(context, 2.5) : getFontSize(context, 1.8);
      final radius = isTouched ? MediaQuery.of(context).size.height * 0.11 : MediaQuery.of(context).size.height * 0.09;
      final widgetSize = isTouched ? MediaQuery.of(context).size.height * 0.065 : MediaQuery.of(context).size.height * 0.045;
      final titlePositionPercentageOffset = isTouched ? 0.4 : 0.4;


      return PieChartSectionData(
            color: pieChartColors[i],
            value: assetData[i].value/totalWalletValue * 100,
            title: (assetData[i].value/totalWalletValue * 100).toStringAsFixed(2) + '%',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.w500,
                color: const Color(0xffffffff)),
            badgeWidget: _Badge(
              assetData[i].imageUrl,
              size: widgetSize,
              borderColor: const Color(0xff8b4a6c),
              isOthers: assetData[i].name == 'Others' ? true : false,
            ),
            badgePositionPercentageOffset: 1.08,
            titlePositionPercentageOffset: titlePositionPercentageOffset,
          );

    });

  }

  @override
  void initState() {
    super.initState();
    
    
  }
  @override
  Widget build(BuildContext context) {



    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            height: 250,
            child: PieChart(
              PieChartData(
                  pieTouchData: PieTouchData(
                      touchCallback: (FlTouchEvent event, pieTouchResponse) {
                        setState(() {
                          if (!event.isInterestedForInteractions ||
                              pieTouchResponse == null ||
                              pieTouchResponse.touchedSection == null) {
                            touchedIndex = -1;
                            return;
                          }
                          touchedIndex =
                              pieTouchResponse.touchedSection!.touchedSectionIndex;
                        });
                      }),
                  borderData: FlBorderData(
                    show: false,
                  ),
                  sectionsSpace: 0,
                  centerSpaceRadius: 40,
                  sections: showingSections()),
            ),
          ),
          SizedBox(height: 5,),
          Container(
            height:130,
            alignment: Alignment.center,
            child: Wrap(
              runSpacing: 5,
              direction: Axis.horizontal,
              children: List.generate(assetData.length, (index) {
                return PieChartKey(name: assetData[index].name, color: pieChartColors[index]);
              }
              ),
            ),
          ),


      ],
      ),
    );
  }


}





class _Badge extends StatelessWidget {
  final String coinImage;
  final bool isOthers;
  final double size;
  final Color borderColor;

  const _Badge(this.coinImage, {
    Key? key,
    required this.size,
    required this.isOthers,
    required this.borderColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: PieChart.defaultDuration,
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(
          color: borderColor,
          width: 2,
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withOpacity(.5),
            offset: const Offset(3, 3),
            blurRadius: 3,
          ),
        ],
      ),
      padding: EdgeInsets.all(size * 0.05),
      child: Center(
        child: isOthers ? CircleAvatar(
          foregroundImage:AssetImage(coinImage),
          backgroundColor: Colors.grey.shade200,
          radius: 37,)
            :CircleAvatar(
          foregroundImage:NetworkImage(coinImage),
        backgroundColor: Colors.grey.shade200,
        radius: 37,),
      ),
    );
  }
}


class PieChartAssetData{
  String name;
  double value;
  String imageUrl;

  PieChartAssetData({required this.name, required this.value, required this.imageUrl});

  int compareTo(other) {
    return this.value.compareTo(other.value);
  }

  @override
  String toString() {
    return 'PieChartAssetData{name: $name, value: $value, imageUrl: $imageUrl}';
  }
}

class PieChartKey extends StatelessWidget {

  String name;
  Color color;


  PieChartKey({required this.name, required this.color});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Container(
      width: width*0.4,
      padding: EdgeInsets.all(4.5),
      child: Row(
        children: [
          Flexible(flex: 1,fit: FlexFit.tight,child: CircleAvatar(backgroundColor: color,radius: MediaQuery.of(context).size.height * 0.01,)),
          Flexible(flex:3,fit: FlexFit.tight,child: Text(name,style: TextStyle(fontSize: getFontSize(context, 1.8),fontWeight: FontWeight.w400),)),
        ],
      ),
    );
  }
}


