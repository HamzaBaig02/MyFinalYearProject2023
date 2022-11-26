import 'package:crypto_trainer/Utilities/ErrorSnackBar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ResetPasswordPage extends StatefulWidget {
  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final emailController = TextEditingController();
  bool loading = false;
  @override
  Widget build(BuildContext context) {

    Future resetPassword(String email)async{
      setState(() {
        loading = true;
      });
      try{
        await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
        ErrorSnackBar().errorSnackBar(error: 'Password Reset Email Sent', context: context,color: Colors.black87);
      }
      catch(e){
        ErrorSnackBar().errorSnackBar(error: e.toString(), context: context);
      }
      setState(() {
        loading = false;
      });
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text('Reset Password'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              child: Stack(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.fromLTRB(15.0, 110.0, 0.0, 0.0),
                    child: Text('Reset',
                        style: TextStyle(
                            fontSize: 60.0, fontWeight: FontWeight.bold,color: domColor)),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(16.0, 175.0, 0.0, 0.0),
                    child: Text('Password',
                        style: TextStyle(
                            fontSize: 60.0, fontWeight: FontWeight.bold,color: domColor)),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(285.0, 175.0, 0.0, 0.0),
                    child: Text('?',
                        style: TextStyle(
                            fontSize: 60.0,
                            fontWeight: FontWeight.bold,
                            )),
                  )
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 35.0, left: 20.0, right: 20.0),
              child: Column(
                children: <Widget>[
                  Text(
                    'Enter the email address associated with your account.',
                    style: TextStyle(
                        fontSize: 25.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueGrey),
                  ),
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                        labelText: 'EMAIL',
                        labelStyle: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.grey),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.red))),
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
                              resetPassword(emailController.text.trim());
                          },
                          child: Center(
                              child: Text(
                                'RESET PASSWORD',
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
    );
  }
}

final Color domColor = Color(0xff8b4a6c);