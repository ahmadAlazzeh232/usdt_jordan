import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:usdt_jordan/Admin/admin_chat/chat_search_model.dart';
import 'package:usdt_jordan/Admin/admin_chat/one_chat.dart';

class AllAdminChats extends StatefulWidget {
  const AllAdminChats({Key? key}) : super(key: key);

  @override
  _AllAdminChatsState createState() => _AllAdminChatsState();
}

class _AllAdminChatsState extends State<AllAdminChats> {
  CollectionReference _reference = FirebaseFirestore.instance.collection("all_chats");
    bool _searchState = false;

      TextEditingController _textFieldController = TextEditingController();
   late List<ChatSearchModel> _searchList;
   late List<ChatSearchModel> _searchResults;

  List _readOrNot =[];
 List _readOrNotUser=[];
 Future<void> _getUserReadState()async{
   try{

     await FirebaseFirestore.instance.collection("all_chats").orderBy("time", descending:true ).
     get().then((QuerySnapshot query){
       _readOrNotUser.clear();
       query.docs.forEach((doc) {
         _readOrNotUser.add(doc["read_state"]);
         print("the list is $_readOrNot");
       });

     });
   }
   catch(e){
     Fluttertoast.showToast(msg: "$e");
   }
 }
 Future<void> _getReadState()async{
   try{
     await FirebaseFirestore.instance.collection("all_chats").orderBy("time", descending:true ).
     get().then((QuerySnapshot query){
       _readOrNot.clear();
       query.docs.forEach((doc) {
         _readOrNot.add(doc["read_admin_state"]);
         print("the list is $_readOrNot");
       });
       setState(() {
         _readOrNot ;
       });
     });
   }
   catch(e){
     Fluttertoast.showToast(msg: "$e");
   }

 }

  @override
  void initState() {
   _searchResults =[];
   _searchList = [];
   super.initState();
    _getReadState();
    _getUserReadState();

  }


  @override
  void dispose() {
    _textFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("all users chats"),
        centerTitle: true,
      ),
      body:Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
             (_readOrNot.length == 0 || _readOrNot.isEmpty) ? _isLoading() :

                  Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      child: (_searchState) ? _drawSearchUppserWidget(context) :
                      _drawUpperNonSearcHWidget(context)

                  ),
                  Expanded(child:
                  (_searchState)? _drawLowerSearchResult( context):
                       _drawLowerBasicWidget(context)




                  )

          ],
        ),
      )

     );}



  Widget _drawChatName(DocumentSnapshot documentSnapshot,bool readState,int index  ){
     print("${documentSnapshot["email"]} 77777");
    return InkWell(
      child: Container(
        height: MediaQuery.of(context).size.height*0.12,
        color:(readState)? Colors.grey : Colors.grey.shade900,
        margin: EdgeInsets.only(top: 4, bottom: 4),
        child: ListTile(
          onTap: (){
            bool _userReadState = _readOrNotUser[index];

            setState(() {
              _readOrNot[index] = true;
            });
            Navigator.push(context, MaterialPageRoute(builder: (context){

             return OneChatAdmin(emailOneChat: documentSnapshot["email"], userRead: _userReadState,);
           }));
          },
          leading:
                CircleAvatar(
                 child: Icon(Icons.person,color: Colors.white,size: 35,),

          ) ,
          title:Text( documentSnapshot["name"], style:(readState)?   TextStyle(color: Colors.black, fontWeight: FontWeight.normal, fontSize: 14):
          TextStyle(color: Colors.white)),
          subtitle: Text(documentSnapshot["updatedMessage"], style:(readState)?   TextStyle(color: Colors.black, fontWeight: FontWeight.normal, fontSize: 14):
      TextStyle(color: Colors.white)),
      )),
      // onLongPress: (){
      //   showDialog(context: context, builder: (context){
      //     return Dialog(
      //       child: Container(
      //         decoration: BoxDecoration(
      //           shape: BoxShape.rectangle,
      //           border: Border.all(color: Colors.blue, width: 1)
      //         ),
      //         width: MediaQuery.of(context).size.width*0.52,
      //         height: MediaQuery.of(context).size.height*0.33,
      //         child: Column(
      //           children: [
      //             Container(
      //               alignment: Alignment.center,
      //               width: MediaQuery.of(context).size.width*0.5,
      //               height: MediaQuery.of(context).size.height*0.2,
      //               child: Text("حذف المحادثة ؟!؟ ", textAlign: TextAlign.center,),
      //             ),
      //             Container(
      //               width: MediaQuery.of(context).size.width*0.5,
      //               height: 1,
      //               color: Colors.blue,
      //             ),
      //             Container(
      //               width: MediaQuery.of(context).size.width*0.5,
      //               height: MediaQuery.of(context).size.height*0.1,
      //               child: Row(
      //                 children: [
      //                   InkWell(
      //                     child: Container(
      //                       alignment: Alignment.center,
      //                       decoration: BoxDecoration(
      //                         color: Colors.red,
      //                         shape: BoxShape.rectangle,
      //                         border: Border.all(color: Colors.blue, width: 1)
      //                       ),
      //                       width: MediaQuery.of(context).size.width*0.23,
      //                       height: MediaQuery.of(context).size.height*0.09,
      //                       child: Text("no", style: TextStyle(fontSize: 14, color: Colors.white),
      //                         textAlign: TextAlign.center,),
      //                     ),
      //                     onTap:(){
      //                       Navigator.of(context).pop();},
      //                   ),
      //                   InkWell(
      //                     child: Container(
      //                       alignment: Alignment.center,
      //                       decoration: BoxDecoration(
      //                         color: Colors.green,
      //                           shape: BoxShape.rectangle,
      //                           border: Border.all(color: Colors.blue, width: 1)
      //                       ),
      //                       width: MediaQuery.of(context).size.width*0.23,
      //                       height: MediaQuery.of(context).size.height*0.09,
      //                       child: Text("yes", style: TextStyle(fontSize: 14, color: Colors.white),
      //                         textAlign: TextAlign.center,),
      //                     ),
      //                     onTap: ()async{
      //                       await _deleteChat(documentSnapshot["email"]).then((value){
      //                         Navigator.of(context).pop();
      //                         Fluttertoast.showToast(msg: "لقد تم مسح المحادثة");
      //                       });
      //                     },
      //                   )
      //                 ],
      //               ),
      //
      //             )
      //           ],
      //         ),
      //       ),
      //     );
      //   });
      // },
    );


  }

