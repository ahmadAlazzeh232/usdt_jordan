import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ntp/ntp.dart';

class AdmCounterAllSellDone extends StatefulWidget {
  const AdmCounterAllSellDone({Key? key}) : super(key: key);

  @override
  _AdmCounterAllSellDoneState createState() => _AdmCounterAllSellDoneState();
}

class _AdmCounterAllSellDoneState extends State<AdmCounterAllSellDone> {

  CollectionReference _collectionReferenceAll = FirebaseFirestore.instance.collection("sell_count");
  CollectionReference _collectionReferenceMonth = FirebaseFirestore.instance.collection("sell_count_month");

  bool _historySearch = false;
  bool _getTime  =false;
  String _month = "?";
  String _year = "?";
  String _yearSearch = "??";
  String _monthSearch = "??";
  String _usdtBySearch = "--";
  String _dinarBySearch ="--";
  String _orderBySearch = "--";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            FutureBuilder<DocumentSnapshot>(
              future:_collectionReferenceAll.doc("sell_count").get() ,
              builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot){
                if(snapshot.hasError){
                  return Container(
                    child: Text("error"),
                  );
                }else{
                  if(snapshot.connectionState == ConnectionState.done){
                    return
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.rectangle,
                            border: Border.all(color: Colors.blue, width: 1)
                        ),
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height*0.35,
                        child: Column(
                          children: [
                            Text("?????????? ?????????? ??????????", textAlign: TextAlign.center,style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold
                            ),),
                            Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.rectangle,
                                  border: Border.all(color: Colors.blue, width: 1)
                              ),
                              width: MediaQuery.of(context).size.width*0.92,
                              height: MediaQuery.of(context).size.height*0.1,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Container(
                                    alignment: Alignment.center,
                                    width: MediaQuery.of(context).size.width*0.3,
                                    height: MediaQuery.of(context).size.height*0.095,
                                    child: Text(snapshot.data!["all_sell_orders"]),
                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    width: MediaQuery.of(context).size.width*0.6,
                                    height: MediaQuery.of(context).size.height*0.095,
                                    child: Text("?????? ?????????? ????????????"),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.rectangle,
                                  border: Border.all(color: Colors.blue, width: 1)
                              ),
                              width: MediaQuery.of(context).size.width*0.92,
                              height: MediaQuery.of(context).size.height*0.1,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Container(
                                    alignment: Alignment.center,
                                    width: MediaQuery.of(context).size.width*0.3,
                                    height: MediaQuery.of(context).size.height*0.095,
                                    child: Text(snapshot.data!["all_sell_dinar"]),
                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    width: MediaQuery.of(context).size.width*0.6,
                                    height: MediaQuery.of(context).size.height*0.095,
                                    child: Text("?????????????? ?????????? ??????????  "),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.rectangle,
                                  border: Border.all(color: Colors.blue, width: 1)
                              ),
                              width: MediaQuery.of(context).size.width*0.92,
                              height: MediaQuery.of(context).size.height*0.1,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Container(
                                    alignment: Alignment.center,
                                    width: MediaQuery.of(context).size.width*0.3,
                                    height: MediaQuery.of(context).size.height*0.095,
                                    child: Text(snapshot.data!["all_sell_usdt"]),
                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    width: MediaQuery.of(context).size.width*0.6,
                                    height: MediaQuery.of(context).size.height*0.095,
                                    child: Text("USDT ?????????????? ??????????"),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                  }
                  else{
                    return _drawLoadingScreen();
                  }
                }
              },
            ),
            (_getTime )?
            FutureBuilder(
              future: _collectionReferenceMonth.doc(_month+_year).get(),
              builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot){
                if(snapshot.hasError){
                  return Container(
                    child: Text("error"),
                  );
                } else if(! snapshot.hasData){
                  Fluttertoast.showToast(msg: "444444");
                  return Container(
                    width: 50,
                     alignment: Alignment.centerRight,
                    child: Text("???? ???????? ????????????"),
                  );
                }else{
                  if(snapshot.connectionState == ConnectionState.done){
                    return   Expanded(child: Container(
                        margin: EdgeInsets.only(right: 4, left: 4),
                        color: Colors.white,
                        child: ListView(
                          scrollDirection: Axis.vertical,
                          children: [


                            Container(
                              alignment: Alignment.center,
                              height: 100,
                              width: MediaQuery.of(context).size.width,
                              color: Colors.blue,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Text(_month,textAlign: TextAlign.center,style:
                                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),),
                                  Text(" /???????????? ?????????? ????????????", textAlign: TextAlign.center,style:
                                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),),
                                ],
                              ),
                            ),
                            Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.rectangle,
                                  border: Border.all(color: Colors.blue, width: 1)
                              ),
                              width: MediaQuery.of(context).size.width*0.92,
                              height: 100,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Container(
                                    alignment: Alignment.center,
                                    width: MediaQuery.of(context).size.width*0.3,
                                    height: 98,
                                    child: Text(snapshot.data!["all_sell_orders"]),
                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    width: MediaQuery.of(context).size.width*0.6,
                                    height: 98,
                                    child: Text("?????? ???????????? ????????????"),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.rectangle,
                                  border: Border.all(color: Colors.blue, width: 1)
                              ),
                              width: MediaQuery.of(context).size.width*0.92,
                              height: 100,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Container(
                                    alignment: Alignment.center,
                                    width: MediaQuery.of(context).size.width*0.3,
                                    height: 98,
                                    child: Text(snapshot.data!["all_sell_dinar"]),
                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    width: MediaQuery.of(context).size.width*0.6,
                                    height: 98,
                                    child: Text(" ?????????????? ?????????? ??????????"),
                                  ),
                                ],
                              ),
                            ),

                            Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.rectangle,
                                  border: Border.all(color: Colors.blue, width: 1)
                              ),
                              width: MediaQuery.of(context).size.width*0.92,
                              height: 100,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Container(
                                    alignment: Alignment.center,
                                    width: MediaQuery.of(context).size.width*0.3,
                                    height: 98,
                                    child: Text(snapshot.data!["all_sell_usdt"]),
                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    width: MediaQuery.of(context).size.width*0.6,
                                    height: 98,
                                    child: Text("USDT ?????????????? ??????????"),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: Colors.blue,
                                    shape: BoxShape.rectangle,
                                    border: Border.all(color: Colors.blue, width: 1)
                                ),
                                width: MediaQuery.of(context).size.width*0.92,
                                height: 100,
                                child:  Text("history", style: TextStyle(color: Colors.white
                                    ,fontSize: 17, fontWeight: FontWeight.bold),)
                            ),
                            (_historySearch)?_drawLoadingScreen() :
                            _drawHistoryWidget(context)
                          ],
                        )));

                  }
                  else{
                    return _drawLoadingScreen();
                  }
                }
              },
            ) : _drawLoadingScreen()
          ],
        ),
      ),

    );
  }
  @override
  void initState() {
    super.initState();
    _getTimeMethod();
  }
  Future<void> _getTimeMethod()async{
    await NTP.now().then((value){
      _month = value.month.toString();
      _year =value.year.toString();
      setState(() {
        _getTime = true;

      });
    });
  }

  Widget _drawHistoryWidget(BuildContext context){
    return Container(
      decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          border: Border.all(color: Colors.blue, width: 1)
      ),
      height: 450,
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.rectangle,
                border: Border.all(color: Colors.blue, width: 1)
            ),
            width: MediaQuery.of(context).size.width*0.92,
            height: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                InkWell(
                  child: Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        border: Border.all(color: Colors.blue, width: 1)
                    ),
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width*0.285,
                    height: 50,
                    child: Text(_yearSearch),
                  ),
                  onTap: (){
                    showDialog(context: context, builder: ( context){
                      return Dialog(
                        child: Container(

                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width*0.5,
                          height: MediaQuery.of(context).size.height*0.6,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [

                              Container(

                                  color: Colors.red,
                                  height: MediaQuery.of(context).size.height*0.05,
                                  width: MediaQuery.of(context).size.width*0.5,
                                  child:
                                  InkWell(
                                    onTap: (){
                                      Navigator.pop(context);
                                    },
                                    child: Icon(Icons.arrow_back_ios, color: Colors.white,size: 30,),
                                  )
                              ),
                              InkWell(
                                child: Container(
                                  alignment: Alignment.center,
                                  child: Text("2022",style: TextStyle(color: Colors.white,
                                      fontWeight: FontWeight.bold, fontSize: 25),),
                                  color: Colors.blue,
                                  height: MediaQuery.of(context).size.height*0.05,
                                  width: MediaQuery.of(context).size.width*0.5,),
                                onTap: (){
                                  setState(() {
                                    _yearSearch = "2022";
                                  });
                                  Navigator.pop(context);
                                },
                              ),
                              InkWell(
                                child: Container(
                                  alignment: Alignment.center,
                                  child: Text("2021",style: TextStyle(color: Colors.white,
                                      fontWeight: FontWeight.bold, fontSize: 25),),
                                  color: Colors.blue,

                                  height: MediaQuery.of(context).size.height*0.05,
                                  width: MediaQuery.of(context).size.width*0.5,),
                                onTap: (){
                                  setState(() {
                                    _yearSearch = "2021";
                                  });
                                  Navigator.pop(context);

                                },
                              ),
                              SizedBox(height: 1,),



                            ],
                          ),
                        ),
                      );
                    });
                  },
                ),
                InkWell(
                  child: Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        border: Border.all(color: Colors.blue, width: 1)
                    ),
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width*0.285,
                    height: 50,
                    child: Text(_monthSearch),
                  ),
                  onTap: (){
                    showDialog(context: context, builder: ( context){
                      return Dialog(
                        child: Container(

                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width*0.5,
                          height: MediaQuery.of(context).size.height*0.6,
                          child: ListView(
                            scrollDirection: Axis.vertical,
                            children: [

                              Container(

                                  color: Colors.red,
                                  height: MediaQuery.of(context).size.height*0.05,
                                  width: MediaQuery.of(context).size.width*0.5,
                                  child:
                                  InkWell(
                                    onTap: (){
                                      Navigator.pop(context);
                                    },
                                    child: Icon(Icons.arrow_back_ios, color: Colors.white,size: 30,),
                                  )
                              ),
                              InkWell(
                                child: Container(
                                  alignment: Alignment.center,
                                  child: Text("1",style: TextStyle(color: Colors.white,
                                      fontWeight: FontWeight.bold, fontSize: 25),),
                                  color: Colors.blue,

                                  height: MediaQuery.of(context).size.height*0.05,
                                  width: MediaQuery.of(context).size.width*0.5,),
                                onTap: (){
                                  setState(() {
                                    _monthSearch = "1";
                                  });
                                  Navigator.pop(context);

                                },
                              ),
                              InkWell(
                                child: Container(
                                  alignment: Alignment.center,
                                  child: Text("2",style: TextStyle(color: Colors.white,
                                      fontWeight: FontWeight.bold, fontSize: 25),),
                                  color: Colors.blue,

                                  height: MediaQuery.of(context).size.height*0.05,
                                  width: MediaQuery.of(context).size.width*0.5,),
                                onTap: (){
                                  setState(() {
                                    _monthSearch = "2";
                                  });
                                  Navigator.pop(context);

                                },
                              ),
                              InkWell(
                                child: Container(
                                  alignment: Alignment.center,
                                  child: Text("3",style: TextStyle(color: Colors.white,
                                      fontWeight: FontWeight.bold, fontSize: 25),),
                                  color: Colors.blue,

                                  height: MediaQuery.of(context).size.height*0.05,
                                  width: MediaQuery.of(context).size.width*0.5,),
                                onTap: (){
                                  setState(() {
                                    _monthSearch = "3";
                                  });
                                  Navigator.pop(context);

                                },
                              ),
                              InkWell(
                                child: Container(
                                  alignment: Alignment.center,
                                  child: Text("4",style: TextStyle(color: Colors.white,
                                      fontWeight: FontWeight.bold, fontSize: 25),),
                                  color: Colors.blue,

                                  height: MediaQuery.of(context).size.height*0.05,
                                  width: MediaQuery.of(context).size.width*0.5,),
                                onTap: (){
                                  setState(() {
                                    _monthSearch = "4";
                                  });
                                  Navigator.pop(context);

                                },
                              ),
                              InkWell(
                                child: Container(
                                  alignment: Alignment.center,
                                  child: Text("5",style: TextStyle(color: Colors.white,
                                      fontWeight: FontWeight.bold, fontSize: 25),),
                                  color: Colors.blue,

                                  height: MediaQuery.of(context).size.height*0.05,
                                  width: MediaQuery.of(context).size.width*0.5,),
                                onTap: (){
                                  setState(() {
                                    _monthSearch = "5";
                                  });
                                  Navigator.pop(context);

                                },
                              ),
                              InkWell(
                                child: Container(
                                  alignment: Alignment.center,
                                  child: Text("6",style: TextStyle(color: Colors.white,
                                      fontWeight: FontWeight.bold, fontSize: 25),),
                                  color: Colors.blue,

                                  height: MediaQuery.of(context).size.height*0.05,
                                  width: MediaQuery.of(context).size.width*0.5,),
                                onTap: (){
                                  setState(() {
                                    _monthSearch = "6";
                                  });
                                  Navigator.pop(context);

                                },
                              ),
                              InkWell(
                                child: Container(
                                  alignment: Alignment.center,
                                  child: Text("7",style: TextStyle(color: Colors.white,
                                      fontWeight: FontWeight.bold, fontSize: 25),),
                                  color: Colors.blue,

                                  height: MediaQuery.of(context).size.height*0.05,
                                  width: MediaQuery.of(context).size.width*0.5,),
                                onTap: (){
                                  setState(() {
                                    _monthSearch = "7";
                                  });
                                  Navigator.pop(context);

                                },
                              ),
                              InkWell(
                                child: Container(
                                  alignment: Alignment.center,
                                  child: Text("8",style: TextStyle(color: Colors.white,
                                      fontWeight: FontWeight.bold, fontSize: 25),),
                                  color: Colors.blue,

                                  height: MediaQuery.of(context).size.height*0.05,
                                  width: MediaQuery.of(context).size.width*0.5,),
                                onTap: (){
                                  setState(() {
                                    _monthSearch = "8";
                                  });
                                  Navigator.pop(context);

                                },
                              ),
                              InkWell(
                                child: Container(
                                  alignment: Alignment.center,
                                  child: Text("9",style: TextStyle(color: Colors.white,
                                      fontWeight: FontWeight.bold, fontSize: 25),),
                                  color: Colors.blue,

                                  height: MediaQuery.of(context).size.height*0.05,
                                  width: MediaQuery.of(context).size.width*0.5,),
                                onTap: (){
                                  setState(() {
                                    _monthSearch = "9";
                                  });
                                  Navigator.pop(context);

                                },
                              ),
                              InkWell(
                                child: Container(
                                  alignment: Alignment.center,
                                  child: Text("10",style: TextStyle(color: Colors.white,
                                      fontWeight: FontWeight.bold, fontSize: 25),),
                                  color: Colors.blue,

                                  height: MediaQuery.of(context).size.height*0.05,
                                  width: MediaQuery.of(context).size.width*0.5,),
                                onTap: (){
                                  setState(() {
                                    _monthSearch = "10";
                                  });
                                  Navigator.pop(context);

                                },
                              ),
                              InkWell(
                                child: Container(
                                  alignment: Alignment.center,
                                  child: Text("11",style: TextStyle(color: Colors.white,
                                      fontWeight: FontWeight.bold, fontSize: 25),),
                                  color: Colors.blue,

                                  height: MediaQuery.of(context).size.height*0.05,
                                  width: MediaQuery.of(context).size.width*0.5,),
                                onTap: (){
                                  setState(() {
                                    _monthSearch = "11";
                                  });
                                  Navigator.pop(context);

                                },
                              ),
                              InkWell(
                                child: Container(
                                  alignment: Alignment.center,
                                  child: Text("12",style: TextStyle(color: Colors.white,
                                      fontWeight: FontWeight.bold, fontSize: 25),),
                                  color: Colors.blue,

                                  height: MediaQuery.of(context).size.height*0.05,
                                  width: MediaQuery.of(context).size.width*0.5,),
                                onTap: (){
                                  setState(() {
                                    _monthSearch = "12";
                                  });
                                  Navigator.pop(context);

                                },
                              ),

                            ],
                          ),
                        ),
                      );
                    });
                  },
                ),
                InkWell(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.rectangle,
                    ),
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width*0.285,
                    height: 50,
                    child: Icon(Icons.search,color: Colors.white, size: 25, ),
                  ),
                  onTap: (){

                    if(_monthSearch == "??" || _yearSearch == "??"){
                      Fluttertoast.showToast(msg: "?????????? ???????? ?????????? ????????????  ");

                    }else{
                      _updateStateSearch();

                    }
                  },
                ),

              ],
            ),
          ),
          Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.rectangle,
                border: Border.all(color: Colors.blue, width: 1)
            ),
            width: MediaQuery.of(context).size.width*0.92,
            height: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width*0.3,
                  height: 98,
                  child: Text(_orderBySearch),
                ),
                Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width*0.6,
                  height: 98,
                  child: Text("orders ?????????????? ??????????"),
                ),
              ],
            ),
          ),

          Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.rectangle,
                border: Border.all(color: Colors.blue, width: 1)
            ),
            width: MediaQuery.of(context).size.width*0.92,
            height: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width*0.3,
                  height: 98,
                  child: Text(_dinarBySearch),
                ),
                Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width*0.6,
                  height: 98,
                  child: Text("dinar ?????????????? ??????????"),
                ),
              ],
            ),
          ),
          Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.rectangle,
                border: Border.all(color: Colors.blue, width: 1)
            ),
            width: MediaQuery.of(context).size.width*0.92,
            height: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width*0.3,
                  height: 98,
                  child: Text(_usdtBySearch),
                ),
                Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width*0.6,
                  height: 98,
                  child: Text("USDT ?????????????? ??????????"),
                ),
              ],
            ),
          ),

        ],
      ),
    );
  }
  Widget _drawLoadingScreen(){
    return Container(
      width: MediaQuery.of(context).size.width*0.5,
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

  Future<void> _updateStateSearch()async {
    setState(() {
      _historySearch = true;
    });
    String _time = _monthSearch + _yearSearch ;
    await _collectionReferenceMonth.doc(_time).get().then((value) {
      if(value.exists){
        setState(() {
          _dinarBySearch = value["all_sell_dinar"];
          _usdtBySearch = value["all_sell_usdt"];
          _orderBySearch = value["all_sell_orders"];
          _historySearch = false;
        });
      }
      else{
        setState(() {
          _dinarBySearch="--";
          _usdtBySearch="--";
          _orderBySearch="--";
          _historySearch= false;
          Fluttertoast.showToast(msg: "the history is empty");
        });
      }
    });
    setState(() {
      _historySearch = false;
    });
  }

}


