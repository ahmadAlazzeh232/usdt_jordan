import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ntp/ntp.dart';

class SendOrderController{
  CollectionReference _reference = FirebaseFirestore.instance.collection("buy_orders");
  CollectionReference _historyReference =  FirebaseFirestore.instance.collection("user_history");
  CollectionReference _referelCode =  FirebaseFirestore.instance.collection("referel_code");

  Future<void> sendOrder (String usdt, String dinar, String wallet, String paymentMethod,
      String name,String? email, String number, String time , String _useCode) async {
    try{

         Map<String, dynamic> _buyOrders= Map<String,dynamic>();
        _buyOrders = {
          "time":time,
          "show_time":time.toString().substring(0,16),
          "usdt_amount":usdt,
          "dinar_amount":dinar,
          "email":email,
          "number":number,
          "name":name,
          "payment_method":paymentMethod,
          "wallet":wallet,
          "use_code":_useCode


        };
        await _reference.add(_buyOrders);
     }
    catch(e){}


  }
  Future<void> sendHistoryUser(String name, String email, String usdt, String time )async{
    try{
         await _historyReference.doc(email).collection("history_user").add({
          "name": name,
          "email": email,
          "type": "شراء ",

          "usdt_amount":usdt,
          "time": time,
          "show_time":time.toString().substring(0,16),
          "order_state": 1

        });

    }
    catch(e){}

  }
  Future<void> updateNumReferel(int discountState, int restOf2, String email)async{
    if(discountState == 1){
      try{
        await _referelCode.doc(email).update({
          "#_done_order": 0
        });
      }
      catch(e){}

    }
    else if(discountState == 2 ){
      print("7777 $restOf2");
      try{
        await _referelCode.doc(email).update({
          "#_done_order": restOf2
        });
      }
      catch(e){}

    }
      else if(discountState == 3){
      try{
        await _referelCode.doc(email).update({
          "#_done_order": 0
        });
      }
      catch(e){}

    }
    }


  }