Widget  _isLoading() {
   return Container(color: Colors.teal,);
}

Future<void> _deleteChat(String email)async{
   try{
     await _reference.doc(email).delete();

   }
   catch(e){
     Fluttertoast.showToast(msg: "$e");
   }
}
  Widget  _drawSearchUppserWidget(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 50,
      child: Row(
        children: [
          Container(

            padding: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.04),
            height: 49,
            width: MediaQuery.of(context).size.width*.8,
            child: TextField(
              controller: _textFieldController,
              textAlign: TextAlign.center,
              onChanged: (value){
               _calculateTheResultsToList(_textFieldController.text.toString());
             //   _calculateTheResultsToList(_textFieldController.text.toString());
              },
            ),
          ),
          Container(
            color: Colors.grey.shade400,
            padding: EdgeInsets.only(right: MediaQuery.of(context).size.width*0.03),
            child: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.red,size: 40,),
              onPressed: (){
                _searchResults.clear();
                _textFieldController.clear();
                setState(() {
                  _searchState= false;
                });
              },
            ),
            height: 49,
            width: MediaQuery.of(context).size.width*.13,
          )
        ],
      ),
    );
  }
  Widget _drawNoResultFounf() {
    return Container(
      child: Align(
        alignment: Alignment.center,
        child: Text("Search !!",style: TextStyle(fontSize: 14),),
      ),
    );

  }

  Widget _drawUpperNonSearcHWidget(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 49,
      child: Center(
        child: IconButton(
          icon: Icon(Icons.search,size: 25,color:Colors.grey,),
          onPressed: (){
            setState(() {
              _searchState  = true;
            });
          },
        ),
      ),
    );
  }
  void _calculateTheResultsToList(String text){
    _searchResults.clear();
    if(text.length>0 && text != "" && text != null){
      for(var item in _searchList){
        if(item.name.toString().toLowerCase().contains(text.toString().toLowerCase())||
            item.updatedMessage.toString().toLowerCase().contains(text.toString().toLowerCase())||
            item.email.toString().toLowerCase().contains(text.toString().toLowerCase())
        ){
          _searchResults.add(item);
        }

      }
    }
    print("$_searchResults 88888");

    setState(() {
      _searchResults ;
    });
  }
  Widget _drawChatNameSearch(ChatSearchModel chatSearchModel,bool readState,int index  ){
     return InkWell(
      child: Container(
          height: MediaQuery.of(context).size.height*0.12,
          color:(readState)? Colors.grey : Colors.grey.shade900,
          margin: EdgeInsets.only(top: 4, bottom: 4),
          child: ListTile(
            onTap: (){
              bool _userReadState = _readOrNotUser[index];

              setState(() {
                _readOrNot[index] = true;
              });
              Navigator.push(context, MaterialPageRoute(builder: (context){
               print("${chatSearchModel.email} 888888");
                return OneChatAdmin(emailOneChat: chatSearchModel.email, userRead: _userReadState,);
              }));
            },
            leading:
            CircleAvatar(
              child: Image(image: ExactAssetImage("assets/images/zainImage.png"),fit:BoxFit.cover ,),

            ) ,
            title:Text(  chatSearchModel.name, style:(readState)?   TextStyle(color: Colors.black, fontWeight: FontWeight.normal, fontSize: 14):
            TextStyle(color: Colors.white)),
            subtitle: Text(chatSearchModel.updatedMessage, style:(readState)?   TextStyle(color: Colors.black, fontWeight: FontWeight.normal, fontSize: 14):
            TextStyle(color: Colors.white)),
          )),
      // onLongPress: (){
      //   showDialog(context: context, builder: (context){
      //     return Dialog(
      //       child: Container(
      //         decoration: BoxDecoration(
      //             shape: BoxShape.rectangle,
      //             border: Border.all(color: Colors.blue, width: 1)
      //         ),
      //         width: MediaQuery.of(context).size.width*0.52,
      //         height: MediaQuery.of(context).size.height*0.33,
      //         child: Column(
      //           children: [
      //             Container(
      //               alignment: Alignment.center,
      //               width: MediaQuery.of(context).size.width*0.5,
      //               height: MediaQuery.of(context).size.height*0.2,
      //               child: Text("حذف المحادثة ؟!؟ ", textAlign: TextAlign.center,),
      //             ),
      //             Container(
      //               width: MediaQuery.of(context).size.width*0.5,
      //               height: 1,
      //               color: Colors.blue,
      //             ),
      //             Container(
      //               width: MediaQuery.of(context).size.width*0.5,
      //               height: MediaQuery.of(context).size.height*0.1,
      //               child: Row(
      //                 children: [
      //                   InkWell(
      //                     child: Container(
      //                       alignment: Alignment.center,
      //                       decoration: BoxDecoration(
      //                           color: Colors.red,
      //                           shape: BoxShape.rectangle,
      //                           border: Border.all(color: Colors.blue, width: 1)
      //                       ),
      //                       width: MediaQuery.of(context).size.width*0.23,
      //                       height: MediaQuery.of(context).size.height*0.09,
      //                       child: Text("no", style: TextStyle(fontSize: 14, color: Colors.white),
      //                         textAlign: TextAlign.center,),
      //                     ),
      //                     onTap:(){
      //                       Navigator.of(context).pop();},
      //                   ),
      //                   InkWell(
      //                     child: Container(
      //                       alignment: Alignment.center,
      //                       decoration: BoxDecoration(
      //                           color: Colors.green,
      //                           shape: BoxShape.rectangle,
      //                           border: Border.all(color: Colors.blue, width: 1)
      //                       ),
      //                       width: MediaQuery.of(context).size.width*0.23,
      //                       height: MediaQuery.of(context).size.height*0.09,
      //                       child: Text("yes", style: TextStyle(fontSize: 14, color: Colors.white),
      //                         textAlign: TextAlign.center,),
      //                     ),
      //                     onTap: ()async{
      //                       await _deleteChat(chatSearchModel.email).then((value){
      //                         Navigator.of(context).pop();
      //                         Fluttertoast.showToast(msg: "لقد تم مسح المحادثة");
      //                       });
      //                     },
      //                   )
      //                 ],
      //               ),
      //
      //             )
      //           ],
      //         ),
      //       ),
      //     );
      //   });
      // },
    );


  }

 Widget _drawLowerBasicWidget(BuildContext context) {
  return StreamBuilder <QuerySnapshot>(
       stream: _reference.orderBy("time",descending: true).snapshots(),
       builder:(BuildContext context , AsyncSnapshot<QuerySnapshot> snapshot){

         if(snapshot.hasError){ return Center(child: Container( child: Text("error, come back later"), ));}
         switch(snapshot.connectionState){
           case ConnectionState.waiting : return Text("wait just a second");
           default : return ListView.builder(

             itemCount:  snapshot.data!.docs.length,
             itemBuilder:(context ,  index){

               bool _readState = _readOrNot[index];

               DocumentSnapshot userData =
               snapshot.data!.docs[index];
               print("${userData["email"]}88888");
               if(_searchList.length == 0){

                 ChatSearchModel _PrepareSearchItem =
                  ChatSearchModel(index,
                     snapshot.data!.docs[index]["email"],
                     snapshot.data!.docs[index]["name"],
                     snapshot.data!.docs[index]["updatedMessage"],
                      );
                 _searchList.add(_PrepareSearchItem);
               }
               else{
                 bool _isPresent = false;
                 ChatSearchModel _PrepareSearchItem =
                    ChatSearchModel(index,
                     snapshot.data!.docs[index]["email"],
                     snapshot.data!.docs[index]["name"],
                     snapshot.data!.docs[index]["updatedMessage"],
                    );
                 for(var item in _searchList){
                   if(snapshot.data!.docs[index]["email"] == item.email
                   ){
                     _isPresent = true;
                     break ;
                   }
                 }
                 if(! _isPresent){
                   _searchList.add(_PrepareSearchItem);
                   print("$_searchList 444444");
                 }

               }

               return _drawChatName(userData,_readState, index );
             } ,

           );
         }});
 }

 Widget _drawLowerSearchResult(BuildContext context) {
   if(_searchResults.length == 0){
     return _drawNoResultFounf();

   }else{
     return ListView.builder(itemBuilder: (context, index){
       return Container(
         child: _drawChatNameSearch(_searchResults[index],
             _readOrNot[index], index ),
       );
     },
       scrollDirection: Axis.vertical,
       itemCount: _searchResults.length,);
   }
 }

}