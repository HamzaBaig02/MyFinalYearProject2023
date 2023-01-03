import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

import '../services/functions.dart';

class WelcomeSheet extends StatelessWidget {

  final VoidCallback? onTap;

  WelcomeSheet({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(30),topRight: Radius.circular(30))
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
        Lottie.asset('assets/images/welcome.json',
            height: MediaQuery.of(context).size.height * 0.35),
        Text('Crypto Trainer allows it\'s users to play their investment strategies live without the need to spend real money. Tap below to start the tutorial or swipe down to continue.',
          style: GoogleFonts.montserrat(

            textStyle: TextStyle(
                color: Colors.black,
                letterSpacing: .75,
                fontSize: getFontSize(context,2.8)),
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 15,),
        MaterialButton(onPressed: onTap,
          child: Container(
            width: 85,
            alignment: Alignment.center,
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
            decoration: BoxDecoration(
                color: Color(0xff8b4a6c),
                borderRadius: BorderRadius.circular(5)),
            child: Text(
              "START!",
              style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,letterSpacing: 1,fontSize: 17),
            ),
          ),
        )
      ],),

    );
  }
}
