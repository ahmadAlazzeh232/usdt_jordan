import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
 import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:usdt_jordan/Utilities/MyBackgroundsColors.dart';
import 'package:usdt_jordan/Utilities/generalStyle.dart';
class ReferalInfo extends StatefulWidget {
  const ReferalInfo({Key? key}) : super(key: key);

  @override
  _ReferalInfoState createState() => _ReferalInfoState();
}

class _ReferalInfoState extends State<ReferalInfo> {
   late User? user ;
    late String _email ;

  @override
  void initState() {
      user = FirebaseAuth.instance.currentUser;
      if(user != null){
       _email = user!.email!;
    }
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("كود الخصومات"),
        centerTitle: true,
      ),
      body:(user == null )? _noUser() :

      FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection("referel_code").doc(_email).get(),
        builder: (context,AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {}
          switch (snapshot.connectionState) {
            case ConnectionState.waiting :
              return _loading();
            case ConnectionState.active :
              return _loading();
            default :
              if (snapshot.hasData) {
                return  _drawReferalScreen(snapshot);
              } else {
                return Container(color: Colors.red,);
              }
          }
        })
    );

  }
  Widget _noUser(){
    return
      Container(

        color: MyBackGrounsColors.appBodyColor(),
        child: Center(
          child: Text("أنت غير مسجل في التطبيق !!", style: Generalstyle.bodyTextImportant(),),
        ),
      );
  }
        Widget _loading(){
      return Container(
        color: Colors.white24,
        child: CircularProgressIndicator( color: Colors.blue,),
      );
    }

  Widget _drawReferalScreen(AsyncSnapshot<DocumentSnapshot> snapshot) {
    return Container(

      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,

      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 20,),
           Container(
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height*0.15,
            child: Column(
              children: [
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(right: 12, left: 12),

                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height*0.10,
                child: Text("عزيزي العميل \n لمعرفة السياسات المتبعة وشروط الحصول على الخصم\n  يرجى النقر على سياسة الخصومات أدناه ",
                textAlign: TextAlign.center,),
                ),
                Container(
                  alignment: Alignment.center,

                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height*0.05,
                  child: InkWell(
                    child: Text("سياسة الخصومات", style: TextStyle(decoration: TextDecoration.underline
                    ,color: Colors.blue, fontSize: 18, fontWeight: FontWeight.bold),),
                  onTap: (){
                      showDialog(context: context, builder: (context){
                        return Dialog(
                          child: Container(
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width*0.8,
                            height: MediaQuery.of(context).size.height*0.75,
                            child: ListView(
                              scrollDirection: Axis.vertical,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width*0.7,
                                      height: MediaQuery.of(context).size.height*0.07,
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width*0.1,
                                      height: MediaQuery.of(context).size.height*0.07,
                                      child: InkWell(
                                        child: Icon(Icons.backspace, color: Colors.red,size: 30,),
                                        onTap: (){
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    )
                                  ],
                                ),
                                Column()
                              ],
                            ),

                          ),
                        );
                      });
                  },
                  ),
                )
              ],
            ),
          ),
          SizedBox(height: 14,),

          Container(
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height*0.14,
           child: Column(
             mainAxisAlignment: MainAxisAlignment.spaceBetween,
             children: [
               Container(
                 width: MediaQuery.of(context).size.width,
                 height: MediaQuery.of(context).size.height*0.025,
                 alignment: Alignment.center,
                 child: Text("ادعو أصدقائك للتسجيل في التطبيق عبر الكود الخاص بك"),
               ),
               Row(
               mainAxisAlignment: MainAxisAlignment.spaceAround,
               children: [
                 Container(
                   alignment: Alignment.center,
                   decoration: BoxDecoration(
                     border: Border.all(color: Colors.blue,width: 1 ),
                     shape: BoxShape.rectangle
                   ),
                   width: MediaQuery.of(context).size.width*0.75,
                   height: MediaQuery.of(context).size.height*0.09,
                 child: Text(snapshot.data!["referel"], textAlign: TextAlign.center,),
                 ),

                 Container(
                   alignment: Alignment.center,
                   decoration: BoxDecoration(
                       border: Border.all(color: Colors.blue,width: 1 ),
                       shape: BoxShape.rectangle
                   ),
                   width: MediaQuery.of(context).size.width*0.2,
                   height: MediaQuery.of(context).size.height*0.09,
                   child: IconButton(
                     onPressed: (){
                       Clipboard.setData(ClipboardData(text: snapshot.data!["referel"]));
                       Fluttertoast.showToast(msg: "لقد تم نسخ كود الخصم إلى الحافظة", toastLength: Toast.LENGTH_SHORT);
                     },
                     icon: Icon(Icons.copy, color: Colors.purple,size: 35,),
                   ),
                 )
               ],
             ),]
           ),
          ),


          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height*0.15,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.blue,width: 1 ),
                      shape: BoxShape.rectangle
                  ),
                  width: MediaQuery.of(context).size.width*0.2,
                  height: MediaQuery.of(context).size.height*0.13,
                  child: Text(snapshot.data!["#_sign_in"].toString(), textAlign: TextAlign.center,),
                ),

                Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.blue,width: 1 ),
                      shape: BoxShape.rectangle
                  ),
                  width: MediaQuery.of(context).size.width*0.75,
                  height: MediaQuery.of(context).size.height*0.13,
                  child: Text("عدد الأشخاص المسجلين عبر الكود الخاص بك"),
                )
              ],
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height*0.15,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.blue,width: 1 ),
                      shape: BoxShape.rectangle
                  ),
                  width: MediaQuery.of(context).size.width*0.2,
                  height: MediaQuery.of(context).size.height*0.13,
                  child: Text(snapshot.data!["#_done_order"].toString(), textAlign: TextAlign.center,),
                ),

                Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.blue,width: 1 ),
                      shape: BoxShape.rectangle
                  ),
                  width: MediaQuery.of(context).size.width*0.75,
                  height: MediaQuery.of(context).size.height*0.13,
                  child: Text("عدد العمليات التي تم تنفيذها من قبل الأشخاص المدعوين"),

                )
              ],
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height*0.15,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                alignment: Alignment.center,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.blue,width: 1 ),
                      shape: BoxShape.rectangle
                  ),
                  width: MediaQuery.of(context).size.width*0.2,
                  height: MediaQuery.of(context).size.height*0.13,
                  child: Text( "${_calculateDis(snapshot.data!["#_done_order"])} %", textAlign: TextAlign.center,),
                ),

                Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.blue,width: 1 ),
                      shape: BoxShape.rectangle
                  ),
                  width: MediaQuery.of(context).size.width*0.75,
                  height: MediaQuery.of(context).size.height*0.13,
                  child: Text("الخصم المستحق في العملية القادمة"),
                )
              ],
            ),
          ),
          SizedBox(height: 1,),
          SizedBox(height: 1,),
          SizedBox(height: 1,),

          SizedBox(height: 20,),





        ],
      ),
    );
  }
int _calculateDis(int numDone){
    if( numDone>4 && numDone<10){
      return 25 ;
    }
    else if( numDone>9 ){
      return 50;
    } else return 0 ;
    
}
}

