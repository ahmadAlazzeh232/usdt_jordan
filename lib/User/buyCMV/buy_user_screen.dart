 import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';
 import 'package:flutter/material.dart';
import 'package:ntp/ntp.dart';
import 'package:usdt_jordan/Authentication/sign_in_screen.dart';
import 'package:usdt_jordan/User/ChoiceUserScreen.dart';
import 'package:usdt_jordan/User/buyCMV/amount_controller.dart';
 import 'package:usdt_jordan/User/buyCMV/send_buy_order_controller.dart';
import 'package:usdt_jordan/Utilities/MyBackgroundsColors.dart';
import 'package:usdt_jordan/Utilities/generalStyle.dart';
 import 'package:connectivity_plus/connectivity_plus.dart';
 import 'package:http/http.dart' as http;

 class UserBuyScreen extends StatefulWidget {
    final  String email ;

  const UserBuyScreen({Key? key,required String this.email }) : super(key: key);
  @override
  _UserBuyScreenState createState() => _UserBuyScreenState();
}

class _UserBuyScreenState extends State<UserBuyScreen> {
  CollectionReference _collectionReferenceReferel = FirebaseFirestore.instance.collection("referel_code");
   CollectionReference _collectionReferenceHistory =FirebaseFirestore.instance.collection("user_history");
  int _isThereInternet = 0 ;
    int _passDis = 0 ;
  final  String _serverKey =  "AAAA1thofuU:APA91bFdDVzLxwNrJjY5w0JgaXl2CC9vNa0u0s3S9Pl49la473LaFNcVZ8wGU-YNE4edRHGF_l9tpCX8zVoYKVz-5HlJGyj6GeS6FvIWZ-hZeVSqhoqTBPRHEwUWmhokjRlnxk0AerNT";
   int _dinarTextState =1 ;
   int _theRestOfState2 = 0 ;
  int _discountState = 0;
  int _discountReferel = 0 ;
  int _numReferelCode = 0 ;
  bool _useCode = false ;
   bool _isThereOrder = false ;
   String result = "";

    String _firstPay = "الرجاء اختيار طريقة الدفع";
  String _zain= "محفظة زين كاش";
   String _orange= "محفظة اورنج";
   String _safwa= "بنك صفوة";
   User? _userState  ;
   String _name = "";
   String _number = "";
   String? _email = "";
   SendOrderController _orderController = SendOrderController();
  int UserState =0;
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  String _usdt = "";
  String _money = "";
  String _wallet ="";
  String _paymentMethod ="";
  TextEditingController _WalletadressController = TextEditingController();
   TextEditingController _usdtAmountController = TextEditingController();
      bool _loadState = false ;
  String _jordanian = "??";
  String _discount = "??";
  @override




  void dispose() {
    super.dispose();
    _usdtAmountController.dispose();
     _WalletadressController.dispose();
   }

