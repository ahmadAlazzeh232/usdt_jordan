
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:math';

import 'package:usdt_jordan/Admin/Buying_orders/SearchUserModel.dart';
class UsersInAdminPage extends StatefulWidget {
  const UsersInAdminPage({Key? key}) : super(key: key);
  @override
  _UsersInAdminPageState createState() => _UsersInAdminPageState();
}

class _UsersInAdminPageState extends State<UsersInAdminPage> {

  List<Color> colors = [Colors.cyanAccent,Colors.teal,Colors.yellowAccent,
  Colors.lightGreen,Colors.blueAccent];
   late  bool _isPresente ;
   late bool _isSearch;
   late TextEditingController _textFieldController ;
   late List<SearchUserModel> _searchList ;
   late List<SearchUserModel> _searchResults;
   @override
  void initState() {
     _searchResults = [];
     _searchList=[];
    _isSearch = false;
    _isPresente  = false;
    _textFieldController =TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
return Container(
   width: MediaQuery.of(context).size.width,
   height: MediaQuery.of(context).size.height,
   child:  Column(
     children: [
       Container(
         height: MediaQuery.of(context).size.height*0.1,
         width: MediaQuery.of(context).size.width,
         child: (_isSearch)? _drawUpperSearch() :_drawUpperNonSearch()  ,
       ),
       Expanded(   child: (_isSearch)? _drawLoserSearch(context) :_drawLowerNonSearch()  ,

       )
     ],
   ),

   );




  }
Color getColor(){
  int random = Random().nextInt(4);
  return colors[random];

}

