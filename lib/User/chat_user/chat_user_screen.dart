import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:usdt_jordan/User/chat_user/chat_user_controller.dart';
import 'package:usdt_jordan/Utilities/MyBackgroundsColors.dart';
import 'package:usdt_jordan/Utilities/generalStyle.dart';
import 'package:http/http.dart' as http;
import 'package:usdt_jordan/referal_code/genarateReferalCode.dart';

class UserChatScreen extends StatefulWidget {
 final String emailUserScreen ;
 final String nameUserCurrent;
 final String token;
  const UserChatScreen({Key? key, required String this.emailUserScreen,
    required String this.nameUserCurrent, required String this.token}) : super(key: key);

  @override
  _UserChatScreenState createState() => _UserChatScreenState();
}

class _UserChatScreenState extends State<UserChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final  String _serverKey =  "AAAA1thofuU:APA91bFdDVzLxwNrJjY5w0JgaXl2CC9vNa0u0s3S9Pl49la473LaFNcVZ8wGU-YNE4edRHGF_l9tpCX8zVoYKVz-5HlJGyj6GeS6FvIWZ-hZeVSqhoqTBPRHEwUWmhokjRlnxk0AerNT";
  User? _user;


  String _uid = "";
  String _email = "";
  CollectionReference _reference =
  FirebaseFirestore.instance.collection("all_chats");
  ScrollController _scrollController = ScrollController();


  String _fullNAme = "أنت غير مسجل_ فريق الدعم !!";

  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser;
    if (_user != null) {
      _uid = _user!.uid!;
      print("uidd $_uid");
      _email = _user!.email!;
      setState(() {
        _fullNAme = widget.nameUserCurrent;
      });
    }
   }


