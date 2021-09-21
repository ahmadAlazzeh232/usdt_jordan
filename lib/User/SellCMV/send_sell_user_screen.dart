import 'dart:async';
import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:usdt_jordan/Authentication/sign_in_screen.dart';
import 'package:usdt_jordan/User/SellCMV/amount_sell_controller.dart';
import 'package:usdt_jordan/User/SellCMV/sell_orders_controller.dart';
import 'package:usdt_jordan/Utilities/MyBackgroundsColors.dart';
import 'package:usdt_jordan/Utilities/generalStyle.dart';
import 'package:http/http.dart' as http;
import '../ChoiceUserScreen.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:ntp/ntp.dart';
class SellUserScreen extends StatefulWidget {
  const SellUserScreen({Key? key}) : super(key: key);

  @override
  _SellUserScreenState createState() => _SellUserScreenState();
}

class _SellUserScreenState extends State<SellUserScreen> {
  late  User? _userState ;
 String _UsdtDis = ".";
 String _Dinar = ".";
 String _name = "";
 String? _email = "";
 String _phone = "";
 final  String _serverKey =  "AAAA1thofuU:APA91bFdDVzLxwNrJjY5w0JgaXl2CC9vNa0u0s3S9Pl49la473LaFNcVZ8wGU-YNE4edRHGF_l9tpCX8zVoYKVz-5HlJGyj6GeS6FvIWZ-hZeVSqhoqTBPRHEwUWmhokjRlnxk0AerNT";
 bool _loadState =false;
 String _usdt = "";
  String _discount =".";
   final SellOredersController _sellController =SellOredersController();
  final TextEditingController _usdtController = TextEditingController();
   final GlobalKey<FormState> _key = GlobalKey<FormState>();
 @override
 void dispose() {
   _usdtController.dispose();

   super.dispose();
 }

