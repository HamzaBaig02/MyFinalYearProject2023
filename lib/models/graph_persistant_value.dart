import 'package:flutter/material.dart';

class GraphPersistentValue extends ChangeNotifier{
  bool displayPersistent;

  GraphPersistentValue({required this.displayPersistent});

  void display(bool x){
    this.displayPersistent = x;
    notifyListeners();
  }


}