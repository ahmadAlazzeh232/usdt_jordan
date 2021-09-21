import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ntp/ntp.dart';


class BuyOrdersController{
  CollectionReference _referenceAdminAcceptedHistory = FirebaseFirestore.instance.collection("admin_accepted_orders");
  CollectionReference _referenceAdminDeletedHistory = FirebaseFirestore.instance.collection("admin_deleted_orders");
  CollectionReference _referenceUsersInfo = FirebaseFirestore.instance.collection("usersInfo");
  CollectionReference _StringIDreference = FirebaseFirestore.instance.collection("buy_orders");
  CollectionReference _updateReference = FirebaseFirestore.instance.collection("user_history");
  CollectionReference _collectionReferenceReferelCode = FirebaseFirestore.instance.collection("referel_code");
 CollectionReference _collectionReferenceCount = FirebaseFirestore.instance.collection("buy_count");
 CollectionReference _collectionReferenceViaMoth = FirebaseFirestore.instance.collection("buy_count_month");
  String pathDocument="";
  Future<void> sendAcceptedOederToUserHistory(String email, String time) async{

       await getTheDocumentInfo(email, time).then((value) async {

          await  _updateReference.doc(email).collection("history_user")
             .doc(pathDocument).update({"order_state": 2});
       });
    print("as 77777");

  }
  Future<void> sendDeletedOederToUserHistory(String email, String time) async{
   print("88888 $time");
    pathDocument =   await getTheDocumentInfo(email, time);
    print("as 77777");

    return await  _updateReference.doc(email).collection("history_user")
        .doc(pathDocument).update({"order_state": 0});
  }
  Future<String> getTheDocumentInfo(String email, String time)async{
    print("77777 $time");
    var _query = await _updateReference.doc(email).collection("history_user")
        .where("time" ,isEqualTo: time ).get();
    pathDocument= _query.docs.first.id;

    print("7777788 $pathDocument");

    return pathDocument ;
  }

  Future<void> deletBuyOrder(String email , String time)async{
    print("5252525");
    String _idDelet = await getIDforDelet(email, time);
   await _StringIDreference.doc(_idDelet).delete();
  }
  Future<String> getIDforDelet(String email, String time )async{
   print("12121212");
    var _query = await _StringIDreference.
    where("time", isEqualTo: time ).
    where("email", isEqualTo: email).get();
     String _deletId = _query.docs.first.id;
      print("44444 $_deletId");

      return _deletId;

  }

  Future<void> sendAdminAcceptedHistory(String time,String showTime,String name, String email, String usdtAmount,
      String dinarAmount ,String number,String wallet, String payMethod, String useCode)async{
      await  _referenceAdminAcceptedHistory.add({
        "time":time,
        "show_time":showTime,
        "name":name,
        "number":number,
        "email":email,
        "usdt_amount":usdtAmount,
        "dinar_amount":dinarAmount,
        "type":"شراء ",
        "wallet":wallet,
        "payment_method":payMethod,
        "use_code":useCode
      });


  }
  Future<void> sendAdminDeletedHistory(String name, String email, String usdtAmount,
      String dinarAmount,String time,String number,String wallet, String payMethod, String useCode
      )async{

    await  _referenceAdminDeletedHistory.add({
     "time":NTP.now().toString(),
      "show_time":NTP.now().toString(),
      "name":name,
      "number":number,
      "email":email,
      "usdt_amount":usdtAmount,
      "dinar_amount":dinarAmount,
      "type":"شراء ",
      "wallet":wallet,
      "payment_method":payMethod,
      "use_code" :useCode
    });


  }
  Future<void> sendUpdateRevarelViaNum(email)async{
    await _referenceUsersInfo.doc(email).get().then((value)async{
      String _emailFather = value["refrel_via"];
      if(_emailFather != "non"){
        await _collectionReferenceReferelCode.doc(_emailFather).get().then((value)async{
          int _numOfDoneOrders = value["#_done_order"];
          await _collectionReferenceReferelCode.doc(_emailFather).update({
            "#_done_order": _numOfDoneOrders +1
          });
        });
      }
    });
  }
  Future<void> sendTimeCountBuyHistory(String dinar , String usdt )async{
    print("44444 8888");


    await _collectionReferenceCount.doc("buy_count").get().then((value)async{
      print("44444 8888");

      int _orders = int.parse(value["all_buy_orders"]) +1 ;

      double _usdtNet =double.parse(value["all_buy_usdt"])  ;
      print("44444 8888");

      double _dinarNet =double.parse(value["all_buy_dinar"]);

      double _usdt =double.parse(usdt) ;
      double _dinar = double.parse(dinar);
      String _finalUsdt = (_usdtNet + _usdt).toStringAsFixed(2);
      String _fnaalDinar = (_dinarNet + _dinar).toStringAsFixed(2);
      String _inttt = _orders.toString();
            print("44444 $_usdtNet");
          await _collectionReferenceCount.doc("buy_count").update({
      "all_buy_orders":_inttt,
      "all_buy_dinar":_fnaalDinar,
      "all_buy_usdt":_finalUsdt
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
           int _orders = int.parse(value["all_buy_orders"]) +1 ;

           double _usdtNet =double.parse(value["all_buy_usdt"])  ;
           print("44444 8888");

           double _dinarNet =double.parse(value["all_buy_dinar"]);

           double _usdt =double.parse(usdt) ;
           double _dinar = double.parse(dinar);
           String _finalUsdt = (_usdtNet + _usdt).toStringAsFixed(2);
           String _fnaalDinar = (_dinarNet + _dinar).toStringAsFixed(2);
           String _inttt = _orders.toString();
           _collectionReferenceViaMoth.doc(_doc).update({
             "all_buy_orders":_inttt ,
             "all_buy_dinar": _fnaalDinar,
             "all_buy_usdt": _finalUsdt
           });
           Fluttertoast.showToast(msg: " exist");
         }else{
           _collectionReferenceViaMoth.doc(_doc).set({
             "all_buy_orders": "1",
             "all_buy_dinar":dinar,
             "all_buy_usdt":usdt
           });
           Fluttertoast.showToast(msg: "not exist");

         }
       });
   });
   }

}