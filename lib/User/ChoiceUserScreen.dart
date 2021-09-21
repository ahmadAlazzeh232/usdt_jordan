import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:ntp/ntp.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
 import 'package:usdt_jordan/User/SellCMV/send_sell_user_screen.dart';
import 'package:usdt_jordan/User/buyCMV/buy_user_screen.dart';
import 'package:usdt_jordan/User/chat_user/chat_user_screen.dart';
 import 'package:usdt_jordan/User/userDrawer/Drawer.dart';
import 'package:usdt_jordan/Utilities/MyBackgroundsColors.dart';
import 'package:usdt_jordan/Utilities/generalStyle.dart';


class ChoiceUserScreen extends StatefulWidget {
  const ChoiceUserScreen({Key? key}) : super(key: key);

  @override
  _ChoiceUserScreenState createState() => _ChoiceUserScreenState();
}

class _ChoiceUserScreenState extends State<ChoiceUserScreen>{
    CollectionReference _nameReference =FirebaseFirestore.instance.collection("usersInfo") ;
 String _fullNAme = "";
 String _userName = "";
 String _userEmail = "non";
 String _token ="non";
    // const AndroidNotificationChannel channel = AndroidNotificationChannel(
    //   'high_importance_channel', // id
    //   'High Importance Notifications', // title
    //   'This channel is used for important notifications.', // description
    //   importance: Importance.max,
    // );
    // final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    // FlutterLocalNotificationsPlugin();
    //
    // await flutterLocalNotificationsPlugin
    //     .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
    //     ?.createNotificationChannel(channel);
    // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    // RemoteNotification notification = message.notification;
    // AndroidNotification android = message.notification?.android;
    //
    // // If `onMessage` is triggered with a notification, construct our own
    // // local notification to show to users using the created channel.
    // if (notification != null && android != null) {
    // flutterLocalNotificationsPlugin.show(
    // notification.hashCode,
    // notification.title,
    // notification.body,
    // NotificationDetails(
    // android: AndroidNotificationDetails(
    // channel.id,
    // channel.name,
    // channel.description,
    // icon: android?.smallIcon,
    // // other properties...
    // ),
    // ));
    // }
    // });
    // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    // Map<String, String> data = message.data;
    //
    // Owner owner = Owner.fromMap(jsonDecode(data['owner']));
    // User user = User.fromMap(jsonDecode(data['user']));
    // Picture picture = Picture.fromMap(jsonDecode(data['picture']));
    //
    // print('The user ${user.name} liked your picture "${picture.title}"!');
    // });
     bool _readState= true;
    @override
  void initState() {

   super.initState();
   print("77777 ");
   User? _userState =   FirebaseAuth.instance.currentUser;
   if(_userState!= null){

     _userEmail = _userState.email!;
      Stream _straem = FirebaseFirestore.instance.collection("all_chats").doc(_userEmail).snapshots();
      _straem.listen((event) {
        setState(() {
          _readState = event["read_state"];
        });

      });
     _subscribe();
     
     _nameReference.doc(_userEmail).get().then((DocumentSnapshot documentSnapshot){
        if(documentSnapshot.exists)  {
           _userName = documentSnapshot["full_name"];
          _fullNAme = documentSnapshot["full_name"];
          setState(() {
          });
       }
       else{

         _userName = "";}
     });

     print("55555 $_userName");
   }else{
     setState(() {
       _userName ="!! أنت غير مسجل ";
     });

   }

   //
  }

    Future<void>  _subscribe()async{
      String topic = _userEmail.replaceFirst(RegExp("@"), "a");
      await FirebaseMessaging.instance.subscribeToTopic("$topic").then((value){
        print("this is subscribeResult: ");
      });
    }

