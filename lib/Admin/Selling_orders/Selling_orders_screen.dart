import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:usdt_jordan/Admin/Buying_orders/Buying_orders_screen.dart';
import 'package:usdt_jordan/Admin/Buying_orders/search_model.dart';
import 'package:usdt_jordan/Admin/Selling_orders/selling_orders_controller.dart';
import 'package:usdt_jordan/Admin/admin_chat/one_chat.dart';
import 'package:usdt_jordan/User/SellCMV/sell_orders_controller.dart';
 class AdmSellingOrdersScreen extends StatefulWidget {
  const AdmSellingOrdersScreen({Key? key}) : super(key: key);

  @override
  _AdmSellingOrdersScreenState createState() => _AdmSellingOrdersScreenState();
}

class _AdmSellingOrdersScreenState extends State<AdmSellingOrdersScreen> {
  SellingOrdersController _controllerSell = SellingOrdersController();
  int _isLoading  = 0 ;
  late TextEditingController _textFieldController;
   late bool _searchState;
  late List<SearchModel> _searchList;

  late List<SearchModel> _searchResults;


  @override
  void initState() {
    _searchResults = [];
    _searchList = [];
    _searchState = false;
    _textFieldController = TextEditingController();
    super.initState();
  }


  @override
  void dispose() {
    _textFieldController.dispose();
   super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return
      Scaffold(
        body: Column(
          children: [
            Container(
                height: 50,
                width: MediaQuery
                    .of(context)
                    .size
                    .width,
                child:(_isLoading == 1 )? _drawLoadingScreen() :
                ((_searchState) ? _drawSearchUppserWidget(context) :
                _drawUpperNonSearcHWidget(context))

            ),
            Expanded(
                child:(_isLoading == 1)? _drawLoadingScreen()
                  : ((_searchState) ? _drawLowerSearchResut(context)
                    : _drawLowerBasicWidget(context))

            )


          ],
        ),
      );
  }

