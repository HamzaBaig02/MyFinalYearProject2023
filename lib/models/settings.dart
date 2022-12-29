import 'package:flutter/cupertino.dart';

class Settings extends ChangeNotifier {
  bool isGuest = false;
  bool signedOut = false;
  bool sold = false;


  void setGuestUser(int isGuest){
    if(isGuest == 0)
    this.isGuest = false;
    else
      this.isGuest = true;
    notifyListeners();
  }

  void setSold(bool value){
    sold = value;
    notifyListeners();
  }

}