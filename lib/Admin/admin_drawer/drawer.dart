
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:usdt_jordan/Admin/MainPageViewAdmin.dart';
import 'package:usdt_jordan/Admin/admin_chat/full_all_chat_screen.dart';
 import 'package:usdt_jordan/Authentication/AuthController.dart';

import 'package:usdt_jordan/Authentication/sign_in_screen.dart';
import 'package:usdt_jordan/Authentication/sign_up_screen.dart';
import 'package:usdt_jordan/User/ChoiceUserScreen.dart';
import 'package:usdt_jordan/User/shared_user_screen/Notification/notification_screen.dart';
import 'package:usdt_jordan/User/userDrawer/navMenuModel.dart';
import 'package:usdt_jordan/Utilities/MyBackgroundsColors.dart';
import 'package:usdt_jordan/Utilities/test.dart';
class AdmNAvigator extends StatefulWidget {
  const AdmNAvigator({Key? key}) : super(key: key);

  @override
  _AdmNAvigatorState createState() => _AdmNAvigatorState();
}


class _AdmNAvigatorState extends State<AdmNAvigator> {
  List<navMenu> _nav_menu = [
     navMenu("adminChats", () => AllAdminChats(),"")

  ];
  AuthintecationController _authController =AuthintecationController();

  @override
  Widget build(BuildContext context) {
    return Drawer(
          child: Container(

              color: Colors.white,

              padding: EdgeInsets.only(top: 100, ),
              child:  Center(
                child: ListView(
                   children: [
                     ListTile(

                       title: Text( "Admin chat",style: TextStyle(color: Colors.black
                           ,fontSize: 20,fontWeight: FontWeight.bold),),
                       onTap:(){
                         Navigator.pop(context);
                         Navigator.push(context, MaterialPageRoute(builder: (context){
                           return AllAdminChats();
                         }));},


                     ),ListTile(

                       title: Text( "Log Out",style: TextStyle(color: Colors.black
                           ,fontSize: 20,fontWeight: FontWeight.bold),),
                       onTap:()async{
                         Navigator.pop(context);
                         await   _authController.logOut();

                         Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context){
                           return ChoiceUserScreen();
                         }), (route) => false );},


                     ),

                   ],
                  ),
              )

          ),
        );

  }
}