Future<void> _updateUser(String email)async{

    await _chatController.UpdateUserState(email);
}

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
    _updateUser(widget.emailUserScreen);
    _scrollController.dispose();
  }

  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  UserChatController _chatController = UserChatController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(_fullNAme),
        ),
        body: (_user == null) ? _drawNonUserScreen()
            : _drawUserMessageSignScreen()
    );
  }

  Widget _drawCurrentUserMessage(DocumentSnapshot snapshot) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [

            Container(

                color: Colors.transparent,
                width: MediaQuery
                    .of(context)
                    .size
                    .width * 0.4),

            Flexible(
              child
                  : Container(

                decoration: BoxDecoration(
                  border:
                  Border.all(color: Colors.blue, width: 1),
                  borderRadius: BorderRadius.circular(18
                  ),
                  color: Colors.white,

                ),
                padding: EdgeInsets.all(8),
                margin: EdgeInsets.only(right: 14, top: 8),
                child: Text(

                  snapshot["message"], textAlign: TextAlign.right,
                  style: TextStyle(color: Colors.black, fontSize: 18,
                  ),
                ),
              ),
            ),


          ],
        ),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Container(), Container(
              padding: EdgeInsets.only(right: 8, bottom: 12),
              child: Text(snapshot["messageTime"],
                textAlign: TextAlign.right,),)
            ])

      ],
    );
  }

  Widget _drawOtherMessage(DocumentSnapshot snapshot) {
    return Column(
        children: [
          Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
                child: Container(
                  decoration: BoxDecoration(
                      color: Color.fromRGBO(19, 52, 86, 1.0),
                      borderRadius: BorderRadius.circular(18)
                  ),
                  padding: EdgeInsets.all(8),
                  margin: EdgeInsets.only(left: 14, bottom: 8, top: 8),
                  child: Text(snapshot["message"], textAlign: TextAlign.left,
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                )),
            Container(
                color: Colors.transparent,
                width: MediaQuery
                    .of(context)
                    .size
                    .width * 0.4),
          ],
        ),

          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children:[ Container(
                padding: EdgeInsets.only(left: 18,bottom: 12),
                child: Text( snapshot["messageTime"],
                  textAlign: TextAlign.right,),),Container(),])

        ]
    );
  }

  Widget _drawUserMessageSignScreen() {
    return Column(children: [
      Expanded(child:

      StreamBuilder<QuerySnapshot>(

        stream: _reference.doc(widget.emailUserScreen).collection("chat")
            .orderBy("time", descending: true)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            print("error message is: ${snapshot.error}");
            return Text("error");
          }
          switch (snapshot.connectionState) {
            case ConnectionState.none :
              return
                _drawLoadingScreen();
            case ConnectionState.waiting :
              return
                _drawLoadingScreen();
            default :
              return ListView(
                controller: _scrollController,
                reverse: true,
                scrollDirection: Axis.vertical,
                children: snapshot.data!.docs.map((DocumentSnapshot document) {
                  if (_uid == document["uid"]) {
                    return _drawCurrentUserMessage(document);
                  }
                  else {
                    print("666666 $document");
                    return _drawOtherMessage(document);
                  }
                }).toList(),
              );
          }
        },
      ),


      ),
      Container(
          height: MediaQuery
              .of(context)
              .size
              .height * 0.07,
          color: Colors.white,
          child: Form(
              key: _key,
              child: Row(children: [
                Expanded(
                    child: Container(
                      
                      child: TextFormField(

                        textAlign: TextAlign.center,
                        controller: _controller,
                        validator: (value) {
                          if (value.toString() == null ||
                              value
                                  .toString()
                                  .length == 0) {
                            Fluttertoast.showToast(msg: "الرسالة فارغة ",
                                gravity: ToastGravity.CENTER);
                            return "الريالة فارغة";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            labelText: "message",
                          labelStyle: TextStyle(
                            color: Colors.grey
                          ),
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                        ),
                      ),
                      padding: EdgeInsets.only(right: 5, left: 5),
                      margin: EdgeInsets.only(right: 5, left: 5),
                      height: MediaQuery
                          .of(context)
                          .size
                          .height * 0.07,
                      decoration: BoxDecoration(
                          color: Color.fromRGBO(243, 243, 245, 1),
                          borderRadius: BorderRadius.circular(25.0)),
                    )),
                Container(
                    margin: EdgeInsets.only(right: 10),
                    width: MediaQuery
                        .of(context)
                        .size
                        .width * 0.12,
                    height: MediaQuery
                        .of(context)
                        .size
                        .height * 0.05,
                    child: ElevatedButton(
                        child: Icon(Icons.send),
                        onPressed: () async {
                          if (_key.currentState!.validate()) {
                           String _message =_controller.text.toString();
                            _controller.clear();

                            await _chatController.SendUserMessage(
                                widget.emailUserScreen
                                , _uid!,_message
                               , _fullNAme);
                           await _chatController.GetUpdateMessage(
                              _fullNAme, _message,
                              widget.emailUserScreen,);
                             await _sendPushMessage(_controller.text.toString()) ;

                          }
                        }))
              ])))
    ]);
  }

  Widget _drawNonUserScreen() {
    return Container(
      padding: EdgeInsets.only(right: 25),
      color: MyBackGrounsColors.appBodyColor(),
      child: Center(
          child: Text(
            "  الرجاء تسجيل الدخول لمحادثة فريق الدعم \n .شكرا لتفهمكم",
            style: Generalstyle.bodyTextImportant(),
            textAlign: TextAlign.right,)),
    );
  }

  Widget _drawLoadingScreen() {
    return Container(
      width: MediaQuery
          .of(context)
          .size
          .width,
      height: MediaQuery
          .of(context)
          .size
          .height,
      color: MyBackGrounsColors.appBodyColor(),
      child: Center(
        child: SizedBox(
            width: 50,
            height: 50,
            child: CircularProgressIndicator(value: 50,)),
      ),
    );
  }

  // List<Map<String, dynamic>> _drawinitData(){
  //     List<Map<String, dynamic>>  _listDocumetns = [];
  //      Map<String, dynamic> _map1 = Map<String, dynamic>();
  //     Map<String, dynamic> _map2 = Map<String, dynamic>();
  //   _map1.addAll({
  //     "message":"",
  //     "messageTime":"",
  //     "time":"",
  //     " uid":""
  //   });
  //     _map2.addAll({
  //       "message":"",
  //       "messageTime":"",
  //       "time":"",
  //       " uid":""
  //     });
  //   _listDocumetns.add(_map1);
  //   _listDocumetns.add(_map2);
  //   return _listDocumetns;
  // }
  Future<void> _sendPushMessage(String message) async {
    try {
      var response = await http.post(
          Uri.parse('https://fcm.googleapis.com/fcm/send'),
          headers: <String, String>{
            "Content-Type": "application/json",
            "Accept": "application/json",
            "Authorization": "key= $_serverKey"
          },
          body:constructFCMPayLoad(message)

      );
      print("statusCode is: ${response.statusCode} ");
    }
    catch (e) {
      print('error is: $e');
    }
  }

  String constructFCMPayLoad(String message){
    print("44444");

    return jsonEncode({
      // if error try / befro to below
      'to':'/topics/admin',

      'notification':{
        'title': "${widget.nameUserCurrent}",
        'body': "$message"
      }
    });
  }



}
