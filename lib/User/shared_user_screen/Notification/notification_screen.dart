import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
 import 'package:usdt_jordan/Utilities/MyBackgroundsColors.dart';
import 'package:usdt_jordan/Utilities/generalStyle.dart';
class UserNotificationScreen extends StatefulWidget {
  const UserNotificationScreen({Key? key}) : super(key: key);

  @override
  _UserNotificationScreenState createState() => _UserNotificationScreenState();
}

class _UserNotificationScreenState extends State<UserNotificationScreen> {
  late User? _currentlUser;
  late String imagePath ;
  late String _emailUser;
  void initState() {
    _currentlUser =FirebaseAuth.instance.currentUser;
    if(_currentlUser!= null){
      _emailUser = _currentlUser!.email!;

    }
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyBackGrounsColors.appButtonsColor(),
        title: Text("الإشعارات",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body:(_currentlUser == null)  ? _noUser() :
      FutureBuilder<QuerySnapshot>(
          future: FirebaseFirestore.instance.collection("user_history")
              .doc(_emailUser).collection("history_user").orderBy("time", descending: true).get(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
            if(snapshot.hasError){ return _drawErrrorWidget();}
            switch(snapshot.connectionState){
              case ConnectionState.active: return _loading();
              case ConnectionState.waiting :return _loading();

              default  :
                  if(snapshot.data!.docs.length == 0){
                    return _drawNoDate();
                  }
                return Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                    color: MyBackGrounsColors.appBodyColor(),
                      shape: BoxShape.rectangle,
                   ),
                  child: Column(
                    children:[
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height*0.25,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text("My Orders",style: TextStyle(
                              color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold
                            ),),
                            SizedBox(
                              width: 1,
                            )
                          ],
                        ),
                      ),
                      Expanded(
                        child: Container(
                          width: MediaQuery.of(context).size.width*0.8,
                           child: ListView.builder(itemBuilder:(BuildContext context, int index){

                    return Column(children: [_drawHistoryCard(snapshot, index),
                    SizedBox(
                      height: 16,
                    )]);
              },itemCount: snapshot.data!.docs.length,),
                        ),
                      ),]
                  ),
                );
            }


            return Container();
          })

    );
  }
  Widget _drawHistoryCard(AsyncSnapshot<QuerySnapshot> snapshot, int index){
    return
      Container(
      decoration:BoxDecoration(
          color: MyBackGrounsColors.appBodyColor(),
          borderRadius: BorderRadius.circular(30),
          shape: BoxShape.rectangle,
          border: Border.all(color: Colors.white, width: 2)
      ),
      alignment: Alignment.center,

      width: MediaQuery.of(context).size.width*0.8,

      height: MediaQuery.of(context).size.height*0.15,
      child: Row(
        children: [
          Container(
            alignment: Alignment.center,


              child: Text(snapshot.data!.docs[index]["type"]+ "\n \n"+
                  snapshot.data!.docs[index]["usdt_amount"] +" "+"USDT",style:TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20
              ) ,
                textAlign: TextAlign.left,),
             width: MediaQuery.of(context).size.width*0.28,
            height: MediaQuery.of(context).size.height*0.15,
          ),
            Center(
              child: Container(
                width: 1,
                height: MediaQuery.of(context).size.height*0.10,
                color: Colors.white,
              ),
            ),

              Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width*0.5,
                height: MediaQuery.of(context).size.height*0.15,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text((snapshot.data!.docs[index]["order_state"] == 1)?"الطلب تحت المراجعة":

                    ((snapshot.data!.docs[index]["order_state"] ==0 )?"الطلب ملغي" :"الطلب تم بنجاح"), style: TextStyle(
                        color: Colors.white
                    ),),
                    Text(snapshot.data!.docs[index]["show_time"],
                      style: Generalstyle.bodyTextStyleNormal(),textAlign: TextAlign.center,),
                  ],
                ),
              ),
               // Container(
               //
               //   width: MediaQuery.of(context).size.width*0.23,
               //   height: MediaQuery.of(context).size.height*0.15,
               //  child: Center(child:
               // Text((snapshot.data!.docs[index]["order_state"] == 1)?"الطلب تحت المراجعة":
               //
               // ((snapshot.data!.docs[index]["order_state"] ==0 )?"الطلب ملغي" :"الطلب تم بنجاح"), style: TextStyle(
               //   color: Colors.white
               // ),),),
               // ),


                // Container(
                //   alignment: Alignment.center,
                //    child: Center(
                //     child: Text(snapshot.data!.docs[index]["show_time"],
                //       style: Generalstyle.bodyTextStyleNormal(),textAlign: TextAlign.center,),
                //   ),
                //   width: MediaQuery.of(context).size.width*0.23,
                //   height: MediaQuery.of(context).size.height*0.15,
                // ),




        ],
      ),
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

  Widget _drawErrrorWidget() {
    return Container(
      width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
      child: Center(
        child: Text("لقد حدث خطأ أثناء الإنصال بالشبكة \n  الرجاء العودة لاحقا",style: Generalstyle.bodyTextImportant(),),
      ),
    );
  }
  Widget _drawNoDate() {
    return Container(
      alignment: Alignment.center,
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Center(
        child:Text("لا يوجد لديك أي إشعار حتى الآن \n وقتا سعيدا" ,style: TextStyle(),
        textAlign: TextAlign.center,)
      ),
    );
  }

}
