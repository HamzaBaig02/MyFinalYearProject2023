import 'package:flutter/material.dart';

class ErrorSnackBar{

void errorSnackBar({required String error,required context,Color color = Colors.red}){
  var snackBar = SnackBar(
    duration: Duration(milliseconds: 1000),
    backgroundColor: color,
    content: Text(error,style: TextStyle(color: Colors.white),),
  );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}