  _drawUpperSearch() {
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

              },
            ),
          ),
          Container(
            color: Colors.grey.shade400,
            padding: EdgeInsets.only(right: MediaQuery.of(context).size.width*0.03),
            child: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.red,size: 40,),
              onPressed: (){
                _textFieldController.clear();
                setState(() {
                  _isSearch= false;
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

  void _calculateTheResultsToList(String string) {
     _searchResults.clear();
     if(string.length>0 && string != "" && string != null){
       for(var item in _searchList){
         if(item.number.toLowerCase().contains(string) ||
          item.email.toLowerCase().contains(string)||
         item.name.toLowerCase().contains(string)){
           _searchResults.add(item);
         }
       }
     }
    setState(() {
      _searchResults;
    });
   }
  _drawUpperNonSearch() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 49,
      child: Center(
        child: IconButton(
          icon: Icon(Icons.search,size: 25,color:Colors.grey,),
          onPressed: (){
            setState(() {
              _isSearch  = true;
            });
          },
        ),
      ),
    );
  }

 Widget _drawLoserSearch(BuildContext context ) {
    if(_searchResults.length == 0){
      return _drawNoResultFounf();

    }
    else{
       return ListView.builder(itemBuilder: (context, index){
         return Container(
           width: MediaQuery.of(context).size.width,
           height: MediaQuery.of(context).size.height*.2,
           child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
             children: [

               Text((index +1).toString()),

               Row(

                 mainAxisAlignment: MainAxisAlignment.spaceAround,
                 children: [
                   Text(_searchResults[index].name),
                   Container(
                     child: IconButton(onPressed: (){
                       String _copy =  _searchResults[index].name;
                       Clipboard.setData(ClipboardData(text: _copy));
                       Fluttertoast.showToast(msg: "name has been copied", toastLength: Toast.LENGTH_LONG,
                           gravity: ToastGravity.CENTER
                       );
                     }, icon:Icon(Icons.copy, size: 18, color: Colors.purpleAccent,) ),
                     height: MediaQuery.of(context).size.height*0.04,
                     width: MediaQuery.of(context).size.width*.10,
                   )
                 ],
               ),
               Row(

                 mainAxisAlignment: MainAxisAlignment.spaceAround,
                 children: [
                   Text(_searchResults[index].email),
                   Container(
                     child: IconButton(onPressed: (){
                       String _copy = _searchResults[index].email;
                       Clipboard.setData(ClipboardData(text: _copy));
                       Fluttertoast.showToast(msg: "email has been copied", toastLength: Toast.LENGTH_LONG,
                           gravity: ToastGravity.CENTER
                       );
                     }, icon:Icon(Icons.copy, size: 18, color: Colors.purpleAccent,) ),
                     height: MediaQuery.of(context).size.height*0.04,
                     width: MediaQuery.of(context).size.width*.10,
                   )
                 ],
               ),
               Row(
                 mainAxisAlignment: MainAxisAlignment.spaceAround,
                 children: [
                   Text(_searchResults[index].number),
                   Container(
                     child: IconButton(onPressed: (){
                       String _copy = _searchResults[index].number;
                       Clipboard.setData(ClipboardData(text: _copy));
                       Fluttertoast.showToast(msg: "number has been copied", toastLength: Toast.LENGTH_LONG,
                           gravity: ToastGravity.CENTER
                       );
                     }, icon:Icon(Icons.copy, size: 18, color: Colors.purpleAccent,) ),
                     height: MediaQuery.of(context).size.height*0.04,
                     width: MediaQuery.of(context).size.width*.10,
                   )

                 ],
               ),
               Container(
                 height: 2,
                 width: MediaQuery.of(context).size.width*0.8,
                 color: Colors.blue,
               )
             ],
           ),
         );
       },
         itemCount:_searchResults.length ,);
    }
 }
  Widget _drawNoResultFounf() {
    return Container(
      child: Align(
        alignment: Alignment.center,
        child: Text("Search !!",style: TextStyle(fontSize: 14),),
      ),
    );

  }

  Widget _drawLowerNonSearch(){
    return StreamBuilder <QuerySnapshot>
      (stream : FirebaseFirestore.instance.collection("usersInfo").snapshots()
      ,builder:(BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot){
        if(snapshot.hasError){return Text("there is some error 404");}
        switch(snapshot.connectionState){
          case ConnectionState.waiting : return CircularProgressIndicator(strokeWidth: 15.0,);
          default : return  ListView.builder(
               itemCount: snapshot.data!.docs.length,
               itemBuilder: (context,index){
                 if(_searchList.length == 0){

                    SearchUserModel _PrepareSearchItem =
                   SearchUserModel( snapshot.data!.docs[index]["full_name"],
                   snapshot.data!.docs[index]["number"],
                     snapshot.data!.docs[index]["email"],
                       (index+1).toString());
                        _searchList.add(_PrepareSearchItem);
                 }
                 else{
                     _isPresente = false;
                   SearchUserModel _PrepareSearchItem =
                   SearchUserModel( snapshot.data!.docs[index]["full_name"],
                       snapshot.data!.docs[index]["number"],
                       snapshot.data!.docs[index]["number"],
                       (index+1).toString());
                   for(var item in _searchList){
                     if(snapshot.data!.docs[index]["full_name"] == item.name){
                       _isPresente = true;
                       break ;
                     }
                   }
                   if(! _isPresente){
                     _searchList.add(_PrepareSearchItem);
                     print("$_searchList 444444");
                   }

                 }
                 return   Container(

                   decoration: BoxDecoration(
                       color: Colors.white,

                       border: Border.all(color: Colors.blue, width: 1),
                     shape: BoxShape.rectangle
                   ),
                   width: MediaQuery.of(context).size.width,
                   height: MediaQuery.of(context).size.height*.2,
                   child: Column(
                     children:
                   [
                     Text((index +1).toString()),
                     Row(
                       mainAxisAlignment: MainAxisAlignment.spaceAround,
                       children: [
                         Text(snapshot.data!.docs[index]["full_name"]),
                         Container(
                           child: IconButton(onPressed: (){
                             String _copy =  snapshot.data!.docs[index]["full_name"];
                             Clipboard.setData(ClipboardData(text: _copy));
                             Fluttertoast.showToast(msg: "name has been copied", toastLength: Toast.LENGTH_LONG,
                                 gravity: ToastGravity.CENTER
                             );
                           }, icon:Icon(Icons.copy, size: 18, color: Colors.purpleAccent,) ),
                           height: MediaQuery.of(context).size.height*0.04,
                           width: MediaQuery.of(context).size.width*.10,
                         )

                       ],
                     ),
                     SizedBox(height: 15,),
                     Row(

                       mainAxisAlignment: MainAxisAlignment.spaceAround,

                       children: [
                         Text(snapshot.data!.docs[index]["email"]),
                         Container(
                           child: IconButton(onPressed: (){
                             String _copy = snapshot.data!.docs[index]["email"];
                             Clipboard.setData(ClipboardData(text: _copy));
                             Fluttertoast.showToast(msg: "email has been copied", toastLength: Toast.LENGTH_LONG,
                                 gravity: ToastGravity.CENTER
                             );
                           }, icon:Icon(Icons.copy, size: 18, color: Colors.purpleAccent,) ),
                           height: MediaQuery.of(context).size.height*0.04,
                           width: MediaQuery.of(context).size.width*.10,
                         )

                       ],
                     ),
                     SizedBox(height: 15,),
                     Row(
                       mainAxisAlignment: MainAxisAlignment.spaceAround,
                       children: [
                         Text(snapshot.data!.docs[index]["number"]),
                         Container(
                           child: IconButton(onPressed: (){
                             String _copy = snapshot.data!.docs[index]["number"];
                             Clipboard.setData(ClipboardData(text: _copy));
                             Fluttertoast.showToast(msg: "number has been copied", toastLength: Toast.LENGTH_LONG,
                                 gravity: ToastGravity.CENTER
                             );
                           }, icon:Icon(Icons.copy, size: 18, color: Colors.purpleAccent,) ),
                           height: MediaQuery.of(context).size.height*0.04,
                           width: MediaQuery.of(context).size.width*.10,
                         )

                       ],
                     ),

                    ],
                     mainAxisAlignment: MainAxisAlignment.center,),
                 );
               },
          );
        }


      } ,);
  }
}


