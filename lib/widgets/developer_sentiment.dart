import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../constants/tutorials.dart';
import '../services/functions.dart';

class DeveloperSentiment extends StatefulWidget {

  final Map<String,dynamic> developerData;


  DeveloperSentiment({required this.developerData});

  @override
  _DeveloperSentimentState createState() => _DeveloperSentimentState();
}

class _DeveloperSentimentState extends State<DeveloperSentiment> {

  int currentSelectedIndex = 6;
  bool isPressed = false;
  List<String> descriptions = [];
  List<String> metricTitles = ['Forks','Stars','Subscribers','Monthly-Commits'];
  List<IconData> metricIcons = [FontAwesomeIcons.codeFork,FontAwesomeIcons.solidStar,FontAwesomeIcons.eye,FontAwesomeIcons.codeCommit];
  List<String> metricKey = ['forks','stars','subscribers','commit_count_4_weeks'];
  List<DeveloperTile> tiles = [];
  String content = '';


  @override
  Widget build(BuildContext context) {


    tiles = List.generate(4, (index) => DeveloperTile(callback: (){
      setState(() {
        currentSelectedIndex  = index;
        content = developerSentimentAnalyzer(index);
      });
    }, isSelected: currentSelectedIndex == index, title: metricTitles[index], data: widget.developerData[metricKey[index]].toString(), icon:Icon(metricIcons[index],color: currentSelectedIndex == index ?  Color(0xff8b4a6c) : Colors.grey) ));

    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 8,
            runSpacing: 5,
            children: tiles,
          ),
          SizedBox(height: 10,),
          Text(content,style: TextStyle(fontSize: getFontSize(context, 2.7)))
        ],
      ),
    );
  }
}

class DeveloperTile extends StatelessWidget {

  final VoidCallback callback;
  final bool isSelected;
  final String title;
  final String data;
  final Icon icon;


  DeveloperTile({required this.callback, required this.isSelected, required this.title,required this.data,
    required this.icon});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: callback,
      child: Container(
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(7),
            border: Border.all(color: isSelected?Color(0xff8b4a6c):Colors.blueGrey, width: 2)
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            icon,
            SizedBox(height: 3,),
            Text(title,style: TextStyle(color: Colors.grey),),
            SizedBox(height: 5,),
            Text(data == 'null' ? 'N/A' : data,style: TextStyle(fontSize: getFontSize(context, 2.7)),),
          ],

        ),
      ),
    );;
  }
}

