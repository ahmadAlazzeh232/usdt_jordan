import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:usdt_jordan/Admin/Adm_history_orders/search_history_model.dart';

class AcceptedOrderAdminScreen extends StatefulWidget {
  const AcceptedOrderAdminScreen({Key? key}) : super(key: key);

  @override
  _AcceptedOrderAdminScreenState createState() => _AcceptedOrderAdminScreenState();
}

class _AcceptedOrderAdminScreenState extends State<AcceptedOrderAdminScreen> {
  TextEditingController _textFieldController =TextEditingController();
  CollectionReference _reference = FirebaseFirestore.instance.collection("admin_accepted_orders");


  @override
  void dispose() {
    _textFieldController.dispose();
    super.dispose();
  }
  bool _searchState = false ;
  List<SearchHistoryModel> _searchList = [];
  List<SearchHistoryModel> _searchResults = [];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Column(
        children: [
          Container(
              height: 50,
              width: MediaQuery.of(context).size.width,
              child: (_searchState) ?
              _drawSearchUppserWidget(context) :
              _drawUpperNonSearcHWidget(context)

          ),
          Expanded(
              child:(_searchState)? _drawLowerSearchResult( context)
                  : _drawLowerBasicWidget(context)

          )

        ],
      ),
    );

  }

  Widget _drawHistoryContainer(DocumentSnapshot snapshot){
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height*.23,
      child: Column(
        children: [
          Row(
            children: [
              Container(
                  width: MediaQuery.of(context).size.width*.33,
                  height: MediaQuery.of(context).size.height*.21,
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(2),
                        child: Center(
                          child: Text(snapshot["name"]),
                        ),
                        width: MediaQuery.of(context).size.width*.333,
                        height: MediaQuery.of(context).size.height*.07,
                      ),
                      Container(
                        padding: EdgeInsets.all(2),
                        child: Center(
                          child: Text(snapshot["email"]),
                        ),
                        width: MediaQuery.of(context).size.width*.333,
                        height: MediaQuery.of(context).size.height*.07,
                      ),
                      Container(
                        padding: EdgeInsets.all(2),
                        child: Center(
                          child: Text(snapshot["number"]),
                        ),
                        width: MediaQuery.of(context).size.width*.333,
                        height: MediaQuery.of(context).size.height*.07,
                      ),
                    ],
                  )),
               Container(
                  width: MediaQuery.of(context).size.width*.33,
                  height: MediaQuery.of(context).size.height*.21,
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(2),
                        child: Center(
                          child: Text(snapshot["payment_method"]),
                        ),
                        width: MediaQuery.of(context).size.width*.333,
                        height: MediaQuery.of(context).size.height*.07,
                      ),
                      Container(
                        padding: EdgeInsets.all(2),
                        child: Center(
                          child: Text(snapshot["wallet"]),
                        ),
                        width: MediaQuery.of(context).size.width*.333,
                        height: MediaQuery.of(context).size.height*.07,
                      ),
                      Container(
                        padding: EdgeInsets.all(2),

                        child: Center(
                          child: Text(snapshot["show_time"]),
                        ),
                        width: MediaQuery.of(context).size.width*.333,
                        height: MediaQuery.of(context).size.height*.07,
                      ),
                    ],
                  )),
              Container(
                  width: MediaQuery.of(context).size.width*.33,
                  height: MediaQuery.of(context).size.height*.21,
                  child: Column(
                    children: [
                      Container(
                        child: Center(
                          child: Text(snapshot["type"]+" "+snapshot["use_code"]),
                        ),
                        padding: EdgeInsets.all(2),
                        width: MediaQuery.of(context).size.width*.333,
                        height: MediaQuery.of(context).size.height*.07,
                      ),
                      Container(
                        child: Center(
                          child: Text(snapshot["usdt_amount"]+ " \n usdt"),
                        ),
                        width: MediaQuery.of(context).size.width*.333,
                        padding: EdgeInsets.all(2),
                        height: MediaQuery.of(context).size.height*.07,
                      ),
                      Container(
                        child: Center(
                        child: Text(snapshot["dinar_amount"]+" \n dinar"),
                        ),
                        padding: EdgeInsets.all(2),
                        width: MediaQuery.of(context).size.width*.33,
                        height: MediaQuery.of(context).size.height*.07,
                      ),
                    ],
                  )),

            ],
          ),
          Container(
            height: MediaQuery.of(context).size.height*.02,
            width: MediaQuery.of(context).size.width,
            color: Colors.black,
          )
        ],
      ),



    );

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

 Widget _drawLowerBasicWidget(BuildContext context) {
    return       Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: Colors.white,
      child: StreamBuilder(
        stream:_reference.orderBy("time",  descending: true).snapshots() ,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
          if(snapshot.data == null){return Container(color: Colors.blue,);}

          return ListView.builder(
            itemBuilder: (context, index){
              if(_searchList.length == 0){

                SearchHistoryModel _PrepareSearchItem =
                SearchHistoryModel(index,
                  snapshot.data!.docs[index]["name"],
                  snapshot.data!.docs[index]["email"],
                  snapshot.data!.docs[index]["number"],
                  snapshot.data!.docs[index]["type"],
                  snapshot.data!.docs[index]["payment_method"],
                  snapshot.data!.docs[index]["wallet"],
                  snapshot.data!.docs[index]["time"],
                  snapshot.data!.docs[index]["dinar_amount"],
                  snapshot.data!.docs[index]["usdt_amount"],
                  snapshot.data!.docs[index]["use_code"],

                );
                _searchList.add(_PrepareSearchItem);
              }
              else{
                bool _isPresent = false;
                SearchHistoryModel _PrepareSearchItem =
                SearchHistoryModel(index,
                  snapshot.data!.docs[index]["name"],
                  snapshot.data!.docs[index]["email"],
                  snapshot.data!.docs[index]["number"],
                  snapshot.data!.docs[index]["type"],
                  snapshot.data!.docs[index]["payment_method"],
                  snapshot.data!.docs[index]["wallet"],
                  snapshot.data!.docs[index]["time"],
                  snapshot.data!.docs[index]["dinar_amount"],
                  snapshot.data!.docs[index]["usdt_amount"],
                  snapshot.data!.docs[index]["use_code"],

                );
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
              return  _drawHistoryContainer(snapshot.data!.docs[index]);
            },
            itemCount: snapshot.data!.docs.length,

          );
        },
      ),
    );

 }
  Widget  _drawLowerSearchResult(  BuildContext context) {
    if(_searchResults.length ==0){
      return _drawNoResultFounf();
    }
    else{
      return ListView.builder(itemBuilder: (context, index){
        return  Container(

           decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              border: Border.all(width: 2, color: Colors.blue)
          ),
          child:  _drawHistoryContainerSeaerch(_searchResults[index])
        );

      },
        itemCount: _searchResults.length,);
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
  void _calculateTheResultsToList(String text){
    _searchResults.clear();
    if(text.length>0 && text != "" && text != null){
      for(var item in _searchList){
        if(item.name.toString().toLowerCase().contains(text.toString().toLowerCase())||
            item.number.toString().toLowerCase().contains(text.toString().toLowerCase())||
            item.email.toString().toLowerCase().contains(text.toString().toLowerCase())||
            item.type.toString().toLowerCase().contains(text.toString().toLowerCase())||
            item.paymentMethod.toString().toLowerCase().contains(text.toString().toLowerCase()) ||
            item.wallet.toLowerCase().contains(text.toString().toLowerCase())
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
  Widget _drawHistoryContainerSeaerch(SearchHistoryModel model){
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height*.23,
      child: Column(
        children: [
          Row(
            children: [
              Container(
                  width: MediaQuery.of(context).size.width*.33,
                  height: MediaQuery.of(context).size.height*.21,
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(2),
                        child: Center(
                          child: Text(model.name),
                        ),
                        width: MediaQuery.of(context).size.width*.333,
                        height: MediaQuery.of(context).size.height*.07,
                      ),
                      Container(
                        padding: EdgeInsets.all(2),
                        child: Center(
                          child: Text(model.email) ,
                        ),
                        width: MediaQuery.of(context).size.width*.333,
                        height: MediaQuery.of(context).size.height*.07,
                      ),
                      Container(
                        padding: EdgeInsets.all(2),
                        child: Center(
                          child: Text(model.number),
                        ),
                        width: MediaQuery.of(context).size.width*.333,
                        height: MediaQuery.of(context).size.height*.07,
                      ),
                    ],
                  )),
              Container(
                  width: MediaQuery.of(context).size.width*.33,
                  height: MediaQuery.of(context).size.height*.21,
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(2),
                        child: Center(
                          child: Text(model.paymentMethod),
                        ),
                        width: MediaQuery.of(context).size.width*.333,
                        height: MediaQuery.of(context).size.height*.07,
                      ),
                      Container(
                        padding: EdgeInsets.all(2),
                        child: Center(
                          child: Text(model.wallet),
                        ),
                        width: MediaQuery.of(context).size.width*.333,
                        height: MediaQuery.of(context).size.height*.07,
                      ),
                      Container(
                        padding: EdgeInsets.all(2),

                        child: Center(
                          child: Text(model.time),
                        ),
                        width: MediaQuery.of(context).size.width*.333,
                        height: MediaQuery.of(context).size.height*.07,
                      ),
                    ],
                  )),
              Container(
                  width: MediaQuery.of(context).size.width*.33,
                  height: MediaQuery.of(context).size.height*.21,
                  child: Column(
                    children: [
                      Container(
                        child: Center(
                          child: Text(model.type + " " + model.useCode),
                        ),
                        padding: EdgeInsets.all(2),
                        width: MediaQuery.of(context).size.width*.333,
                        height: MediaQuery.of(context).size.height*.07,
                      ),
                      Container(
                        child: Center(
                          child: Text(model.usdt+ " \n usdt"),
                        ),
                        width: MediaQuery.of(context).size.width*.333,
                        padding: EdgeInsets.all(2),
                        height: MediaQuery.of(context).size.height*.07,
                      ),
                      Container(
                        child: Center(
                          child: Text(model.dinar+" \n dinar"),
                        ),
                        padding: EdgeInsets.all(2),
                        width: MediaQuery.of(context).size.width*.33,
                        height: MediaQuery.of(context).size.height*.07,
                      ),
                    ],
                  )),

            ],
          ),
          Container(
            height: MediaQuery.of(context).size.height*.02,
            width: MediaQuery.of(context).size.width,
            color: Colors.black,
          )
        ],
      ),



    );

  }

}
