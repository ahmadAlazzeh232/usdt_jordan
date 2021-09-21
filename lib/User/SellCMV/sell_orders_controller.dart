import 'package:cloud_firestore/cloud_firestore.dart';

class SellOredersController{



  CollectionReference _reference = FirebaseFirestore.instance.collection("sell_orders");
  CollectionReference _historyReference =  FirebaseFirestore.instance.collection("user_history");
  Future<void> sendSellOrders (String name, String email, String number,
      String usdt, String UsdtAfterDis, String dinar, String time, ) {
    return  _reference.add({
      "time":time.toString(),
      "show_time":time.toString().substring(0,16),
      "usdt_amount":usdt,
      "dinar_amount":dinar,
      "email":email,
      "number":number,
      "name":name,
      "usdt_after_dis":UsdtAfterDis,
      "payment_method":"non",
      "wallet":"non",

    });
  }
   Future<void> sendHistoryUser(String name, String email, String amount,String time  ){
    return _historyReference.doc(email).collection("history_user").add({
       "time":time.toString(),
      "show_time":time.toString().substring(0,16),
      "name": name,
      "email": email,
      "type": "بيع",
      "usdt_amount": amount,
       "order_state": 1
    });
   }
   
}

