import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
 import 'package:usdt_jordan/Utilities/MyBackgroundsColors.dart';
import 'package:usdt_jordan/Utilities/generalStyle.dart';

class PersonalInfoScreen extends StatefulWidget {
  const PersonalInfoScreen({Key? key}) : super(key: key);

  @override
  _PersonalInfoScreenState createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends State<PersonalInfoScreen> {
 late User? _currentlUser;
 late String _emailUser;


 CollectionReference _personalDataReference = FirebaseFirestore.instance.collection("usersInfo");
  @override
  void initState() {
    _currentlUser =FirebaseAuth.instance.currentUser;
   if(_currentlUser!= null){
     _emailUser = _currentlUser!.email!;

   }
   super.initState();

  }
  @override
  Widget build(BuildContext context)  {

    return Scaffold(
      appBar:AppBar(
        title: Text("المعلومات الشخصية"),
        centerTitle: true,
      ),
      body:(_currentlUser==null)? _noUser() :
      FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection("usersInfo").doc(_emailUser).get(),
          builder: (context,  snapshot){
          if(  snapshot.hasError ){}
          switch(snapshot.connectionState){
            case ConnectionState.waiting : return _loading() ;
            case ConnectionState.active : return _loading();
            default  :
              if(snapshot.hasData){

                return     Container(
                  padding: EdgeInsets.only(right: 12, left: 12),

                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  color: MyBackGrounsColors.appBodyColor(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(height: 1,),
                      SizedBox(height: 1,),
                      SizedBox(height: 1,),
                       Container(
                         height: 280,
                           width: MediaQuery.of(context).size.width,
                           alignment: Alignment.center,

                           child: Column(
                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                             children: [
                             Container(
                               height: 60,
                               width: MediaQuery.of(context).size.width,
                               alignment: Alignment.center,
                             decoration: BoxDecoration(
                                 border: Border.all(color: Colors.white,width: 1),
                                 color: MyBackGrounsColors.appButtonsColor(),
                                 borderRadius: BorderRadius.circular(30)
                             ),
                             padding: EdgeInsets.all(12),
                             child: Row(
                               mainAxisAlignment: MainAxisAlignment.spaceAround,
                               children: [
                                 Text(""),
                                 Text(snapshot.data!["full_name"],style: Generalstyle.bodyTextStyleNormal(),),
                                 Icon(Icons.person, color: Colors.white,)
                               ],
                             ),),
                             Container(
                               height: 60,
                               width: MediaQuery.of(context).size.width,
                               alignment: Alignment.center,
                               decoration: BoxDecoration(
                                   border: Border.all(color: Colors.white,width: 1),

                                   color: MyBackGrounsColors.appButtonsColor(),
                                   borderRadius: BorderRadius.circular(30)
                               ),
                               padding: EdgeInsets.all(12),
                               child: Row(
                                 mainAxisAlignment: MainAxisAlignment.spaceAround,
                                 children: [
                                   Text(""),

                                   Text( snapshot.data!["number"],style: Generalstyle.bodyTextStyleNormal(),),
                                   Icon(Icons.phone, color: Colors.white,
                                     size: 30,)
                                 ],
                               ),),
                             Container(
                               height: 60,
                               width: MediaQuery.of(context).size.width,
                               alignment: Alignment.center,
                               decoration: BoxDecoration(
                                   color: MyBackGrounsColors.appButtonsColor(),
                                   border: Border.all(color: Colors.white,width: 1),

                                   borderRadius: BorderRadius.circular(30)
                               ),
                               padding: EdgeInsets.all(12),
                               child: Row(
                                 mainAxisAlignment: MainAxisAlignment.spaceAround,
                                 children: [
                                   Text(""),

                                   Text(snapshot.data!["email"],style: Generalstyle.bodyTextStyleNormal(),),
                                   Icon(Icons.email_outlined, color: Colors.white,)
                                 ],
                               ),),
                             ],
                           )),

                      SizedBox(height: 1,),
                      SizedBox(height: 1,),
                      SizedBox(height: 1,),


                    ],
                  ),


                );
              }else{return Container(color: Colors.red,);}

          }

          }) ,
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


}