 @override
  Widget build(BuildContext context) {
  return  Scaffold(
      appBar: AppBar(
        title: Text("  sell usdt"),
        centerTitle: true,
        backgroundColor: MyBackGrounsColors.appButtonsColor(),
      ),
      body:(_loadState)?               _drawLoadingScreen()

          :
      Container(
         width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: MyBackGrounsColors.appBodyColor(),
        padding:EdgeInsets.only(right: 12,left: 12),
        child:
              Form(
                  key: _key,
                  child: SingleChildScrollView(

                    child: Container(
                       child: Column(
                 children: [
                      SizedBox(height:70,),


                            Container(
                              margin: EdgeInsets.only(right:MediaQuery.of(context).size.width*.1 ),
                             width: MediaQuery.of(context).size.width*.8,
                              height: MediaQuery.of(context).size.height*.13,
                              child: TextFormField(
                                style: TextStyle(color: Colors.white),
                                maxLength: 4,
                                controller: _usdtController,
                                onChanged: (text)  {

                                  if(text!= null && text.toString().length!=0 && text!=""){
                                    String _setValueAfterDis=  AmountSellController.UsdtSubtract(text.toString());
                                    String _moneyValue = AmountSellController.moneyValue(_setValueAfterDis.toString());
                                    if(int.parse(text.toString()) >3 && int.parse(text.toString())<499){
                                      _discount = " 3 USDT";
                                    }
                                    else if(int.parse(text.toString())>= 500 && int.parse(text.toString())<1001){
                                      _discount = "2 USDT";
                                    }
                                    else{
                                      Fluttertoast.showToast(msg: "النطاق 4 - 1000",
                                          gravity: ToastGravity.CENTER,
                                         toastLength: Toast.LENGTH_SHORT);
                                      _discount = ".";
                                      setState(() {
                                        _discount;
                                      });
                                    }

                                    setState(() {
                                      _discount;
                                      print("$_UsdtDis 55555");
                                      _UsdtDis = _setValueAfterDis;
                                      print("$_UsdtDis 55555");
                                     _Dinar = _moneyValue;

                                     });

                                  }else{
                                    setState(() {
                                      _UsdtDis =".";
                                      _discount =".";
                                      _Dinar =".";
                                    });
                                  }
                                },
                                keyboardType: TextInputType.number ,
                                textAlign:TextAlign.center ,
                                decoration:InputDecoration(
                                    counterStyle: TextStyle(
                                        color: MyBackGrounsColors.appBodyColor()
                                    ),
                                     border: Generalstyle.textFieldBorder(),
                                    labelText: "USDT",
                                    filled: true,

                                    labelStyle: Generalstyle.formTextStyle()),
                                validator:(value){
                                  if (value.toString().isEmpty || value ==null ||
                                      value.toString().length==0){
                                    Fluttertoast.showToast(msg: "USDT الرجاء إدخال قيمة ال",
                                        gravity: ToastGravity.CENTER);
                                    return "USDT الرجاء إدخال قيمة ال ";}
                                  else if(  int.parse(value)<4){
                                    Fluttertoast.showToast(msg: "(4 - 999)ادخل رقما بين",
                                        gravity: ToastGravity.CENTER);

                                    return "  (4 - 999)ادخل رقما بين " ;
                                  }else if(  int.parse(value)>1000){
                                    Fluttertoast.showToast(msg: "(4 - 999)ادخل رقما بين",
                                        gravity: ToastGravity.CENTER);

                                    return "  (4 - 999)ادخل رقما بين " ;
                                  }
                                  return null;
                                } ,
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(right:  MediaQuery.of(context).size.width*0.6),
                                  alignment: Alignment.center,
                               decoration: BoxDecoration(
                                  border: Border.all(width: 2, color: MyBackGrounsColors.appButtonsColor()),
                                shape: BoxShape.rectangle,

                              ),
                              width: MediaQuery.of(context).size.width*0.3,
                              height: MediaQuery.of(context).size.height*.12,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Text(_discount,  style: TextStyle(color: Colors.white, fontSize: 18)),
                                  Text("قيمة العمولة ", style: TextStyle(color: Colors.white, fontSize: 18))
                                ],
                              ),
                            ),



                      SizedBox(height: 60,),
                      Container(
                        height: MediaQuery.of(context).size.height*.1,
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Container(
                                width: MediaQuery.of(context).size.width*.22,
                                alignment: Alignment.center,

                                child: Text(_UsdtDis,style: TextStyle(color: Colors.white, fontSize: 18))),
                          Container(
                            width: MediaQuery.of(context).size.width*.7,
                            child: Text("     بعد خصم العمولة USDT قيمة ال ",
                                style: TextStyle(color: Colors.white, fontSize: 18))
                          ),

                        ],),
                      ),
                       Container(
                                     height: 2,
                                     color: MyBackGrounsColors.appButtonsColor(),
                                     margin: EdgeInsets.only(right: 8, left: 8),
                                   ),
                       Container(

                        height: MediaQuery.of(context).size.height*.1,
                        width: MediaQuery.of(context).size.width,
                        child:
                        Row(children: [

                          Container(
                            alignment: Alignment.center,
                              width: MediaQuery.of(context).size.width*.22,

                              child: Text(_Dinar, style: TextStyle(color: Colors.white, fontSize: 18))),
                          Container(
                              width: MediaQuery.of(context).size.width*.7,
                              child: Text("القيمة المحولة إلى حسابك بالدينار ",
                                  style: TextStyle(color: Colors.white, fontSize: 18))
                                  ),
                        ],),
                      ),
                   SizedBox(height: 60,),

                   Container(
                        padding: EdgeInsets.only(right: 10, left: 10),
                        width: MediaQuery.of(context).size.width,
                        height: 60,
                         alignment: Alignment.center,
                        child: Text(" سوف يتم الإتفاق مع العميل على وسيلة الدفع واستقبال الأموال الخاصة به ",
                        style: TextStyle(color: Colors.white, fontSize: 16 ,
                            decoration: TextDecoration.underline,
                            fontWeight: FontWeight.w500, ),textAlign: TextAlign.right,),
                      ),

                      SizedBox(height: 20,),
                      Container(height: 80,width: MediaQuery.of(context).size.width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [

                          SizedBox(width: 60,),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: ()async{
                              await Connectivity().checkConnectivity().then((value) async {
                                if(value == ConnectivityResult.mobile || value == ConnectivityResult.wifi){
                                    if(_key.currentState!.validate()){
                                       setState(() {
                                         _loadState=true;
                                       });

                                 try{

                                   var response = await http.get(
                                     Uri.parse('https://www.google.com/'),
                                   ).timeout(Duration(seconds: 15));
                                   if(response.statusCode == 200){
                                     try{

                                       _userState =  FirebaseAuth.instance.currentUser;
                                       print("111110");

                                       if(_userState != null){
                                         _email = _userState!.email.toString();

                                         await FirebaseFirestore.instance.collection("usersInfo").doc(_email).
                                          get().then((value) async {



                                            _name = value["full_name"];

                                            _phone = value["number"];
                                            _usdt = _usdtController.text.toString().trim();

                                            await NTP.now().then((value) async {
                                              print("888888");

                                              await _sellController.sendSellOrders(_name, _email!, _phone, _usdt,
                                                  _UsdtDis, _Dinar, value.toString());
                                              await _sendPushMessageOrder();
                                              await _sellController.sendHistoryUser(_name, _email!,_usdt,value.toString() );
                                              setState(() {
                                                _loadState = false ;
                                              });
                                              Navigator.push((context), MaterialPageRoute(builder: (context){

                                                return ChoiceUserScreen();
                                              }));
                                              Fluttertoast.showToast(msg: "لقد تم إرسال طلبك \n سوف يتم التواصل معك بالسرعة القصوى",
                                                  toastLength: Toast.LENGTH_LONG, gravity: ToastGravity.CENTER);
                                            });
                                          });



                                       }
                                       else{
                                         setState(() {
                                           _loadState =false;
                                         });
                                         Fluttertoast.showToast(msg: "you should sign in to use app",
                                             toastLength:Toast.LENGTH_LONG,gravity: ToastGravity.CENTER );
                                         Navigator.push((context),MaterialPageRoute(builder: (context){
                                           return SignInScreen();
                                         }) );
                                         ;                         }



                                     }
                                     catch(e){
                                      setState(() {
                                        _loadState =false;
                                      });
                                       Fluttertoast.showToast(msg: "00 $e");
                                     }

                                   }
                                   else{
                                     setState(() {
                                       _loadState = false;
                                     });
                                     Fluttertoast.showToast(msg: "حدث خطأ ما, الرجاء العودة لاحقا");
                                   }


                                 }
                                 catch(e){
                                   setState(() {
                                     _loadState = false;
                                   });
                                   Fluttertoast.showToast(msg: "أنت غير متصل, الرجاء التأكد من توفر حزم الانترنت", toastLength: Toast.LENGTH_SHORT,
                                       gravity: ToastGravity.CENTER);
                                 }






                                    }



                                }
                                else{
                                  Fluttertoast.showToast(msg: "الرجاء الإتصال بالانترنت ومعاودة المحاولة",
                                  toastLength: Toast.LENGTH_SHORT,  gravity: ToastGravity.CENTER);
                                }
                              });





                          }, child:Text("sell",style: TextStyle(
                            color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold
                          ),),style: Generalstyle.appButtonStyle(),),
                        ),
                        SizedBox(width: 60,)],
                      ),)


                ],

              ),
                    ),
                  ))

      ),
    );
  }
 Future<void> _sendPushMessageOrder() async {
   try {
     var response = await http.post(
         Uri.parse('https://fcm.googleapis.com/fcm/send'),
         headers: <String, String>{
           "Content-Type": "application/json",
           "Accept": "application/json",
           "Authorization": "key= $_serverKey"
         },
         body:constructFCMPayLoad()

     );
     print("statusCode is: ${response.statusCode} ");
   }
   catch (e) {
     print('error is: $e');
   }
 }

 String constructFCMPayLoad(){
   print("44444");

   return jsonEncode({
     // if error try / befro to below
     'to':'/topics/admin_orders',

     'notification':{
       'title': "UDDT_JORDAN",
       'body': "new order _ check list"
     }
   });
 }
 Widget _drawLoadingScreen(){
   return Container(
     width: MediaQuery.of(context).size.width,
     height: MediaQuery.of(context).size.height,
     color: Colors.white24,
     child: Center(
       child: SizedBox(
           width: 50,
           height: 50,
           child: CircularProgressIndicator()),
     ),
   );
 }
dgmlos(){







}
}
