import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:usdt_jordan/Admin/admin_chat/adm_chat_controller.dart';
import 'package:http/http.dart' as http;

class OneChatAdmin extends StatefulWidget {
  final String emailOneChat;
  final bool userRead;

  const OneChatAdmin({Key? key, required this.emailOneChat, required this.userRead}) : super(key: key);

  @override
  _OneChatAdminState createState() => _OneChatAdminState();
}

class _OneChatAdminState extends State<OneChatAdmin> {
  final  String _serverKey =  "AAAA1thofuU:APA91bFdDVzLxwNrJjY5w0JgaXl2CC9vNa0u0s3S9Pl49la473LaFNcVZ8wGU-YNE4edRHGF_l9tpCX8zVoYKVz-5HlJGyj6GeS6FvIWZ-hZeVSqhoqTBPRHEwUWmhokjRlnxk0AerNT";
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  AdmChatController _admChatController = AdmChatController();
  CollectionReference _reference =
  FirebaseFirestore.instance.collection("all_chats");
  User? user = FirebaseAuth.instance.currentUser;
  TextEditingController _textEditingController = TextEditingController();
  late String _uid ;
  late String _currentEmail;
   ScrollController _controller =ScrollController();
   String _readedTime = "non";
   String _readedMessage = "non";
   String _UpadateReadTimeSend ="non";
   String _UpdateReadMessageSend ="non";
   List<String> _userToken =[];
  @override
  void initState() {
    super.initState();

    FirebaseFirestore.instance.collection("all_chats").doc(widget.emailOneChat).get().then((value){
      setState(() {
        _readedTime = value["readed_time"];

      });
    });

  }