  Widget _drawLowerCard(DocumentSnapshot documentSnapshot ) {
    return Container(
      width: MediaQuery.of(context).size.width*0.96,
      height: MediaQuery.of(context).size.height*0.05,
      color: Colors.white,
      child: Row(

        children: [
          Container(
            decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                border: Border.all(color: Colors.black, width: 1)
            ),
            width: MediaQuery.of(context).size.width * .32,
            height: MediaQuery.of(context).size.height * .05,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [Text(documentSnapshot["usdt_amount"]), Text('usdt')],
            ),
          ),
          Container(
            decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                border: Border.all(color: Colors.black, width: 1)
            ),
            height: MediaQuery.of(context).size.height * .05,
            width: MediaQuery.of(context).size.width * .32,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [Text(documentSnapshot["dinar_amount"]), Text('jd')],
            ),
          ),
          Container(
            decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                border: Border.all(color: Colors.black, width: 1)
            ),
            height: MediaQuery.of(context).size.height * .05,
            width: MediaQuery.of(context).size.width * .32,
            child:
            Align(
                alignment: Alignment.center,
                child: Text(documentSnapshot["show_time"])),

          ),
        ],
      ),
    );
  }

  Widget _drawUpperCard(DocumentSnapshot documentSnapshot, int index) {
    return Container(
        width: MediaQuery.of(context).size.width*.96,
        height: MediaQuery.of(context).size.height*0.20,
        color: Colors.white,
        child: Row(
          children: [
            Container(
              height: MediaQuery.of(context).size.height*0.20,
              width: MediaQuery.of(context).size.width*.60,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    children: [
                      Text(documentSnapshot["name"]),
                      Container(
                        child: IconButton(onPressed: (){
                          String _copy =  documentSnapshot["name"];
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
                    children: [
                      Text(documentSnapshot["email"]),
                      Container(
                        child: IconButton(onPressed: (){
                          String _copy = documentSnapshot["email"];
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
                    children: [
                      Text(documentSnapshot["number"]),
                      Container(
                        child: IconButton(onPressed: (){
                          String _copy = documentSnapshot["number"];
                          Clipboard.setData(ClipboardData(text: _copy));
                          Fluttertoast.showToast(msg: "number has been copied", toastLength: Toast.LENGTH_LONG,
                              gravity: ToastGravity.CENTER
                          );
                        }, icon:Icon(Icons.copy, size: 18, color: Colors.purpleAccent,) ),
                        height: MediaQuery.of(context).size.height*0.04,
                        width: MediaQuery.of(context).size.width*.10,
                      )

                    ],
                  ) ,
                ],
              ),
            ),
            Container(

              height: MediaQuery.of(context).size.height*0.20,
              width: MediaQuery.of(context).size.width*.36,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment:CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text((index + 1).toString()),
                      IconButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context){
                            return OneChatAdmin(emailOneChat: documentSnapshot["email"],
                              userRead: false,);
                          }));
                        },
                        icon: Icon(Icons.chat,color: Colors.blue,size: 25,),
                      ),

                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,

                    children: [
                      IconButton(
                          onPressed: () {
                            showDialog(context: context, builder: (  context){
                              return AlertDialog(
                                title:Text("الطلب تم بنجاح"),
                                content: Text("sure ??!?!"),
                                actions: [ElevatedButton(onPressed: ()async{

                                   setState(() {
                                    _isLoading = 1 ;
                                  });
                                  try{
                                    Navigator.of(context,).pop();


                                    await _controllerSell.sendAcceptedAdminHistory
                                      (
                                      documentSnapshot["name"],
                                      documentSnapshot["email"],
                                      documentSnapshot["usdt_amount"],
                                      documentSnapshot["dinar_amount"],
                                      documentSnapshot["time"],
                                      documentSnapshot["show_time"]
                                      , documentSnapshot["number"],
                                    );
                                    print("444444");

                                    await _controllerSell.sendAcceptedOederToUserHistory(
                                        documentSnapshot["email"],
                                        documentSnapshot["time"]);



                                    await _controllerSell.sendCountViaMonth(documentSnapshot["dinar_amount"],
                                        documentSnapshot["usdt_amount"]);

                                    await _controllerSell.sendTimeCountBuyHistory(documentSnapshot["dinar_amount"],
                                      documentSnapshot["usdt_amount"]);

                                    await _controllerSell.deletSellOrder(documentSnapshot["email"],
                                        documentSnapshot["time"]);
                                    print("010101");

                                    setState(() {
                                      _isLoading = 0 ;
                                      _searchState =false;
                                    });


                                  }
                                  catch(e){
                                    setState(() {
                                      _isLoading = 0 ;
                                      _searchState =false;
                                    });
                                    Fluttertoast.showToast(msg: "$e");
                                  }

                                }, child: Text("yes")),
                                  Text("            "),
                                  ElevatedButton(onPressed: (){
                                    Navigator.of(context,).pop();

                                  }, child: Text("no"))],
                              );
                            });
                          }, icon: Icon(Icons.done, color: Colors.green,size: 25,)),
                      IconButton(onPressed: () {
                        showDialog(context: context, builder: (  context){
                          return AlertDialog(

                            title:Text(" إلغاء الطلب "),
                            content: Text("sure ??!?!"),
                            actions: [ElevatedButton(onPressed: ()async{


                              Navigator.pop(context);

                              try{
                                setState(() {
                                  _isLoading = 1 ;
                                });
                                await _controllerSell.sendAdminDeletedHistory(
                                  documentSnapshot["name"],
                                  documentSnapshot["email"],
                                  documentSnapshot["usdt_amount"],
                                  documentSnapshot["dinar_amount"],
                                  documentSnapshot["time"],
                                  documentSnapshot["show_time"],
                                  documentSnapshot["number"],
                                );
                                print("11111");
                                await _controllerSell.sendDeletedOederToUserHistory
                                  (documentSnapshot["email"],
                                    documentSnapshot["time"]);
                                print("2222");
                                await _controllerSell.deletSellOrder(documentSnapshot["email"],
                                    documentSnapshot["time"]);
                                setState(() {
                                  _isLoading = 0 ;
                                });
                              }
                              catch(e){
                                setState(() {
                                  _isLoading = 0 ;
                                });
                              }
                              print("44444");


                            }, child: Text("yes")),
                              Text("            "),
                              ElevatedButton(onPressed: (){
                                Navigator.pop(context);
                              }, child: Text("no"))],
                          );
                        });
                      }, icon:Icon(Icons.delete_forever,color: Colors.red,size: 25, ) ),
                    ],),


                ],
              ),
            )
          ],
        )

    );
  }

  Widget _drawSearchUppserWidget(BuildContext context) {
    return Container(
      width: MediaQuery
          .of(context)
          .size
          .width,
      height: 50,
      child: Row(
        children: [
          Container(

            padding: EdgeInsets.only(left: MediaQuery
                .of(context)
                .size
                .width * 0.04),
            height: 49,
            width: MediaQuery
                .of(context)
                .size
                .width * .8,
            child: TextField(
              controller: _textFieldController,
              textAlign: TextAlign.center,
              onChanged: (value) {
                _calculateTheResultsToList(
                    _textFieldController.text.toString());
              },
            ),
          ),
          Container(
            color: Colors.grey.shade400,
            padding: EdgeInsets.only(right: MediaQuery
                .of(context)
                .size
                .width * 0.03),
            child: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.red, size: 40,),
              onPressed: () {
                _textFieldController.clear();
                setState(() {
                  _searchState = false;
                });
              },
            ),
            height: 49,
            width: MediaQuery
                .of(context)
                .size
                .width * .13,
          )
        ],
      ),
    );
  }

 Widget _drawLowerBasicWidget(BuildContext context) {
    return StreamBuilder<QuerySnapshot>

      (
      stream: FirebaseFirestore.instance.collection("sell_orders").orderBy("time", descending: false).snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('error , come later');
        }
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Text("wait just a minute");
          default :
            return ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: snapshot.data!.size,
              itemBuilder:(context, index){
                if(_searchList.length == 0){

                  SearchModel _PrepareSearchItem =
                  SearchModel(index,
                      snapshot.data!.docs[index]["name"],
                      snapshot.data!.docs[index]["email"],
                      snapshot.data!.docs[index]["number"],
                      snapshot.data!.docs[index]["payment_method"],
                      snapshot.data!.docs[index]["dinar_amount"],
                      snapshot.data!.docs[index]["usdt_amount"],
                      snapshot.data!.docs[index]["time"],
                      snapshot.data!.docs[index]["show_time"],
                      snapshot.data!.docs[index]["wallet"]
                      ,  "0");
                  _searchList.add(_PrepareSearchItem);
                }
                else{
                  bool _isPresent = false;
                  SearchModel _PrepareSearchItem =
                  SearchModel(index,
                      snapshot.data!.docs[index]["name"],
                      snapshot.data!.docs[index]["email"],
                      snapshot.data!.docs[index]["number"],
                      snapshot.data!.docs[index]["payment_method"],
                      snapshot.data!.docs[index]["dinar_amount"],
                      snapshot.data!.docs[index]["usdt_amount"],
                      snapshot.data!.docs[index]["time"],
                      snapshot.data!.docs[index]["show_time"],
                      snapshot.data!.docs[index]["wallet"]
                      ,"0");
                  for(var item in _searchList){
                    if(snapshot.data!.docs[index]["time"] == item.time &&
                        snapshot.data!.docs[index]["name"] == item.name){
                      _isPresent = true;
                      break ;
                    }
                  }
                  if(! _isPresent){
                    _searchList.add(_PrepareSearchItem);
                    print("$_searchList 444444");
                  }

                }
                  return Container(
                    margin: EdgeInsets.all(2),
                    decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        border: Border.all(width: 2, color: Colors.blue)
                    ),
                    child: Column(
                      children: [
                        _drawUpperCard(snapshot.data!.docs[index],index),
                        _drawLowerCard(snapshot.data!.docs[index], ),

                      ],
                    ),
                  );
              },

            );
        }
      },
    );
  }

  Widget _drawUpperNonSearcHWidget(BuildContext context) {
    return Container(
      width: MediaQuery
          .of(context)
          .size
          .width,
      height: 49,
      child: Center(
        child: IconButton(
          icon: Icon(Icons.search, size: 25, color: Colors.grey,),
          onPressed: () {
            setState(() {
              _searchState = true;
            });
          },
        ),
      ),
    );
  }

 Widget _drawLowerSearchResut(BuildContext context) {
    if (_searchResults.length == 0) {
      return _drawNoResultFounf();
    }
    else {
      return ListView.builder(itemBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.all(2),
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              border: Border.all(width: 2, color: Colors.blue)
          ),
          child: Column(
            children: [

              _drawUpperCardSearch(_searchResults[index], index),
              _drawLowerCardSearc(_searchResults[index]),

            ],
          ),
        );
      },
        itemCount: _searchResults.length,);
    }
  }


  Widget _drawNoResultFounf() {
    return Container(
      child: Align(
        alignment: Alignment.center,
        child: Text("Search !!", style: TextStyle(fontSize: 14),),
      ),
    );
  }

  void _calculateTheResultsToList(String text) {
    _searchResults.clear();
    if (text.length > 0 && text != "" && text != null) {
      for (var item in _searchList) {
        if (item.name.toString().toLowerCase().contains(
            text.toString().toLowerCase()) ||
            item.number.toString().toLowerCase().contains(
                text.toString().toLowerCase()) ||
            item.email.toString().toLowerCase().contains(
                text.toString().toLowerCase()) ||
            item.usdt_amount.toString().toLowerCase().contains(
                text.toString().toLowerCase()) ||
            item.dinar_amount.toString().toLowerCase().contains(
                text.toString().toLowerCase())) {
          _searchResults.add(item);
        }
      }
    }
    print("$_searchResults 88888");

    setState(() {
      _searchResults;
    });
  }

  Widget _drawLowerCardSearc(SearchModel searchModel) {
    return Container(
      width: MediaQuery.of(context).size.width*0.96,
      height: MediaQuery.of(context).size.height*0.05,
      color: Colors.white,
      child: Row(

        children: [
          Container(
            decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                border: Border.all(color: Colors.black, width: 1)
            ),
            width: MediaQuery.of(context).size.width * .32,
            height: MediaQuery.of(context).size.height * .05,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [Text(searchModel.dinar_amount), Text('JD')],
            ),
          ),
          Container(
            decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                border: Border.all(color: Colors.black, width: 1)
            ),
            height: MediaQuery.of(context).size.height * .05,
            width: MediaQuery.of(context).size.width * .32,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [Text(searchModel.usdt_amount), Text('USDT')],
            ),
          ),
          Container(
            decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                border: Border.all(color: Colors.black, width: 1)
            ),
            height: MediaQuery.of(context).size.height * .05,
            width: MediaQuery.of(context).size.width * .32,
            child:
            Align(
              alignment: Alignment.center,
              child: Text(searchModel.show_time),

            ),
          )],
      ),
    );
  }

  Widget _drawUpperCardSearch(SearchModel searchModel, int index) {
    return Container(
        width: MediaQuery.of(context).size.width*.96,
        height: MediaQuery.of(context).size.height*0.20,
        color: Colors.white,
        child: Row(
          children: [
            Container(
              height: MediaQuery.of(context).size.height*0.20,
              width: MediaQuery.of(context).size.width*.60,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    children: [
                      Text(searchModel.name),
                      Container(
                        child: IconButton(onPressed: (){
                          String _copy = searchModel.name;
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
                    children: [
                      Text(searchModel.email),
                      Container(
                        child: IconButton(onPressed: (){
                          String _copy = searchModel.email;
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
                    children: [
                      Text(searchModel.number),
                      Container(
                        child: IconButton(onPressed: (){
                          String _copy = searchModel.number;
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
              ),
            ),
            Container(

              height: MediaQuery.of(context).size.height*0.20,
              width: MediaQuery.of(context).size.width*.36,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment:CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text((index + 1).toString()),
                      IconButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context){
                            return OneChatAdmin(emailOneChat:searchModel.email,
                              userRead: false,);
                          }));
                        },
                        icon: Icon(Icons.chat,color: Colors.blue,size: 25,),
                      ),

                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,

                    children: [
                      IconButton(
                          onPressed: () {
                            showDialog(context: context, builder: (  context){
                              return AlertDialog(
                                title:Text("الطلب تم بنجاح"),
                                content: Text("sure ??!?!"),
                                actions: [ElevatedButton(onPressed: ()async{


                                  Navigator.of(context,).pop();
                                 try {
                                   setState(() {
                                     _isLoading = 1 ;
                                   });
                                   print("555555");
                                   await _controllerSell.sendAcceptedAdminHistory(
                                       searchModel.name,
                                       searchModel.email,
                                       searchModel.usdt_amount,
                                       searchModel.dinar_amount,
                                       searchModel.time,
                                       searchModel.show_time,
                                       searchModel.number

                                   );
                                   print("3333333");

                                   await _controllerSell.sendAcceptedOederToUserHistory(
                                       searchModel.email,
                                       searchModel.time);
                                   print("444444");
                                    await _controllerSell.sendTimeCountBuyHistory(searchModel.dinar_amount,
                                        searchModel.usdt_amount);
                                    await _controllerSell.sendCountViaMonth(searchModel.dinar_amount,
                                    searchModel.usdt_amount);
                                   await _controllerSell.deletSellOrder(searchModel.email,
                                       searchModel.time);
                                   setState(() {
                                     _isLoading = 0 ;
                                     _searchState =false;
                                   });

                                 }
                                 catch(e){
                                   Fluttertoast.showToast(msg: "$e");
                                   setState(() {
                                     _isLoading = 0 ;
                                     _searchState =false;
                                   });
                                 }


                                }, child: Text("yes")),
                                  Text("            "),
                                  ElevatedButton(onPressed: (){
                                    Navigator.of(context,).pop();

                                  }, child: Text("no"))],
                              );
                            });
                          }, icon: Icon(Icons.done, color: Colors.green,size: 25,)),
                      IconButton(onPressed: () {
                        showDialog(context: context, builder: (  context){
                          return AlertDialog(

                            title:Text(" إلغاء الطلب "),
                            content: Text("sure ??!?!"),
                            actions: [ElevatedButton(onPressed: ()async{


                              Navigator.pop(context);

                              try{

                                setState(() {
                                  _isLoading = 1 ;
                                });
                                await _controllerSell.sendAdminDeletedHistory(
                                  searchModel.name,searchModel.email,
                                  searchModel.usdt_amount,
                                  searchModel.dinar_amount,searchModel.time,
                                  searchModel.show_time
                                  , searchModel.number,
                                );
                                print("11111");
                                await _controllerSell.sendDeletedOederToUserHistory
                                  (searchModel.email,
                                    searchModel.time);
                                print("2222");
                                await _controllerSell.deletSellOrder(searchModel.email,
                                    searchModel.time);
                                setState(() {
                                  _isLoading = 0 ;
                                });
                              }
                              catch(e){
                                setState(() {
                                  _isLoading = 0 ;
                                });
                                Fluttertoast.showToast(msg: "$e");
                              }
                              print("44444");

                            }, child: Text("yes")),
                              Text("            "),
                              ElevatedButton(onPressed: (){
                                Navigator.pop(context);
                              }, child: Text("no"))],
                          );
                        });
                      }, icon:Icon(Icons.delete_forever,color: Colors.red,size: 25, ) ),
                    ],),


                ],
              ),
            )
          ],
        )

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


}