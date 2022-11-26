import 'package:crypto_trainer/Utilities/ErrorSnackBar.dart';
import 'package:crypto_trainer/screens/reset_password.dart';
import 'package:crypto_trainer/screens/verify_email_page.dart';
import 'package:crypto_trainer/services/functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:animated_login/animated_login.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../models/settings.dart';
import '../models/user_data.dart';
import 'loading.dart';


class LoginSignUp extends StatefulWidget {
  const LoginSignUp({Key? key}) : super(key: key);

  @override
  _LoginSignUpState createState() => _LoginSignUpState();
}

class _LoginSignUpState extends State<LoginSignUp> {
  bool isGuest = false;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final nameController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isGuest = Provider.of<Settings>(context, listen: false).isGuest;

  }


  @override
  Widget build(BuildContext context) {

    final LoginViewTheme loginTheme = LoginViewTheme(
      welcomeTitleStyle: TextStyle(color: domColor),
      welcomeDescriptionStyle: TextStyle(color: Colors.black87),
      backgroundColor: Colors.white,
      formFieldBackgroundColor: Colors.white,
      enabledBorderColor: Colors.grey,
      focusedBorderColor: domColor,
      formFieldHoverColor: domColor,
      forgotPasswordStyle: TextStyle(color: Colors.black87),
      hintTextStyle: TextStyle(color: Colors.black87),
      changeActionTextStyle: TextStyle(color: domColor),
      emailIcon: Icon(Icons.email,color:domColor),
      passwordIcon: Icon(Icons.password,color:domColor),
      nameIcon: Icon(FontAwesomeIcons.user,color:domColor),
      actionButtonStyle: ButtonStyle(foregroundColor: MaterialStateProperty.all(Colors.white),backgroundColor:MaterialStateProperty.all(domColor) )

    );
    Future logIn(LoginData loginData) async{
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: loginData.email, password: loginData.password);
        return Navigator.push(
          context,
          MaterialPageRoute(builder: (context) {
            return Loading();
          }),
        );
      }
      catch(e){
        print(e);
        ErrorSnackBar().errorSnackBar(error: e.toString(), context: context);
      }
    }
    Future signUp(SignUpData signUp) async{
      try {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: signUp.email, password: signUp.password);
        Provider.of<UserData>(context,
            listen: false).name = signUp.name;
        return Navigator.push(
          context,
          MaterialPageRoute(builder: (context) {
            return VerifyEmail();
          }),
        );
      }
      catch(e){
        print(e);
        ErrorSnackBar().errorSnackBar(error: e.toString(), context: context);
      }
    }

    return isGuest?Loading():Scaffold(
      body: SafeArea(
        child: Stack(
          children: [

            AnimatedLogin(
            loginMobileTheme: loginTheme,
              emailController: emailController,
              passwordController: passwordController,
              confirmPasswordController: confirmPasswordController,
              nameController: nameController,
              onForgotPassword: (x){
                return Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return ResetPasswordPage();
                  }),
                );
              },
              onLogin: (x) async {
              LoginData loginData = LoginData(email: emailController.text.trim(),password: passwordController.text.trim());
              await logIn(loginData);
              },
              onSignup: (x) async {
              if(passwordController.text.trim() == confirmPasswordController.text.trim()) {
                SignUpData signUpData = SignUpData(
                    name: nameController.text.trim(),
                    email: emailController.text.trim(),
                    password: passwordController.text.trim(),
                    confirmPassword: confirmPasswordController.text.trim());
                await signUp(signUpData);
              }
              else{
                ErrorSnackBar().errorSnackBar(error: 'Passwords do not match', context: context);
              }
              },



          ),
            Positioned(
                top: 0,
                right: 0,
                child: GestureDetector(
                  onTap: (){
                    setState(() {
                      isGuest = true;
                      Provider.of<Settings>(context, listen: false).setGuestUser(1);
                      saveSettingsToStorage(1);
                    });
                  },
                    child: Text("Guest Mode",style: TextStyle(fontSize: 22,color: domColor,decoration: TextDecoration.underline,),))),
        ]
        ),
      ),
    );



  }



}

final Color domColor = Color(0xff8b4a6c);