  @override
  void dispose() {
    _controller.dispose();
    _textEditingController.dispose();
    UpdateAdmin(widget.emailOneChat);
    super.dispose();

  }
  Future<void> UpdateAdmin(String email)async{
    try{
      await _admChatController.UpdateAdminState(email);

    }
    catch(e){
      Fluttertoast.showToast(msg: "$e");
    }
  }
  @override
  Widget build(BuildContext context) {
   _uid = user!.uid;
   _currentEmail = user!.email!;
    print(" 5555");
    return Scaffold(
      body:


          Column(children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(

              stream: _reference.doc(widget.emailOneChat).collection("chat").orderBy("time",descending: true).snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
                if(snapshot.hasError){return Text("error");}
                     else if(!snapshot.hasData){
                       return Container(
                         alignment: Alignment.center,
                         child: Text("لا يوجد بيانات"),
                       );
              }
                //     width: 30,
                //     height: 30,
                //     child: Container(width: 50,height: 50,child: CircularProgressIndicator(backgroundColor: Colors.blue, )));
                  else  {
                    return ListView.builder(

                  controller: _controller,
                    reverse: true,
                      itemBuilder: (context, index){

                       DocumentSnapshot userData =
                        snapshot.data!.docs[index];
                    if(_uid == userData["uid"]){
                      if(index == 0){
                        return _drawCurrentUserMessageIndexFirst(userData);
                      }
                      else{
                        return _drawCurrentUserMessage(userData);
                      }

                    }
                    else{
                      String _time =snapshot.data!.docs.first["message"].toString();

                      print("$_time 8888888");

                      return _drawOtherMessage(userData);
                    }},itemCount:  snapshot.data!.docs.length,
                 );
              }

            },

            ),

          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.06,
            color: Colors.white,
            child: Form(
              key: _key,
              child: Row(
                children: [
                  Expanded(child: Container(child: TextFormField(
                    textAlign: TextAlign.center,
                     controller: _textEditingController,
                    validator: (value){
                       if(value==null || value.toString().isEmpty){return "الرسالة فارغة";}
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
              padding: EdgeInsets.only(right: 5,left: 5),
                    margin: EdgeInsets.only(right: 5,left: 5),
                    height: MediaQuery.of(context).size.height * 0.045,

                    decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25.0)
                  ),)),
                  Container(
                    margin: EdgeInsets.only(right: 10),
                      width: MediaQuery.of(context).size.width * 0.12,
                      height: MediaQuery.of(context).size.height * 0.05,
                      child: ElevatedButton(
                          onPressed:   ()async
                          {
                           if(_key.currentState!.validate()){
                             try{
                               String  _message =_textEditingController.text.toString().trim();
                               await _admChatController.SendAdmMessage(widget.emailOneChat, _uid,_message );
                               _textEditingController.clear();
                               await _admChatController.GetUpdateMessage("admin",
                                   _message, widget.emailOneChat);
                               await _sendPushMessage(_message);
                             }
                             catch(e){
                               Fluttertoast.showToast(msg: "$e");
                             }

                           }
                          }, child: Icon(Icons.send)))
                ],
              ),
            ),
          )
        ]),
         // Align(
         //   alignment: Alignment.topLeft,
         //
         //   child: Padding(
         //     padding: const EdgeInsets.only(left: 16, top: 16),
         //     child: FloatingActionButton(onPressed:()async{
         //       if(_UpadateReadTimeSend != "non"){
         //         await _admChatController.GetUpdateReadMessage(_UpdateReadMessageSend, _UpadateReadTimeSend,
         //             widget.emailOneChat);
         //              setState(() {
         //                _UpdateReadMessageSend = "non";
         //                _UpadateReadTimeSend ="non";
         //              });
         //       }
         //
         //     },
         //
         //       child: Icon(Icons.mark_chat_read),),
         //   ),
         // )


    );
  }

  Widget _drawCurrentUserMessage(DocumentSnapshot snapshot) {
    return Column(
      children: [
        Row(
          children: [
            Container(
                color: Colors.transparent,
                width: MediaQuery.of(context).size.width * 0.4),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.blue,

                ),
                padding: EdgeInsets.all(8),
                margin: EdgeInsets.only(right: 14,   top: 8),
                child: Text(
                  snapshot["message"],
                  textAlign: TextAlign.right,
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            )
          ],
        ),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children:[Container(), Container(
              padding: EdgeInsets.only(right: 8,bottom: 12),
              child: Text( snapshot["messageTime"],
              textAlign: TextAlign.right,),)])

      ],
    );
  }

  Widget _drawCurrentUserMessageIndexFirst(DocumentSnapshot snapshot) {
    return Column(
      children: [
        Row(
          children: [
            Container(
                color: Colors.transparent,
                width: MediaQuery.of(context).size.width * 0.4),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.blue,

                ),
                padding: EdgeInsets.all(8),
                margin: EdgeInsets.only(right: 14,   top: 8),
                child: Text(
                  snapshot["message"],
                  textAlign: TextAlign.right,
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            )
          ],
        ),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children:[Container(), Container(
              padding: EdgeInsets.only(right: 8,bottom: 12),
              child: Text( snapshot["messageTime"],
                textAlign: TextAlign.right,),),Icon( widget.userRead ? Icons.done: Icons.timer,
            color:  widget.userRead? Colors.green : Colors.red,) ])

      ],
    );
  }

  Widget _drawOtherMessage(DocumentSnapshot snapshot) {
    return Column(
        children:[
          Row(
          children: [
            Expanded(
                child: Container(
                  decoration: BoxDecoration(
                      color: Color.fromRGBO(19, 52, 86, 1.0),
                      borderRadius: BorderRadius.circular(30)
                  ),
                  padding: EdgeInsets.all(8),
                  margin: EdgeInsets.only(left: 14, bottom: 8, top: 8),
                  child: Text(snapshot["message"],
                    textAlign: TextAlign.left,
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                )),
            Container(
                color: Colors.transparent,
                width: MediaQuery.of(context).size.width * 0.4),
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


  Widget _loadingScreen(){
    return Container(color: Colors.red,);
  }
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
    print("statusCode is: ${response.statusCode} $_userToken");
    }
    catch (e) {
      print('error is: $e');
    }
  }

  String constructFCMPayLoad(String message){
    print("44444");
    String _topic = widget.emailOneChat.replaceFirst(RegExp("@"), "a");
    print("$_topic");
    return jsonEncode({
      // if error try / befro to below
      'to':'/topics/$_topic',

      'notification':{
        'title': 'فريق الدعم',
        'body': "$message"
      }
    });
  }


 }
