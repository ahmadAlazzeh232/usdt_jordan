
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
 import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
  import 'package:usdt_jordan/User/ChoiceUserScreen.dart';
import 'package:usdt_jordan/User/chat_user/chat_user_controller.dart';
import 'package:usdt_jordan/Utilities/AppText.dart';
import 'package:usdt_jordan/Utilities/MyBackgroundsColors.dart';
 import 'package:usdt_jordan/Utilities/generalStyle.dart';
import 'package:usdt_jordan/referal_code/genarateReferalCode.dart';
 import 'AuthController.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  int _isThereInternet =0;
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
   bool _isFriendInvite = false;
   String _writeReferal ='non';
   String _email = "";
   String _password = "";
   String _name = "";
   String _number = "";
   String _name1 = "";
   String _name2 = "";
   int _isLoading = 0 ;
   late  String? nameToCheckState ;
   TextEditingController _emailController = TextEditingController();
  TextEditingController _passController = TextEditingController();
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _numberController = TextEditingController();
  TextEditingController _rePassController = TextEditingController();
  TextEditingController _photoController = TextEditingController();
  TextEditingController _writeCodeController =TextEditingController();
   AuthintecationController _authContrlooer = AuthintecationController();
  UserChatController _chatWelcome = UserChatController();
  CollectionReference _collectionReferenceReferel = FirebaseFirestore.instance.collection("referel_code");
    final _firstNameKey= new GlobalKey();
  final _secondNameKey= new GlobalKey();
  final _numberKey= new GlobalKey();
  final _emailKey= new GlobalKey();
  final _passKey= new GlobalKey();
  final _rePassKey= new GlobalKey();
  final _CheckCodeKey= new GlobalKey();




  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _numberController.dispose();
    _rePassController.dispose();
    _photoController.dispose();
    _writeCodeController.dispose();


  }




  @override
  Widget build(BuildContext context) {


      return Scaffold(

      body:
      (_isLoading == 1)? _drawLoadingScreen() :
      Container(
           color: MyBackGrounsColors.appBodyColor(),
        child: ListView(
          padding: EdgeInsets.only(right: 8, left:8 ),
           scrollDirection: Axis.vertical,
            children: [
                SizedBox(
                  height: 25,
                ),
              _logoBox(),
              //_titleLogo(),
              SizedBox(
                height: 30 ,
              ),
              _formBox(),

            ],

        ),
      ),
    );
  }

  Widget _logoBox() {
    return Container(
       height: 130,
      width: MediaQuery.of(context).size.width,

            child: Align(
              alignment: Alignment.center,
              child: SizedBox(
              child: Image(
                height: 125,
                width: MediaQuery.of(context).size.width*0.41,

                image: ExactAssetImage("assets/images/down_logo.png"),
                fit: BoxFit.cover,
              ),
        ),
            ),


    );
  }


  _formBox() {
    return Form(
      key: _key,

      child:
      Container(
          child:Column(
          children: [
            SizedBox(
              height: MediaQuery
                  .of(context)
                  .size
                  .height * .02,

            ),

            TextFormField(
              style: TextStyle(
                color: Colors.white
              ),
                textAlign: TextAlign.center,
                keyboardType: TextInputType.name,
                maxLength: 12,
                maxLines: 1,
                decoration: InputDecoration(
                  counterStyle: TextStyle(
                    color: Colors.white
                  ),
                  icon: Icon(Icons.person, color:Colors.white,size: 35,),
                    border: Generalstyle.textFieldBorder(),
                    labelText: "        FIRST NAME",
                     filled: true,

                    labelStyle: Generalstyle.formTextStyle()),
                controller: _firstNameController,
                validator: (value) {
                  if (value
                      .toString()
                      .length < 3) {
                    Fluttertoast.showToast(msg:nameSecondError, gravity: ToastGravity.CENTER );
                     return nameSecondError;
                  }
                  return null;
                },
              ),
             SizedBox(

              height: 5,

            ),
            TextFormField(
              style: TextStyle(
                color: Colors.white
              ),
                keyboardType: TextInputType.name,

                maxLength: 12,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  counterStyle: TextStyle(
                      color: Colors.white
                  ),
                    icon: Icon(Icons.person, color:Colors.white,size: 35,),

                     border: Generalstyle.textFieldBorder(),
                    filled: true,
                    labelText: "        LAST NAME",
                    labelStyle: Generalstyle.formTextStyle()),
                controller: _lastNameController,
                validator: (value) {
                  if (value
                      .toString()
                      .length < 3) {
                    Fluttertoast.showToast(msg:nameFirstError, gravity: ToastGravity.CENTER );

                    return nameFirstError;
                  }
                  return null;
                },
             ),
        SizedBox(
          height: 5,
        ),
            TextFormField(
              style: TextStyle(
                  color: Colors.white
              ),
                keyboardType: TextInputType.emailAddress,
                maxLength: 40,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  counterStyle: TextStyle(
                      color: Colors.white
                  ),
                    icon: Icon(Icons.email_outlined, color:Colors.white,size: 35,),

                    border: Generalstyle.textFieldBorder(),
                    fillColor: Colors.white,
                     labelText: "        EMAIL",
                    labelStyle: Generalstyle.formTextStyle()),
                controller: _emailController,
                validator: (value) {
                  if (value
                      .toString()
                      .length < 15) {
                    Fluttertoast.showToast(msg:emailerror , gravity: ToastGravity.CENTER);

                    return emailerror;
                  }
                  return null;
                },
             ),
            SizedBox(
              height: 5,
            ),
            TextFormField(
              style: TextStyle(
                  color: Colors.white
              ),
                keyboardType: TextInputType.number,

                maxLength: 10,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                      counterStyle: TextStyle(
                          color: Colors.white
                      ),
                    icon: Icon(Icons.phone, color:Colors.white,size: 35,),

                     border: Generalstyle.textFieldBorder(),
                    filled: true,
                    labelText: "        NUMBER",
                    labelStyle: Generalstyle.formTextStyle()),
                controller: _numberController,
                validator: (value) {
                  if (value
                      .toString()
                      .length != 10) {
                    Fluttertoast.showToast(msg:numberPhoneError, gravity: ToastGravity.CENTER );

                    return numberPhoneError;
                  }
                  return null;
                },
             ),
            SizedBox(
              height: 5,
            ),
           TextFormField(
             style: TextStyle(
                 color: Colors.white
             ),
                maxLength: 10,
                keyboardType: TextInputType.visiblePassword,

                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  counterStyle: TextStyle(
                      color: Colors.white
                  ),
                    icon: Icon(Icons.password_sharp, color:Colors.white,size: 35,),

                    border: Generalstyle.textFieldBorder(),
                     filled: true,
                    labelText: "        PASSWORD",
                    labelStyle: Generalstyle.formTextStyle()),
                controller: _passController,
                validator: (value) {
                  if (value
                      .toString()
                      .length < 8) {
                    Fluttertoast.showToast(msg:"fill pass", gravity: ToastGravity.CENTER );

                    return "fill pass";
                  }
                  return null;
                },
             ),
            SizedBox(
              height: 5,
            ),
            TextFormField(
             style: TextStyle(
                 color: Colors.white
             ),
                maxLength: 10,
                keyboardType: TextInputType.visiblePassword,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  counterStyle: TextStyle(
                      color: Colors.white
                  ),
                    icon: Icon(Icons.password_sharp, color:Colors.white,size: 35,),

                     border: Generalstyle.textFieldBorder(),
                    filled: true,
                    labelText: "        CONFIRM PASSWORD",
                    labelStyle: Generalstyle.formTextStyle()),
                controller: _rePassController,
                validator: (value) {
                  if (value
                      .toString()
                       != _passController.text.toString()) {
                    Fluttertoast.showToast(msg:"الأرقام السرية غير متطابقة" , gravity: ToastGravity.CENTER );

                    return  "الأرقام السرية غير متطابقة";
                  }

                  else {
                    return null;
                  }
                },
             ),
            SizedBox(
              height: 5,
            ),


            Container(
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height*0.08,
              child: (_isFriendInvite) ?_secondeCodeScreen(): _firstCodeScreen(),
               ),
            SizedBox(
              height: 10,
            ),
            Container(
              height: 50,
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.center,
              child: Text("بإنشاء الحساب فأنت توافق على شروط الاستخدام",style: TextStyle(
                color: Colors.white, fontSize: 16
              ),),
            ),
            Container(
                width: MediaQuery
                    .of(context)
                    .size
                    .width,
                height: 70,
                child: Row(children: [
                  SizedBox(
                    width: MediaQuery
                        .of(context)
                        .size
                        .width * .15,
                    height: MediaQuery
                        .of(context)
                        .size
                        .height * 0.10,
                  ),
                  Expanded(
                    child: Container(
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () async {
                           ConnectivityResult _connectiveResult = await Connectivity().checkConnectivity();
                           if(_connectiveResult == ConnectivityResult.mobile
                           || _connectiveResult== ConnectivityResult.wifi){
                             if (_key.currentState!.validate()) {
                               if(_passController.text.toString().trim()
                                   != _rePassController.text.toString().trim()){
                                 Fluttertoast.showToast(msg:"الأرقام السرية غير متطابقة ", gravity: ToastGravity.CENTER);
                               }
                               else{
                                 setState(() {
                                   _isLoading = 1 ;
                                 });
                                 try {

                                   var response = await http.get(
                                     Uri.parse('https://www.google.com/'),
                                   ).timeout(Duration(seconds: 15));
                                   print("1111111 ${response.statusCode}");
                                   if(response.statusCode == 200){
                                      try{
                                        if(_isFriendInvite){

                                            _name1 = _firstNameController.text.toString().trim();
                                             _name1 = _name1[0].toUpperCase() + _name1.substring(1);
                                             Fluttertoast.showToast(msg: _name1);
                                            String _referl = GenerateReferalCode.getNesReferalCode(_name1);
                                            _email = _emailController.text.toString().trim();
                                            _password = _passController.text.toString().trim();
                                            _number = _numberController.text.toString().trim();
                                            _name2 = _lastNameController.text.toString().trim();
                                            _name2  = _name2[0].toUpperCase() + _name2.substring(1);

                                            _name = _name1 + _name2;
                                            print("$_email 555545");


                                            await _collectionReferenceReferel.where("referel",isEqualTo: _writeCodeController.text.toString().trim())
                                                .get().then((value)async{
                                               if(value.docs.length ==0 ){
                                                setState(() {
                                                  _isLoading=0;
                                                });
                                                Fluttertoast.showToast(msg: "كود الدعوة اللي ادخلته غير موجود",
                                                    toastLength: Toast.LENGTH_SHORT,
                                                    gravity: ToastGravity.CENTER);
                                              }else{
                                                String _emailPromot =value.docs.first.id;
                                                await _authContrlooer.register(_email, _password);

                                                await _authContrlooer.UpdateSignUpNumber(_emailPromot);

                                                await  _authContrlooer.saveDataOnSignUp(
                                                    _name1,_name2, _password, _email, _number, _referl, _emailPromot);
                                                await _authContrlooer.saveReferal(_referl, _email);
                                                  String _uid = FirebaseAuth.instance.currentUser!.uid;
                                                  Fluttertoast.showToast(msg: _uid);
                                                await _chatWelcome.SendUserMessage(
                                                    _email,_uid , "مرحبا بك, كيف يمكننا مساعدتك ؟",_name);
                                                await _chatWelcome.SetUpdateMessage("مرحبا بك, كيف يمكننا مساعدتك ؟",
                                                  _name, _email, );
                                                setState(() {
                                                  _isLoading = 0 ;
                                                });
                                                await Navigator.pushAndRemoveUntil(context,
                                                    MaterialPageRoute(builder: (context) {
                                                      return ChoiceUserScreen();
                                                    }),(e) => false);
                                              }

                                            });





                                        }
                                        else{
                                             _name1 = _firstNameController.text.toString().trim();
                                             _name1 = _name1[0].toUpperCase() + _name1.substring(1);

                                            String _referl = GenerateReferalCode.getNesReferalCode(_name1);
                                            _email = _emailController.text.toString().trim();
                                            _password = _passController.text.toString().trim();
                                            _number = _numberController.text.toString().trim();
                                            _name2 = _lastNameController.text.toString().trim();
                                            _name2  = _name2[0].toUpperCase() + _name2.substring(1);
                                            _name = _name1 + _name2;
                                            print("$_email 555545");



                                            await _authContrlooer.register(_email, _password).then((value){
                                              _isThereInternet=1;
                                            });


                                            await  _authContrlooer.saveDataOnSignUp(
                                                _name1,_name2, _password, _email, _number, _referl, "non");
                                            await _authContrlooer.saveReferal(_referl, _email);
                                            await _chatWelcome.SendUserMessage(
                                                _email, _email, "مرحبا بك, كيف يمكننا مساعدتك ؟",_name);
                                            await _chatWelcome.SetUpdateMessage("مرحبا بك, كيف يمكننا مساعدتك ؟",
                                              _name, _email, );
                                            setState(() {
                                              _isLoading = 0 ;
                                            });
                                            Fluttertoast.showToast(msg: "لقد تم إنشاء حسابك بنجاح \n مرحبا بك ${_firstNameController.text.toString()}");
                                            await Navigator.pushAndRemoveUntil(context,
                                                MaterialPageRoute(builder: (context) {
                                                  return ChoiceUserScreen();
                                                }),(e) => false);

                                        }
                                      }
                                      catch(e){
                                        setState(() {
                                          _isLoading = 0 ;
                                        });
                                        Fluttertoast.showToast(msg: "$e");
                                      }



                                   }
                                   else{
                                     setState(() {
                                       _isLoading = 0 ;
                                     });
                                     Fluttertoast.showToast(msg: "حدث خطأ ما, الرجاء العودة لاحقا");

                                   }
                                 }
                                 catch (e) {
                                   setState(() {
                                     _isLoading = 0 ;
                                   });
                                   Fluttertoast.showToast(msg: "أنت غير متصل, الرجاء التأكد من توفر حزم الانترنت");

                                   print('error is: $e');
                                 }


                               }




                             }


                           }
                           else{
                             Fluttertoast.showToast(msg: "أنت غير متصل, الرجاء الاتصال بشبكة الانترنت");
                           }
                        },
                        child: Text(
                          "Sign Up ",
                          style: Generalstyle.buttonTextStyle(),
                        ),
                        style: Generalstyle.appButtonStyle(),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery
                        .of(context)
                        .size
                        .width * .15,
                    height: MediaQuery
                        .of(context)
                        .size
                        .height * 0.10,)
                ])),
            SizedBox(
              height: 5,
            )
          ],
       )
    ));
  }
 Widget _firstCodeScreen(){
    return Container(
      width: MediaQuery.of(context).size.width*0.8,
      height: MediaQuery.of(context).size.height*0.07,
      child: Row(
        children: [
          Container(
            width: MediaQuery.of(context).size.width*0.2,
            height: MediaQuery.of(context).size.height*0.14,
            child:
                Container(
                  alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width*0.2,
                    height: MediaQuery.of(context).size.height*0.7,
                  child: InkWell(
                    child: Container(
                      alignment: Alignment.center,
                      child: Text("نعم", style: TextStyle(fontSize: 16,
                          color: Colors.white,fontWeight: FontWeight.bold),),
                      width: MediaQuery.of(context).size.width*0.19,
                      height: MediaQuery.of(context).size.height*0.07,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.blue, width: 1),
                        shape: BoxShape.rectangle
                      ),
                    ),
                    onTap: (){
                      setState(() {
                        _isFriendInvite = true;
                      });
                    },
                  ),
                ),

          ),
          Container(
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width*0.58,
            height: MediaQuery.of(context).size.height*0.07,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.blue, width: 1)
            ),
            child: Text("هل قام أحد أصدقائك بدعوتك ؟",style: TextStyle(
                color: Colors.white
            ),),
          )],
      ),

    );
 }
 Widget _secondeCodeScreen(){
    return Container(
      width: MediaQuery.of(context).size.width*0.8,
      height: MediaQuery.of(context).size.height*0.07,
      child: Row(
        children: [
          Container(
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width*0.2,
            height: MediaQuery.of(context).size.height*0.14,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.blue, width: 1),
              shape: BoxShape.rectangle,
            ),
            child: InkWell(
              child: Icon(Icons.backspace_outlined, color: Colors.red, size: 30,),
              onTap: (){
                setState(() {
                  _writeCodeController.clear();
                  _isFriendInvite = false;
                });
              },
            ),
          ),
          Container(
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width*0.58,
            height: MediaQuery.of(context).size.height*0.14,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.blue, width: 1),
                shape: BoxShape.rectangle
            ),
            child: TextFormField(
               textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white
              ),

                            decoration: InputDecoration(
                labelText: "     رمز الدعوة ",
                labelStyle: TextStyle(color: Colors.white, fontSize: 18)
              ),
              controller: _writeCodeController,
              validator: (value){
                if(value == null || value.isEmpty || value.toString().trim().length<7){
                 Fluttertoast.showToast(msg: "الرمز المدخل قصير",
                     gravity: ToastGravity.CENTER);
                 return "الرمز المدخل قصير";
                } return null;
              },
            )
          )
        ],
      ),
    );
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
sscdvs(){









  }
}
