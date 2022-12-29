import 'dart:async';

import 'package:crypto_trainer/Utilities/ErrorSnackBar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/colors.dart';
import '../models/user_data.dart';
import '../services/functions.dart';
import 'loading.dart';
import 'login_signup.dart';

class VerifyEmail extends StatefulWidget {

  @override
  _VerifyEmailState createState() => _VerifyEmailState();
}

class _VerifyEmailState extends State<VerifyEmail> {
  bool isEmailVerified = false;
  bool loading = false;
  Timer? timer;

  Future sendVerificationEmail()async{
    try {
      final user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();
    } on Exception catch (e) {
      ErrorSnackBar().errorSnackBar(error: e.toString(), context: context);
    }
  }

  Future checkEmailVerified() async{
    await FirebaseAuth.instance.currentUser!.reload();
    if(mounted) {
      setState(() {
        isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
      });
    }
    if(isEmailVerified){
      Provider.of<UserData>(context,
          listen: false).emailID = FirebaseAuth.instance.currentUser?.email ?? '';
      timer?.cancel();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    if(!isEmailVerified){
      sendVerificationEmail();
      timer = Timer.periodic(Duration(seconds: 3), (_)=>checkEmailVerified());

    }
    @override
    void dispose(){
      timer?.cancel();
      super.dispose();
    }

  }
  @override
  Widget build(BuildContext context) {
    if(isEmailVerified){
      timer?.cancel();
    }
    return isEmailVerified?
    Loading():
    Scaffold(body: SafeArea(child: Container(

      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              child: Stack(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.fromLTRB(15.0, 110.0, 0.0, 0.0),
                    child: Text('Verification Email Sent',
                        style: TextStyle(
                            fontSize: getFontSize(context, 7), fontWeight: FontWeight.bold,color: domColor)),
                  ),

                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 35.0, left: 20.0, right: 20.0),
              child: Column(
                children: <Widget>[
                  Text(
                    'An email containing a link to verify your account has been sent.',
                    style: TextStyle(
                        fontSize: getFontSize(context,4 ),
                        fontWeight: FontWeight.bold,
                        color: Colors.blueGrey),
                  ),

                  SizedBox(height: 40.0),
                  loading?Container(height: 40,child: CircularProgressIndicator()):Container(
                    height: 40.0,
                    child: Material(
                      borderRadius: BorderRadius.circular(20.0),
                      shadowColor: Colors.purpleAccent,
                      color: domColor,
                      elevation: 7.0,
                      child: GestureDetector(
                          onTap: () async {

                            setState(() {
                              loading = true;
                            });

                              if(!isEmailVerified){
                                await sendVerificationEmail();
                                //timer = Timer.periodic(Duration(seconds: 5), (_)=>checkEmailVerified());
                              }

                              setState(() {
                                loading = false;
                                ErrorSnackBar().errorSnackBar(error: 'Verification Email Resent', context: context,color: Colors.black87);
                              });




                          },
                          child: Center(
                              child: Text(
                                'Resend Verification Email',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, color: Colors.white),
                              ))),
                    ),
                  ),
                  SizedBox(height: 10,),
                  Container(
                    height: 40.0,
                    child: Material(
                      borderRadius: BorderRadius.circular(20.0),
                      shadowColor: Colors.purpleAccent,
                      color: domColor,
                      elevation: 7.0,
                      child: GestureDetector(
                          onTap: (){
                            timer?.cancel();
                            FirebaseAuth.instance.signOut();
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => LoginSignUp()));


                          },
                          child: Center(
                              child: Text(
                                'Cancel',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, color: Colors.white),
                              ))),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 15.0),

          ],
        ),
      ),

    )));
  }
}
