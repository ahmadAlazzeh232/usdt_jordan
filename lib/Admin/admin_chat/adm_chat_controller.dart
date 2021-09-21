import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ntp/ntp.dart';
class AdmChatController{
  CollectionReference _reference = FirebaseFirestore.instance.collection("all_chats");

  Future<void>  SendAdmMessage(String UserEmail, String Admuid, String message)async{
    try{
      print("777777");
      await NTP.now().then((value) async {
        print("777777");

        Map<String, dynamic> _sendMessageMAp = Map<String, dynamic>();
         _sendMessageMAp = {
          "uid": Admuid,
          "time":value.toString(),
          "message": message,
          "messageTime": value.toString().substring(0, 19)
        };
        print("55555555 $_sendMessageMAp");
        await   _reference.doc(UserEmail).collection("chat").add(_sendMessageMAp);
      });
    }
    catch(e){Fluttertoast.showToast(msg: "$e 7878778");}


}
  Future<void> GetUpdateMessage(String name, String UpdatedMessage, String email)async{
    try{
      await   NTP.now().then((value)async{
        Map<String, dynamic> _SetUpdate = Map<String, dynamic>();
        _SetUpdate = {
          "show_time":value.toString().substring(0,19),
          "read_state": false,
          "updatedMessage": UpdatedMessage,
          "time": value.toString(),
        };
        await _reference.doc(email).update(_SetUpdate);
      });
    }
    catch(e){Fluttertoast.showToast(msg: "$e");}


  }
  Future<void> UpdateAdminState(String email)async{
    Map<String, dynamic> _SetUpdate = Map<String, dynamic>();
    _SetUpdate ={
      "read_admin_state":true
    };
    try{
      await _reference.doc(email).update(_SetUpdate);

    }
    catch(e){
      Fluttertoast.showToast(msg: "$e");
    }

  }




}