     @override
  void initState() {
   super.initState();
  _getNumReferel();
   _getYesNoOrderState();


     }
     Future<void> _getNumReferel()async{
    try{
      await _collectionReferenceReferel.doc(widget.email).get().then((value){
        if(value.exists){
          _numReferelCode =value["#_done_order"];
          print("${widget.email}");
          print("num is _$_numReferelCode ");
        }

      });
    }
    catch(e){

    }

     }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyBackGrounsColors.appButtonsColor(),
      title:Text("USDT شراء "),
        centerTitle: true,
      ),
       body: (_loadState )?
              _drawLoadingScreen()
         :         Container(
         padding: EdgeInsets.only(right: 12, left: 12),
         color: MyBackGrounsColors.appBodyColor(),
         child: ListView(children: [
           SizedBox(height: MediaQuery
               .of(context)
               .size
               .height * .03),
           _drawFormWidget(),
         ]),
       )


    );
  }

  Widget _drawFormWidget() {
    return Form(
      key: _key,
      child: Column(
            children: [
            _drawNumbersForm(),
              SizedBox(height: 40),

              Container(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery
                      .of(context)
                      .size
                      .height * 0.09,
                  child: TextFormField(
                    style: TextStyle(color: Colors.white),

                    keyboardType:TextInputType.text ,


                    decoration: InputDecoration(labelText: "wallet address [TRC20]",
                        border: Generalstyle.textFieldBorder(),
                        filled: true,

                        counterStyle: TextStyle(
                            color: MyBackGrounsColors.appBodyColor()
                        ),
                        labelStyle: Generalstyle.hintTextStyle()),
                    textAlign: TextAlign.center,
                    controller: _WalletadressController,
                    validator: (value) {
                      if (value == null|| value.isEmpty) {
                        Fluttertoast.showToast(msg: "الرجاء ملء جميع الخانات",
                            gravity: ToastGravity.CENTER);
                        return "fill the field";
                      }
                      return null;
                    },
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height*.03,),
              SizedBox(
                height: MediaQuery
                    .of(context)
                    .size
                    .height * .015,
              ),
             InkWell(

                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.blue,

                          borderRadius: BorderRadius.all(Radius.circular(12)),
                         ),
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width*0.7,
                        height: 50,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Icon(Icons.arrow_drop_down_rounded, color: Colors.white,
                            size: 30,),
                            Text(_firstPay, style: TextStyle(fontSize: 16,color: Colors.white),),
                          ],
                        ),
                      ),
                      onTap: () {

                        showDialog(context: context, builder:(context){
                          return Dialog(
                            child: Container(width: MediaQuery.of(context).size.width*.055,
                              height: MediaQuery.of(context).size.height*0.65,
                              child: ListView(
                                children: [
                                  Container(

                                    height: MediaQuery.of(context).size.height*0.12,
                                    width: MediaQuery.of(context).size.width*.055,
                                  alignment: Alignment.center,
                                    child: Text("طريقة الدفع"),),


                                  _drawRowPopUp("assets/images/zainImage.png", _zain,),
                                  _drawRowPopUp("assets/images/orange.png", _orange),
                                  _drawRowPopUp("assets/images/safwa.png", _safwa),

                                ],
                              ),),
                          );
                        } );
                      }

                  ),
              SizedBox(
                height: 50,
              ),
              (_useCode )? _drawEnableCode() : _drawDisableCode(),


          SizedBox(
            height:70,
        ),

    Container(

        child: Row(

        mainAxisAlignment:MainAxisAlignment.spaceAround
        ,children: [
        SizedBox(height: 1,width: MediaQuery.of(context).size.width*.15,),
        Expanded(
        child: InkWell(

         onTap:() async{
          await Connectivity().checkConnectivity().then((value)async{
            if(value == ConnectivityResult.mobile || value ==ConnectivityResult.wifi)  {
             if(_isThereOrder){
               Fluttertoast.showToast(msg: "يوجد لديك طلب حاليا قيد المراجعة, الرجاء الانتظار",
                   gravity: ToastGravity.CENTER);
             }
             else{



                 _userState =  FirebaseAuth.instance.currentUser;
                 if(_userState != null ){
                   if(_paymentMethod =="" ||   _paymentMethod.isEmpty){
                     Fluttertoast.showToast(msg: "الرجاء اختيار طريقة الدفع", toastLength:Toast.LENGTH_LONG,
                         gravity: ToastGravity.CENTER);
                   }
                   else{

                     _email = _userState!.email;

                     if(_key.currentState!.validate()){
                       setState(() {
                         _loadState = true;
                       });
                       try{
                         var response = await http.get(
                           Uri.parse('https://www.google.com/'),
                         ).timeout(Duration(seconds: 15));
                         if(response.statusCode == 200){
                             try{
                               await NTP.now().then((valueTime)async{

                                 _isThereInternet = 1 ;
                                 await FirebaseFirestore.instance.collection("usersInfo").doc(_email).get().then((value){
                                   _number = value["number"];
                                   _name = value["full_name"];
                                   _usdt=_usdtAmountController.text.toString().trim();
                                   _wallet =_WalletadressController.text.toString().trim();
                                   print("$_number 555555");

                                 });

                                 await _orderController.sendOrder(
                                     _usdt, _jordanian,
                                     _wallet,
                                     _paymentMethod,
                                     _name,
                                     _email,
                                     _number,
                                     valueTime.toString(),_passDis.toString());
                                 await _orderController.updateNumReferel(_discountState, _theRestOfState2, widget.email);
                                 await _sendPushMessageOrder() ;
                                 await _orderController.sendHistoryUser(_name, _email!, _usdt,valueTime.toString()).then((value){

                                   setState(() {
                                     _loadState =false;
                                   });
                                 }

                                 );
                                 Navigator.pushAndRemoveUntil((context), MaterialPageRoute(builder: (context){
                                   return ChoiceUserScreen();
                                 }),(e){return false;});
                                 Fluttertoast.showToast(msg: "لقد تم إرسال طلبك \n سوف يتم التواصل معك بالسرعة القصوى",
                                     toastLength: Toast.LENGTH_LONG, gravity: ToastGravity.CENTER);
                               });
                             }
                             catch(e){
                               Fluttertoast.showToast(msg: "$e");

                              setState(() {
                                _loadState=false;
                              });
                             }

                         }
                         else{
                           setState(() {
                             _loadState =false ;
                             Fluttertoast.showToast(msg: "حدث خطأ ما الرجاء العودة لاحقا");
                           });
                         }
                       } catch(e){
                         setState(() {
                           _loadState = false;
                         });
                         print("error 7777 is : $e");
                         Fluttertoast.showToast(msg:" أنت غير متصل, الرجاء التأكد من توفر حزم الانترنت", gravity: ToastGravity.CENTER);
                       }





                     }
                   }
                 }


                 else{ Fluttertoast.showToast(msg: "you should sign in to use app",
                     toastLength:Toast.LENGTH_LONG,gravity: ToastGravity.CENTER );
                 Navigator.push((context),MaterialPageRoute(builder: (context){
                   return SignInScreen();
                 }) );
                 ;}

             }


             }
            else{
              Fluttertoast.showToast(msg: "أنت غير متصل على شبكة الإنترنت \n الرجاء الإتصال و إعادة المحاولة",
                  gravity: ToastGravity.CENTER);
            }
          });





        } ,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(12)),
            color: Colors.blue,

          ),
          alignment: Alignment.center,
          height: 40,
          child: Text("buy usdt ",style: TextStyle(
            color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold
          )),
        )),
        ),

        SizedBox(height: 1,width: MediaQuery.of(context).size.width*.15,),
        ]),

    )
    ],
    )
    ,
    )
    ;
  }

  Widget _drawNumbersForm() {
    return Container(
      alignment: Alignment.centerLeft,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery
            .of(context)
            .size
            .height * 0.22,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: MediaQuery.of(context).size.width*0.65,
              height: MediaQuery
            .of(context)
            .size
            .height * 0.09 ,

              child: TextFormField(

                style: TextStyle(color: Colors.white),
                onChanged: (text){
                  print("$text 555555");
                  if( text!= null && text.toString() !=""
                      &&text.toString().length>0 && double.parse(text)>4 && !text.isEmpty &&
                        double.parse(text.toString()) <1001){
                          setState(() {
                            _dinarTextState = 1 ;
                          });
                        result = AmountController.amountUsdtToJordan(text.toString(), _passDis);
                      if(double.parse(text)>4 && double.parse(text)<215){
                        _discount = " ثلاثة دينار";
                      } else if(double.parse(text) >=215 && double.parse(text) <500){
                        _discount ="2 %";
                      }
                      else if(double.parse(text)>=500 && double.parse(text)<750){
                        _discount ="1.75 %";

                      }
                      else if(double.parse(text)>=750 && double.parse(text)<1000){
                        _discount ="1.5 %";

                      }
                      else if(text.isEmpty){
                        _discount= "??";
                      }
                    setState(() {
                       _jordanian=result;
                       _discount ;
                    });
                  } else if(text!= null && text.toString().length!=0 && double.parse(text)<4){

                    setState(() {
                       _dinarTextState = 0 ;
                      _jordanian = "  الحد الأدنى 5 "; _discount="??";
                    });
                  }
                  else if(text.isEmpty || text.length == 0){
                    setState(() {
                      _discount="??";
                      _jordanian = "??";
                    });
                  }
                  else if(double.parse(text.toString()) >1000 && !text.isEmpty &&
                      text.length != 0){
                    setState(() {
                      _jordanian = "السقف الأعلى 1000";
                      _dinarTextState= 0 ;
                    });
                  }
                },
                textAlign: TextAlign.center,
                 keyboardType:TextInputType.number ,


                decoration:InputDecoration(
                    counterStyle: TextStyle(
                        color: MyBackGrounsColors.appBodyColor()
                    ),
                    border: Generalstyle.textFieldBorder(),
                  filled: true,

                  focusColor: Colors.white ,
                labelText: "usdt",labelStyle: Generalstyle.hintTextStyle()) ,
                maxLength: 4,

                controller: _usdtAmountController,
                validator: (value) {

                  if (value == null||  value.isEmpty  ) {
                    Fluttertoast.showToast(msg: "الرجاء ملء جميع الخانات",
                        gravity: ToastGravity.CENTER);
                    return " !! الحقل فارغ ";
                  }else if( double.parse(value)<5){
                    Fluttertoast.showToast(msg: "القيمة المدخلة أقل من 5 \n USDT",
                        gravity: ToastGravity.CENTER);
                    return  "5 USDT  أقل قيمة ";
                  }else if(double.parse(value)>1000){

                    Fluttertoast.showToast(msg:"usdt السقف الأعلى 1000 ",
                        gravity: ToastGravity.CENTER);
                    return " السقف 1000";
                  }
                  return null;
                },
              ),

            ),
             SizedBox(height:5 ,),
             Container(
              width: MediaQuery
                  .of(context)
                  .size
                  .width * .65,
              height: MediaQuery
                  .of(context)
                  .size
                  .height * 0.09,


                  decoration: BoxDecoration(
                    border: Border.all(width: 2, color: MyBackGrounsColors.ButtonBodySecondary()),
                    shape: BoxShape.rectangle,
                  ),
                   child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(_jordanian, style: TextStyle(color: Colors.white, fontSize: 18),
                        textAlign:TextAlign.center,),

                      Text(  (_dinarTextState == 1)?"دينار أردني": "USDT"
                        , style: TextStyle(color: Colors.white, fontSize: 18),
                        textAlign:TextAlign.center,),
                    ],
                  ),


                   ),



          ],
        ),

    );
  }


 Widget _drawRowPopUp(String image, String methodNAme){
    return Container(
      padding: EdgeInsets.only(right: 12,left: 12),
        width: MediaQuery.of(context).size.width*.5,
        height: MediaQuery.of(context).size.height*.17,
        child: Column(
          children:[
            SizedBox(height: 6,),
            Container(color: Colors.red,height: 2,),
            SizedBox(height: 6,),
            Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [

              CircleAvatar(backgroundImage: ExactAssetImage(image),radius: 30,
              backgroundColor: Colors.transparent,),

              ElevatedButton(onPressed: (){
                setState(() {
                  _firstPay= methodNAme;
                  _paymentMethod = methodNAme;
                  print("$_paymentMethod 55555");
                  Navigator.of(context,).pop();
                });
              }, child: Text(methodNAme))
            ],
          ),]
        ));
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


  Widget _drawEnableCode(){
    return       Container(

      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height*0.1,
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
           Container(
             width: 200,
            height:70,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                border: Border.all(color:Colors.grey, width: 1)
            ),
            child: Text("لقد تم تفعيل كود  الخصم", style: TextStyle(color: Colors.white),
             ),
          ),
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.green,
              borderRadius: BorderRadius.circular(20)
            ),
            width:65,
            height: 35,
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                 Container(
                  width: 20,
                  height: 20,
                  alignment: Alignment.center,
                  child: Text("on", style: TextStyle(color: Colors.white),),
                ),InkWell(
                  child: Container(

                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle
                    ),
                  ),
                  onTap: (){
                    setState(() {
                      _discountState = 0;
                      _passDis = 0 ;
                      _useCode = false ;
                      _usdtAmountController.clear();
                      result ;
                      _jordanian="??";


                    });
                  },
                ),
              ],
            ),
          ),
          SizedBox(width: 1,),
          SizedBox(width: 1,),
          SizedBox(width: 1,),

        ],
      ),

    );

  }
  Widget _drawDisableCode(){
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height*0.1,
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [

          Container(
            width: 150,
            height: 70,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                border: Border.all(color:Colors.grey, width: 1)
            ),
            child: Text(" تفعيل كود الخصم", style:  TextStyle(color: Colors.white,fontSize: 14)
              ,textAlign: TextAlign.center,),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.red,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(20)
            ),

            width: 65,
            height: 35,
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
               children: [
                InkWell(
                  child: Container(
                     decoration: BoxDecoration(
                      color: Colors.white,
                         shape: BoxShape.circle
                    ),
                    width: 20,
                    height: 20,
                    alignment: Alignment.center,
                  ),
                  onTap: (){
                    setState(() {
                      if(_numReferelCode > 4){
                        if(_numReferelCode == 5){
                          //ToDo
                          // set the num od _numReferalCode == 0
                          // give user 25 % discount
                        setState(() {
                          _discountReferel = 25;
                          _discountState = 1;
                          _passDis= 1;
                          _usdtAmountController.clear();
                          result ;
                          _jordanian="??";

                        });

                        }
                          else if(_numReferelCode >5 && _numReferelCode <10){
                          //ToDo
                         // subtract the num of _numRefereralCode from 5
                          // set the result as update
                          // give the user 25% dis
                          setState(() {

                            _discountReferel = 25;
                            _discountState = 2;
                            _theRestOfState2 = _numReferelCode - 5 ;
                            _passDis = 1;
                            _usdtAmountController.clear();
                            result ;
                            _jordanian="??";

                          });
                        }
                          else{
                            //ToDo
                          // give user 50 % dis
                          // set the number ==0 as update
                         setState(() {
                           _discountReferel = 50;
                           _discountState = 3;
                           _passDis = 2;
                            _usdtAmountController.clear();
                           result ;
                           _jordanian="??";
                         });
                        }

                        _useCode = true;

                      }
                      else{
                        _discountState = 0 ;
                        Fluttertoast.showToast(msg: "متبقي عليك   ${5 - _numReferelCode} أشخاص \n الرجاء قراءة سياسة الخصومات في الإعدادات",
                        gravity: ToastGravity.CENTER);
                      }
                    });
                  },
                ),
                Container(
                  width:20,
                  height: 20,
                  alignment: Alignment.center,
                  child: Text("off", style: TextStyle(color: Colors.white,fontSize: 12),),
                )
              ],
            ),
          ),
          SizedBox(width: 1,),
          SizedBox(width: 1,),
          SizedBox(width: 1,),

        ],
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
  Future<void> _getYesNoOrderState()async{
  try{
    await _collectionReferenceHistory.doc(widget.email).
    collection("history_user").get().then((value){
      if(!value.docs.isEmpty){

        value.docs.forEach((element) {
          if(element["order_state"] == 1 ){
            _isThereOrder= true;
            print("77777 yes");

          }else{
            print("77777 yes");

          }
        });
      }
    });
  }
  catch(e){

  }


  }
  }



