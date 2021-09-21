import 'package:flutter/material.dart';
import 'package:usdt_jordan/Authentication/sign_up_screen.dart';
import 'package:usdt_jordan/Utilities/MyBackgroundsColors.dart';

class SignUpInside extends StatefulWidget {
  const SignUpInside({Key? key}) : super(key: key);

  @override
  _SignUpInsideState createState() => _SignUpInsideState();
}

class _SignUpInsideState extends State<SignUpInside> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        backgroundColor: MyBackGrounsColors.appButtonsColor(),
      ),
      body: SignUpScreen(),
    );
  }
}
