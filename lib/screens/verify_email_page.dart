import 'dart:async';

import 'package:crypto_trainer/Utilities/ErrorSnackBar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
    if(isEmailVerified) timer?.cancel();
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
                    child: Text('Verification',
                        style: TextStyle(
                            fontSize: 60.0, fontWeight: FontWeight.bold,color: domColor)),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(16.0, 175.0, 0.0, 0.0),
                    child: Text('Email Sent',
                        style: TextStyle(
                            fontSize: 60.0, fontWeight: FontWeight.bold,color: domColor)),
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
                        fontSize: 25.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueGrey),
                  ),

                  SizedBox(height: 40.0),
                  loading?Container(height: 40,child: CircularProgressIndicator()):Container(
                    height: 40.0,
                    child: Material(
                      borderRadius: BorderRadius.circular(20.0),
                      shadowColor: Colors.blueAccent,
                      color: domColor,
                      elevation: 7.0,
                      child: GestureDetector(
                          onTap: () {

                            setState(() {
                              loading = true;
                              if(!isEmailVerified){
                                sendVerificationEmail();
                                timer = Timer.periodic(Duration(seconds: 3), (_)=>checkEmailVerified());
                              }
                              loading = false;
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
