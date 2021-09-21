
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
 import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:usdt_jordan/Admin/MainPageViewAdmin.dart';
 import 'package:usdt_jordan/Authentication/sign_in_screen.dart';
import 'package:usdt_jordan/User/ChoiceUserScreen.dart';
import 'dart:async';
import 'dart:convert';

late AndroidNotificationChannel channel;
late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

Future<void>  main() async {

   WidgetsFlutterBinding.ensureInitialized();
   await Firebase.initializeApp();
   FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

   if (!kIsWeb) {
     channel = const AndroidNotificationChannel(
       'high_importance_channel', // id
       'High Importance Notifications', // title
       'This channel is used for important notifications.', // description
       importance: Importance.high,
     );

     flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

     /// Create an Android Notification Channel.
     ///
     /// We use this channel in the `AndroidManifest.xml` file to override the
     /// default FCM channel to enable heads up notifications.
     await flutterLocalNotificationsPlugin
         .resolvePlatformSpecificImplementation<
         AndroidFlutterLocalNotificationsPlugin>()
         ?.createNotificationChannel(channel);

     /// Update the iOS foreground notification presentation options to allow
     /// heads up notifications.
     await FirebaseMessaging.instance
         .setForegroundNotificationPresentationOptions(
       alert: true,
       badge: true,
       sound: true,
     );
   }
   runApp(UsdtApp());
}
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
}

class UsdtApp extends StatelessWidget {
   UsdtApp({Key? key}) : super(key: key);

  @override

  Widget build(BuildContext context){
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: IntroScreen(),
    );
  }
}

 class IntroScreen extends StatefulWidget {
   const IntroScreen({Key? key}) : super(key: key);

   @override
   _IntroScreenState createState() => _IntroScreenState();
 }

 class _IntroScreenState extends State<IntroScreen> {

   @override
   void initState() {
     super.initState();
     FirebaseMessaging.instance
         .getInitialMessage()
         .then((var message) {
       if (message!.contentAvailable) {
         Navigator.push(context, MaterialPageRoute(builder: (context){
         return   ChoiceUserScreen();
         }));
       }
      });
     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
       RemoteNotification? notification = message.notification;
       AndroidNotification? android = message.notification?.android;
       if (notification != null && android != null && !kIsWeb) {
         flutterLocalNotificationsPlugin.show(
             notification.hashCode,
             notification.title,
             notification.body,
             NotificationDetails(
               android: AndroidNotificationDetails(
                 channel.id,
                 channel.name,
                 channel.description,
                 // TODO add a proper drawable resource to android, for now using
                 //      one that already exists in example app.
                 icon: 'launch_background',
               ),
             ));
       }
     });

     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
       print('A new onMessageOpenedApp event was published!');
       Navigator.push(context, MaterialPageRoute(builder: (context){
         return   ChoiceUserScreen();
     }));
   }


     );}

   @override
   Widget build(BuildContext context) {
     User? user =FirebaseAuth.instance.currentUser;
     print(user);
     if(user == null){


       return Stack(
         children: [
           SignInScreen(),
           Padding(
             padding: EdgeInsets.only(right: 30, bottom: 35   ),
             child: Align(
               alignment: Alignment.bottomRight,
               child: FloatingActionButton(child: Text("تخطي "),onPressed: (){
                 Navigator.pushAndRemoveUntil((context), MaterialPageRoute(builder: (context){
                   return ChoiceUserScreen();
                 }
                 ), (e) => false);
               },),
             ),
           )
         ],
       );
     } else {
       if(user.email.toString() == "ahmadihssan1324@gmail.com"){
         return AdmPageView();
       }
       else{
         return ChoiceUserScreen();

       }
     }
   }


}




