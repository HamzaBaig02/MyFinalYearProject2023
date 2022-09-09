import 'package:crypto_trainer/services/functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CommunitySentimentBar extends StatefulWidget {
  final double pos;
  final double neg;

  CommunitySentimentBar({required this.pos, required this.neg});

  @override
  _CommunitySentimentBarState createState() => _CommunitySentimentBarState();
}

class _CommunitySentimentBarState extends State<CommunitySentimentBar> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height * 0.04;
    double pos = widget.pos;
    double neg = widget.neg;
    return Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [Text('Community Sentiment',style: TextStyle(fontSize: getFontSize(context, 2.7),letterSpacing:1)),
              SizedBox(width: 4,),
              Icon(FontAwesomeIcons.solidComments,color: Color(0xff8b4a6c))
            ]),
            SizedBox(height: 8,),
            AnimatedContainer(
                duration: Duration(milliseconds: 1000),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    stops: [0,pos/100,1],
                      colors: [
                    Colors.green,
                    Color.lerp(Colors.green,Colors.red,neg/100)??Colors.green,
                    Colors.red
                  ]),
                    borderRadius: BorderRadius.circular(15)),
                height: height,
                width: MediaQuery.of(context).size.width,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 3),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(widget.pos == 0 ? 'N/A' : widget.pos.toString(),style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500,fontSize: getFontSize(context,1.6)),),
                    Text(widget.neg == 0 ? 'N/A' : widget.neg.toString(),style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500,fontSize: getFontSize(context,1.6)),)
                  ],
                ),
              ),
              ),
          ],
        ),

      );

  }
}
