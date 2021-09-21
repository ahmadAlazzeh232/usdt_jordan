
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:usdt_jordan/Admin/MainPageViewAdmin.dart';
import 'package:usdt_jordan/Authentication/AuthController.dart';

import 'package:usdt_jordan/Authentication/sign_in_screen.dart';
import 'package:usdt_jordan/Authentication/sign_up_screen.dart';
import 'package:usdt_jordan/User/ChoiceUserScreen.dart';
import 'package:usdt_jordan/User/chat_user/chat_user_screen.dart';
import 'package:usdt_jordan/User/personal_information/personal_info_screen.dart';
import 'package:usdt_jordan/User/shared_user_screen/Notification/notification_screen.dart';
import 'package:usdt_jordan/User/userDrawer/navMenuModel.dart';
import 'package:usdt_jordan/Utilities/MyBackgroundsColors.dart';
import 'package:usdt_jordan/Utilities/test.dart';
import 'package:usdt_jordan/referal_code/referal_screen.dart';
class UserNavigator extends StatefulWidget {
  const UserNavigator({Key? key}) : super(key: key);

  @override
  _UserNavigatorState createState() => _UserNavigatorState();
}

class _UserNavigatorState extends State<UserNavigator> {
    User? _user= FirebaseAuth.instance.currentUser;
  String  _email = "no";
    List<navMenu> _nav_menu = [

      navMenu("personal information", ()=> PersonalInfoScreen(), "InfoImage.png"),
      navMenu("settings", () =>  SignInScreen(), "signIn.png"),

     navMenu("notification", () => UserNotificationScreen(),"notification.png"),

    navMenu("discount code", ()=> ReferalInfo(), "referelIcon.png")
   ];
  
  @override
  Widget build(BuildContext context) {

    return Drawer(
      child: Container(
        color: MyBackGrounsColors.appBodyColor(),
         width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height*0.8,
        padding: EdgeInsets.only(top:  120),
      child:  Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [

          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              margin: EdgeInsets.only(left: 10),
              alignment: Alignment.centerLeft,
              width: MediaQuery.of(context).size.width*0.425,
              height: MediaQuery.of(context).size.height*0.105,
              decoration: BoxDecoration(
                 image: DecorationImage(
                  image: ExactAssetImage("assets/images/bottom_left_logo.png"), fit: BoxFit.cover
                )
              ),
            ),
          ),
         SizedBox(
           height: 1,
           width: 1,
         ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height*0.65,
            child: Center(
            child: ListView.builder(itemBuilder: (context, position){

               return Container(
                 width: MediaQuery.of(context).size.width,
                 height: MediaQuery.of(context).size.height*0.075,
                 padding: EdgeInsets.only(top: 4,bottom: 4),
                 margin: EdgeInsets.only(top: 4, bottom: 8),
                    decoration: BoxDecoration(
                 color: Colors.blue,
                      borderRadius: BorderRadius.only(topRight: Radius.circular(12),bottomRight: Radius.circular(12) )

                    ),
                   child: ListTile(
                    trailing: Image.asset("assets/images/"+_nav_menu[position].stringImageAddress,width: 40,height: 40,),

                   title: Text(_nav_menu[position].title,style: TextStyle(color: Colors.white
                   ,fontSize: 20,fontWeight: FontWeight.bold),),
                   onTap:(){
                     Navigator.pop(context);
                     Navigator.push(context, MaterialPageRoute(builder: (context){
                      return _nav_menu[position].function();
                   }));},


                 ),
               );

              },itemCount: _nav_menu.length,),
        ),
          ),]
      )

    ));

  }
}
