import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ntp/ntp.dart';

class UserChatController{
  CollectionReference _reference = FirebaseFirestore.instance.collection("all_chats");

  Future<void> SendUserMessage(String email, String uid, String message,String name) async {
   String _uid =    FirebaseAuth.instance.currentUser!.uid;
    Map<String, dynamic> _sendMessageMAp = Map<String, dynamic>();
    await NTP.now().then((value) async {
       String _timeTrim = value.toString().substring(0 , 19);
      print("66666 $_timeTrim");
      _sendMessageMAp = {
        "uid": _uid,
        "time": value.toString(),
        "message": message,
        "messageTime": _timeTrim
      };
      print("55555555 $_sendMessageMAp");
      await  _reference.doc(email).collection("chat").add(_sendMessageMAp);
    });


  }




  Future<void> SetUpdateMessage(String LastMessage,String Name, String email )async{
    Map<String, dynamic> _SetUpdate = Map<String, dynamic>();
      await NTP.now().then((value)async{
        _SetUpdate = {
          "updatedMessage": LastMessage,
          "time":value.toString(),
          "show_time":value.toString().substring(0,19),
          "name":Name,
          "email": email,
          "read_state": false,
          "read_admin_state": false
        };
        await _reference.doc(email).set(_SetUpdate);
      });


  }
  Future<void> GetUpdateMessage(String name, String UpdatedMessage, String email)async{
    Map<String, dynamic> _SetUpdate = Map<String, dynamic>();
     await NTP.now().then((value)async{
       _SetUpdate = {
         "updatedMessage": UpdatedMessage,
         "time":value.toString(),
         "show_time":value.toString().substring(0,19),
         "name":name,
         "read_admin_state": false

       };
         await _reference.doc(email).update(_SetUpdate);
     });

  }
  Future<void> UpdateUserState(String email)async{
    Map<String, dynamic> _SetUpdate = Map<String, dynamic>();
   _SetUpdate={
     "read_state":true
   };


    return await _reference.doc(email).update(_SetUpdate);

  }
}



