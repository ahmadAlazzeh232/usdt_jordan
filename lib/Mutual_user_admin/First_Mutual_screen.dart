import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:usdt_jordan/Admin/MainPageViewAdmin.dart';
import 'package:usdt_jordan/Authentication/sign_in_screen.dart';
import 'package:usdt_jordan/User/ChoiceUserScreen.dart';
import 'package:usdt_jordan/User/buyCMV/buy_user_screen.dart';
import 'package:usdt_jordan/Utilities/MyBackgroundsColors.dart';

class FirstMutualScreen extends StatefulWidget {
  const FirstMutualScreen({Key? key}) : super(key: key);

  @override
  _FirstMutualScreenState createState() => _FirstMutualScreenState();
}

class _FirstMutualScreenState extends State<FirstMutualScreen> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: MyBackGrounsColors.appBarColor(),


        ),

        body: Container(
          color: MyBackGrounsColors.appBodyColor(),
          child: Column(
            children: [
              // SizedBox(height: 50,),50
              SizedBox(
                height: 240,
                width: double.infinity,
                child: Image(
                  image: ExactAssetImage("assets/images/logo 1.png"),
                  fit: BoxFit.cover,
                ),
              ),
              _drawSignInMethods(),
              SizedBox(
                height: 80,
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      height: 5,
                      width: 5,
                    ),
                    _DrawSpipButton()
                  ],
                ),
              )
            ],
          ),
        ));
  }

  _DrawSpipButton() {
    return Padding(
        padding: EdgeInsets.all(12),
        child: ElevatedButton(
          onPressed: () {
            Navigator.push((context), MaterialPageRoute(builder: (context){
              return AdmPageView();
            }));
          },
          child: Text("Skip        "),
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.resolveWith(
                  (states) => MyBackGrounsColors.appButtonsColor())),
        ));
  }

  _drawSignInMethods() {
    return Expanded(child: Container(
      child: SignInScreen(),
    ),);
  }

}
