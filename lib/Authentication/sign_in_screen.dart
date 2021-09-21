import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:usdt_jordan/Admin/MainPageViewAdmin.dart';
import 'package:usdt_jordan/Authentication/sign_up_inside.dart';
import 'package:usdt_jordan/Authentication/sign_up_screen.dart';
import 'package:usdt_jordan/User/ChoiceUserScreen.dart';
import 'package:usdt_jordan/User/buyCMV/buy_user_screen.dart';
import 'package:usdt_jordan/User/userDrawer/Drawer.dart';
import 'package:usdt_jordan/Utilities/MyBackgroundsColors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:usdt_jordan/Authentication/AuthController.dart';
import 'package:usdt_jordan/Utilities/generalStyle.dart';
class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool _loadOut = false ;
  int _isLoading =0;
  int _isThereInternet =1 ;
  User? _user ;
  int _AuthState = 0 ;
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passController = TextEditingController();
  AuthintecationController _authController = AuthintecationController();
  String _currentEmail= "";
  String email = "";
  String password = "" ;
  @override
  void initState() {
    super.initState();
     _user = FirebaseAuth.instance.currentUser;
     if(_user != null){
       setState(() {
         _currentEmail = _user!.email!;
       });

     }

  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        backgroundColor: MyBackGrounsColors.appButtonsColor(),
        ),
       body: (_user == null)? (
       (_isLoading == 1 )? _drawLoadingScreen() :
       _drasCurrentUserScreen() ):
        _drawExistingUser(_currentEmail)



    );
  }

  Widget  _logoBox() {
    return Container(

       width: MediaQuery.of(context).size.width,
      height: 130,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: ExactAssetImage(""),fit: BoxFit.cover
        )
      ),
      child: Align(
        alignment: Alignment.center,
        child: SizedBox(

          child: Image(
            width: MediaQuery.of(context).size.width*0.41,
            height: 125,
            image:  ExactAssetImage("assets/images/down_logo.png"),
              fit: BoxFit.cover,
            ),
        ),
      ),

    );
  }

  Widget _formBox() {
    return Column(
      children: [
        Form(
            key: _key,
            child: Column(
               children: [
                Container(
                  width: MediaQuery.of(context).size.width*0.9,
                  height: 100,
                  child: TextFormField(
                    style: TextStyle(color: Colors.white),
                     textAlign: TextAlign.center,
                    decoration: InputDecoration(
                       border: Generalstyle.textFieldBorder(),
                        labelText: "        Email",
                        fillColor: Colors.white,
                        labelStyle: Generalstyle.hintTextStyle() ),
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value.toString().length < 15) {
                      Fluttertoast.showToast(msg: "please fill all email",
                          gravity: ToastGravity.CENTER);
                        return "please fill all email";
                      }
                      return null;
                    },
                  ),
                ),

                Container(
               width: MediaQuery.of(context).size.width*0.9,
                  height: 100,
                  child: TextFormField(
                    style: TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                         labelText: "        password",
                         border: Generalstyle.textFieldBorder(),

                        labelStyle: Generalstyle.hintTextStyle()),
                    controller: _passController,
                    keyboardType: TextInputType.visiblePassword,
                    validator: (value) {
                      if (value.toString().length < 8) {
                        Fluttertoast.showToast(msg: "please fill the pass with 8 digits",
                            gravity: ToastGravity.CENTER);
                        return "please fill the pass with 8 digits";
                      }
                      return null;
                    },
                  ),
                ),
              const  SizedBox(
                  height: 15,
                ),


                        // sign in
                        Container(
                          width: MediaQuery.of(context).size.width*0.7,
                          height: 60,
                          child: ElevatedButton(

                            onPressed:(_AuthState == 1)?(){Fluttertoast.
                            showToast(msg: "you are already sign in",
                                gravity: ToastGravity.CENTER,
                                toastLength: Toast.LENGTH_LONG); }
                                :()async{
                               ConnectivityResult _connectivityResult =await Connectivity().checkConnectivity();
                               if(_connectivityResult == ConnectivityResult.wifi ||
                                   _connectivityResult == ConnectivityResult.mobile){
                                 if (_key.currentState!.validate()) {
                                   setState(() {
                                     _isLoading = 1;
                                   });
                                   try {
                                     var response = await http.get(
                                       Uri.parse('https://www.google.com/'),
                                     ).timeout(Duration(seconds: 15));
                                      if(response.statusCode == 200){

                                        try {



                                          email = _emailController.text.toString();
                                          password = _passController.text.toString();
                                          setState(() {
                                            _isLoading = 1 ;
                                          });
                                          await _authController.signIn(email, password).then((value) {
                                            _isThereInternet=1;
                                          });
                                          setState(() {
                                            _isLoading = 0 ;
                                          });
                                          if(_emailController.text.toString().trim() == "ahmadihssan1324@gmail.com"){
                                            await Navigator.pushAndRemoveUntil((context),
                                                MaterialPageRoute(builder: (context){
                                                  return AdmPageView() ;
                                                }),(e) => false);
                                          }else{
                                            await Navigator.pushAndRemoveUntil((context),
                                                MaterialPageRoute(builder: (context){
                                                  return ChoiceUserScreen() ;
                                                }),(e) => false);
                                            Fluttertoast.showToast(msg: "تم تسجيل الدخول بنجاح");
                                          }



                                          _passController.clear();
                                          _emailController.clear();



                                        } catch (e) {

                                          _passController.clear();
                                          _emailController.clear();
                                          Fluttertoast.showToast(msg: "$e");
                                          setState(() {
                                            _isLoading = 0 ;
                                          });
                                          print('error is: $e');
                                        }

                                     }
                                     else{
                                        _passController.clear();
                                        _emailController.clear();
                                       setState(() {
                                         _isLoading=0;
                                       });
                                    Fluttertoast.showToast(msg: "حدث خطأ ما, الرجاء العودة لاحقا");

                                     }
                                   }
                                   catch (e) {
                                     _passController.clear();
                                     _emailController.clear();
                                     Fluttertoast.showToast(msg: "أنت غير متصل على الانترنت, \n الرجاء التأكد من توفر حزم الانترنت");
                                     setState(() {
                                       _isLoading = 0 ;
                                     });
                                     print('error is: $e');
                                     print('error is: $e');
                                   }
                                 }

                               }
                               else{
                                 Fluttertoast.showToast(msg: "أنت غير متصل, الرجاء الاتصال ب شبكة الانترنت");
                               }


                            }  ,
                            child:(_AuthState==1)?
                            Text("you are already sign in",style: Generalstyle.buttonTextStyle(),)
                                :Text("Sign in ",style: Generalstyle.buttonTextStyle(),),
                            style: Generalstyle.appButtonStyle()),
                        ),
                       // sign up




              ],
            ))
      ],
    );
  }

  _signUpForgett() {
    return Container(
      alignment: Alignment.center,
      height: 50,
      width: MediaQuery.of(context).size.width*0.7,
        child: Row(
           children: [
             Container(

               alignment:Alignment.centerLeft,
               height: 50,
               width: MediaQuery.of(context).size.width*0.4,
               child: InkWell(
                  onTap: () {
                    showDialog(context: context, builder: (context){
                      return Dialog(
                        child: Container(
                          width: MediaQuery.of(context).size.width*0.7,
                          height: MediaQuery.of(context).size.height*0.9,
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(width: 1,),
                                    Container(
                                      margin: EdgeInsets.only(right: 20, top: 20),
                                      child: InkWell(
                                        child: Icon(Icons.backspace_outlined, color: Colors.red,
                                        size: 30,),
                                        onTap: (){
                                          Navigator.pop(context);
                                        },
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    });
                  },
                   child:   Text(
                    "Forget Password ?",
                     style: TextStyle(
                       decoration: TextDecoration.underline,
                       color: Colors.white, fontSize: 14,
                     ),                  )),
            ),
            Container(
               alignment: Alignment.centerRight,
              height:50,
              width: MediaQuery.of(context).size.width*0.30,
              child: InkWell(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (contex) {
                      return SignUpInside();
                    }));
                  },
                   child: Text(
                    "SIGN UP",
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                        color: Colors.white, fontSize: 14,
                    ),
                  )),
            ),


          ],
        ),

    );
  }
  Widget _drasCurrentUserScreen(){
    return  Container(
      alignment: Alignment.center,
      color: MyBackGrounsColors.appBodyColor(),
      child: ListView(

        padding: EdgeInsets.only(right: 8,left: 8),
        children: [
          SizedBox(height: 40,),

          _logoBox(),
          SizedBox(height: 65,),
          _formBox(),
          SizedBox(
            height: 25,
          ),
          Container(
           alignment: Alignment.center,
            height: 52,
            width: MediaQuery.of(context).size.width,
            child:          _signUpForgett(),
          ),
        ],
      ),
    );
  }

 Widget _drawExistingUser(String currentEmail) {
    return Container(
       width: MediaQuery.of(context).size.width,
      color: MyBackGrounsColors.appBodyColor(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(height: 40,),
          SizedBox(height: 1,),

          Container(
               width: MediaQuery.of(context).size.width,
               alignment: Alignment.center,
               height: 190,
               child: Column(
                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                 children: [
                   Container(

                     width: MediaQuery.of(context).size.width,

                     alignment: Alignment.center,
                     height: 75,
                      child: Text("عزيزي العميل, أنت مسجل   \n بإستخدام البريد أدناه",
                       style: TextStyle(fontSize: 18, color: Colors.white,
                           fontWeight: FontWeight.w400),textAlign: TextAlign.right,),
                   ),

                   Container(
                       width: MediaQuery.of(context).size.width,
                       alignment: Alignment.center,
                       height: 60,
                       margin: EdgeInsets.all(10),
                       padding: EdgeInsets.all(8),
                       decoration: BoxDecoration(
                           border: Border.all(color: Colors.white,width: 1),
                           color: MyBackGrounsColors.appButtonsColor(),
                           borderRadius: BorderRadius.circular(30)                       ),
                       child: Text(currentEmail, style: Generalstyle.bodyTextStyleNormal(),)),
                 ],
               ),
             ),





          ElevatedButton(onPressed: ()async{
             showDialog(context: context, builder:(context){
               return AlertDialog(
                 title: Text("تسجيل الخروج"),
                 actions: [
                   Row(
                     mainAxisAlignment: MainAxisAlignment.spaceAround,
                     children: [
                       InkWell(
                         child: Container(
                             alignment: Alignment.center,
                             width: 55,
                             height: 40,
                             color: Colors.green,
                             child: Text("yes", style: TextStyle(color: Colors.white,
                                 fontSize: 14, fontWeight: FontWeight.bold),)),
                         onTap:() async {
                          setState(() {
                            _isLoading = 1 ;
                          });

                           try{
                             var response = await http.get(
                               Uri.parse('https://www.google.com/'),
                             ).timeout(Duration(seconds: 15)).then((value) async {
                               if(value.statusCode == 200) {
                                 await   _authController.logOut();
                                 setState(() {
                                   _isLoading = 0 ;
                                 });
                                 Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context){
                                   return ChoiceUserScreen();
                                 }),
                                         (route) => false);

                                 Fluttertoast.showToast(msg: "لقد قمت بتسجيل الخروج !!", gravity: ToastGravity.CENTER
                                 );
                               }
                               else{
                                 setState(() {
                                   _isLoading = 0 ;
                                 });
                                 Navigator.pop(context);

                                 Fluttertoast.showToast(msg: "حدث خطأ ما الرجاء العودة لاحقا");

                               }
                             });
                           }
                           catch(e){
                             Navigator.pop(context);

                             print("$e 888888");
                             Fluttertoast.showToast(msg: e.toString(),toastLength: Toast.LENGTH_LONG);

                              Fluttertoast.showToast(msg:" أنت غير متصل, الرجاء التأكد من توفر حزم الانترنت", gravity: ToastGravity.CENTER);

                           }

                         } ,
                       ),
                       InkWell(
                         child: Container(
                           alignment: Alignment.center,
                              width: 55,
                              height: 40,
                              color: Colors.red,
                             child: Text("no", style: TextStyle(color: Colors.white,
                             fontSize: 14, fontWeight: FontWeight.bold),)),
                         onTap:(){
                           Navigator.of(context).pop();
                         } ,
                       )

                     ],
                   )
                 ],
               );
             });


          }, child: Text("تسجيل الخروج ",
            style: Generalstyle.buttonTextStyle(),)),
          SizedBox(height: 1,),

          SizedBox(height: 1,),
          SizedBox(height: 1,),
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
  Widget _drawLoadingScreen2(){
    return Container(
      width: MediaQuery.of(context).size.width*0.2,
      height: MediaQuery.of(context).size.height*0.2,
      color: Colors.white24,
      child: Center(
        child: SizedBox(
            width: 50,
            height: 50,
            child: CircularProgressIndicator()),
      ),
    );
  }
  // Future<void> _checkInternetConnection() async {
  //   try {
  //     final result = await InternetAddress.lookup('www.google.com').timeout(Duration(seconds: 10));
  //     if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
  //       Fluttertoast.showToast(msg: "1111111");
  //
  //       print('connected');
  //     }
  //     else{
  //       Fluttertoast.showToast(msg: "000000");
  //
  //     }
  //   } on SocketException catch (e) {
  //     Fluttertoast.showToast(msg: "$e 222222");
  //
  //     print('not connected');
  //   }
  // }
  Future<void> _sendCheckInternet() async {
    try {
      var response = await http.get(
          Uri.parse('https://www.google.com/'),
      ).timeout(Duration(seconds: 10));
        print("1111111 ${response.statusCode}");
            if(response.statusCode == 200){
              Fluttertoast.showToast(msg: "1111111");
            }
            else{
              Fluttertoast.showToast(msg: "22222");
            }
    }
    catch (e) {
      Fluttertoast.showToast(msg: "0000");

      print('error is: $e');
    }
  }

}
