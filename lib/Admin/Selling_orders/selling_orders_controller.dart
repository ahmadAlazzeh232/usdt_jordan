import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ntp/ntp.dart';

class SellingOrdersController {
  CollectionReference _referenceAdminAcceptedHistory = FirebaseFirestore.instance.collection("admin_accepted_orders");
  CollectionReference _referenceAdminDeletedHistory = FirebaseFirestore.instance.collection("admin_deleted_orders");

  CollectionReference _collectionReferenceCount = FirebaseFirestore.instance.collection("sell_count");
  CollectionReference _collectionReferenceViaMoth = FirebaseFirestore.instance.collection("sell_count_month");

  CollectionReference _StringIDreference = FirebaseFirestore.instance.collection("sell_orders");
  CollectionReference _updateReference = FirebaseFirestore.instance.collection("user_history");
    String pathDocument="";
Future<void> sendAcceptedOederToUserHistory(String email, String time) async{

  pathDocument =   await getTheDocumentInfo(email, time);
    print("as 77777");

  return await  _updateReference.doc(email).collection("history_user")
       .doc(pathDocument).update({"order_state": 2});
}
Future<String> getTheDocumentInfo(String email, String time)async{
   print("77777 $time");
    var _query = await _updateReference.doc(email).collection("history_user")
      .where("time" ,isEqualTo: time).get();
     pathDocument= _query.docs.first.id;

   print("77777 $pathDocument");

      return pathDocument ;
}

  Future<void> deletSellOrder(String email , String time)async{
  print("01010125");
    String _idDelet = await getIDforDelet(email, time);
   await _StringIDreference.doc(_idDelet).delete();
  }

  Future<void> sendDeletedOederToUserHistory(String email, String time) async{
    print("88888 $time");
    String  pathDocumentdd =   await getTheDocumentInfo(email, time);
    print("as 77777");

    return await  _updateReference.doc(email).collection("history_user")
        .doc(pathDocumentdd).update({"order_state": 0});
  }
  Future<String> getIDforDelet(String email, String time )async{
  var _query = await _StringIDreference.
    where("time", isEqualTo: time ).
    where("email", isEqualTo: email).get();
    String _deletId = _query.docs.first.id;
    print("44444 $_deletId");
    return _deletId;

  }
  Future<void> sendAcceptedAdminHistory(String name, String email, String usdtAmount,
      String dinarAmount,String time,String show_time,String number,)async{
    await  _referenceAdminAcceptedHistory.add({
      "time":time,
      "show_time":show_time,
      "name":name,
      "number":number,
      "email":email,
      "usdt_amount":usdtAmount,
      "dinar_amount":dinarAmount,
      "type":"بيع ",
      "wallet":"non",
      "payment_method":"non",
      "use_code":"0"

    });


  }
  Future<void> sendAdminDeletedHistory(String name, String email, String usdtAmount,
      String dinarAmount,String time,String timeShow,String number, )async{
    await  _referenceAdminDeletedHistory.add({
      "time":time,
      "show_time":timeShow,
      "name":name,
      "number":number,
      "email":email,
      "usdt_amount":usdtAmount,
      "dinar_amount":dinarAmount,
      "type":"بيع ",
      "wallet":"non",
      "payment_method":"non",
      "use_code":"0"

          });


  }
  Future<void> sendTimeCountBuyHistory(String dinar , String usdt )async{
    print("44444 8888");


    await _collectionReferenceCount.doc("sell_count").get().then((value)async{
      print("44444 8888");

      int _orders = int.parse(value["all_sell_orders"]) +1 ;

      double _usdtNet =double.parse(value["all_sell_usdt"])  ;
      print("44444 8888");

      double _dinarNet =double.parse(value["all_sell_dinar"]);

      double _usdt =double.parse(usdt) ;
      double _dinar = double.parse(dinar);
      String _finalUsdt = (_usdtNet + _usdt).toStringAsFixed(2);
      String _fnaalDinar = (_dinarNet + _dinar).toStringAsFixed(2);
      String _inttt = _orders.toString();
      print("44444 $_usdtNet");
      await _collectionReferenceCount.doc("sell_count").update({
        "all_sell_orders":_inttt,
        "all_sell_dinar":_fnaalDinar,
        "all_sell_usdt":_finalUsdt
      });
    });


  }

  Future<void> sendCountViaMonth(String dinar ,String usdt)async{
    await NTP.now().then((value)async{
      String _month = value.month.toString();
      String _year = value.year.toString();
      String _doc = _month+_year;
      _collectionReferenceViaMoth.doc(_doc).get().then((value) {
        if(value.exists){
          int _orders = int.parse(value["all_sell_orders"]) +1 ;

          double _usdtNet =double.parse(value["all_sell_usdt"])  ;
          print("44444 8888");

          double _dinarNet =double.parse(value["all_sell_dinar"]);

          double _usdt =double.parse(usdt) ;
          double _dinar = double.parse(dinar);
          String _finalUsdt = (_usdtNet + _usdt).toStringAsFixed(2);
          String _fnaalDinar = (_dinarNet + _dinar).toStringAsFixed(2);
          String _inttt = _orders.toString();
          _collectionReferenceViaMoth.doc(_doc).update({
            "all_sell_orders":_inttt ,
            "all_sell_dinar": _fnaalDinar,
            "all_sell_usdt": _finalUsdt
          });
          Fluttertoast.showToast(msg: " exist");
        }else{
          _collectionReferenceViaMoth.doc(_doc).set({
            "all_sell_orders": "1",
            "all_sell_dinar":dinar,
            "all_sell_usdt":usdt
          });
          Fluttertoast.showToast(msg: "not exist");

        }
      });
    });
  }
}