    Future<void> _updateToken(tokenUpdate)async{
   await FirebaseFirestore.instance.collection("users_token").doc(FirebaseAuth.instance.currentUser!.email).update({
     "token": FieldValue.arrayUnion([tokenUpdate])
   });
    }
  @override
  Widget build(BuildContext context) {

return
    Scaffold(
      drawer: UserNavigator(),
    appBar: AppBar(

      title:        Text(" $_userName",style: TextStyle(fontSize: 13,color: Colors.white),) ,
      backgroundColor: MyBackGrounsColors.appButtonsColor(),
     centerTitle: true,
    )
    ,body: Stack(
      children:[
        Container(

            padding: EdgeInsets.only(right: 8,left: 8),
        color: MyBackGrounsColors.appBodyColor(),


            child: Column(

              mainAxisAlignment: MainAxisAlignment.spaceBetween,

              children: [
                SizedBox(
                  height: 1,
                ),

                 SizedBox(
                  height: 1,
                ),
                SizedBox(
                  height: 1,
                ),

                SizedBox(
                  height: 1,
                ),
             Container(
               height: 150,
               width: MediaQuery.of(context).size.width,
               alignment: Alignment.center,
               child: Column(
                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                 children: [
                   Container(
                     width: MediaQuery.of(context).size.width,
                     height: 60,

                     child: Row(
                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                         children: [
                           SizedBox(width: MediaQuery.of(context).size.width*.2,
                             height: MediaQuery.of(context).size.height*.1,),
                           Expanded(

                             child: Container(
                               height:50 ,
                               child: ElevatedButton(
                                 style: Generalstyle.appButtonStyle(),
                                 onPressed: (){
                                   Navigator.push(context, MaterialPageRoute(builder: (context){
                                     return UserBuyScreen(email: _userEmail,);
                                   }));
                                 }, child: Text('buy Usdt',style: Generalstyle.buttonTextStyle(),),
                               ),
                             ),
                           ),
                           SizedBox(width: MediaQuery.of(context).size.width*.2,
                             height: MediaQuery.of(context).size.height*.1,),
                         ]),
                   ),
                   Container(
                     width: MediaQuery.of(context).size.width,
                     height: 60,
                     child: Row(

                         children:[
                           SizedBox(width: MediaQuery.of(context).size.width*.2,
                             height: 60,),
                           Expanded(
                             child: Container(
                               height: 50,
                               child: ElevatedButton(onPressed: (){
                                 Navigator.push(context, MaterialPageRoute(builder: (context){
                                   return SellUserScreen();
                                 }));
                               },
                                 child: Text('sell Usdt',style: Generalstyle.buttonTextStyle(),),style: Generalstyle.appButtonStyle(),),
                             ),
                           ),
                           SizedBox(width: MediaQuery.of(context).size.width*.2,
                             height: MediaQuery.of(context).size.height*.1,),
                         ]),
                   ),
                 ],
               ),
             ),
                SizedBox(
                  height: 1,
                ),

                SizedBox(
                  height: 1,
                ),
                  Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children:[
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Container(
                      width: 150,
                      height:70,
                       alignment: Alignment.bottomLeft,
                      margin: EdgeInsets.only( bottom: 18),
                      decoration: BoxDecoration(
                         image: DecorationImage(
                            image:
                            ExactAssetImage("assets/images/bottom_left_logo.png"),fit: BoxFit.cover)
                      ),


                  ),
                    ) ,

                    SizedBox(
                      height: 1,
                    ),SizedBox(
                      height: 1,
                    ),]
                )

              ],
            ),

        ),
        Align(
          alignment: Alignment.bottomRight,
          child: Container(
            margin: EdgeInsets.only(right: 10, bottom: 10),
             height: 90,
            width: 90,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
             ),
             child: SizedBox(
               width: 67,
                    height: 67,
               child: IconButton(icon:

               new Image.asset((_readState)? "assets/images/message.png" : "assets/images/new_message.png",fit: BoxFit.cover,),
                onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context){
                  return UserChatScreen(emailUserScreen: _userEmail, nameUserCurrent: _userName,token: _token,);
                }));
            },iconSize: 60,
                color: Colors.white,


               ),
             ),

          ),
        )
      ],
    ),
    );
  }

  // Future<String> _getUserName(DocumentSnapshot snapshot){
  //
  // }

}
