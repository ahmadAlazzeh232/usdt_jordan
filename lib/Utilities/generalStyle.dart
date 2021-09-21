import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'MyBackgroundsColors.dart';

class Generalstyle{
  static ButtonStyle appButtonStyle(){
    return ButtonStyle(
        backgroundColor:
        MaterialStateProperty.resolveWith((states) => MyBackGrounsColors.appButtonsColor(),
        ),
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
          side: BorderSide(color: Colors.black)
        )
      ),
    );
  }
  static TextStyle bodyTextStyleBold(){
    return TextStyle(
      color: Colors.white, fontSize:16 , fontWeight: FontWeight.bold,

    );
  }
  static TextStyle bodyTextStyleNormal(){
    return TextStyle(fontWeight: FontWeight.normal, fontSize: 16 ,color: Colors.white);
  }
  static InputBorder textFieldBorder(){
    return  OutlineInputBorder(borderRadius: BorderRadius.circular(20)
        ,borderSide: BorderSide(color: Colors.white,width: 1)) ;
  }
  static TextStyle bodyTextImportant(){
    return TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 24);
  }
  static TextStyle appBArTextStyleNormal(){
    return TextStyle(fontWeight: FontWeight.normal, fontSize: 16 ,color: Colors.white);
  }
  static TextStyle appBarTextImportant(){
    return TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 24);
  }static TextStyle appBarTextStyleBold(){
    return TextStyle(fontWeight: FontWeight.bold, fontSize: 16 ,color: Colors.white);
  }
static TextStyle buttonTextStyle(){
    return TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold);
}
static TextStyle hintTextStyle(){
    return TextStyle(color: Colors.white,fontSize: 18, fontWeight: FontWeight.normal);
}
  static TextStyle formTextStyle(){
    return TextStyle(color: Colors.white,fontSize: 14, fontWeight: FontWeight.normal);
  }
}