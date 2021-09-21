import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:usdt_jordan/Admin/Adm_history_orders/accepted_orders_screen.dart';
import 'package:usdt_jordan/Admin/Adm_history_orders/deleted_orders_screen.dart';
import 'package:usdt_jordan/Admin/Buying_orders/Buying_orders_screen.dart';
import 'package:usdt_jordan/Admin/Selling_orders/Selling_orders_screen.dart';
import 'package:usdt_jordan/Admin/admin_counter_all_done/counter_all_done_buy.dart';
import 'package:usdt_jordan/Admin/admin_counter_all_done/counter_all_done_sell.dart';
import 'package:usdt_jordan/Admin/admin_drawer/drawer.dart';
import 'package:usdt_jordan/Admin/users_page/usersPage.dart';

class AdmPageView extends StatefulWidget {
  const AdmPageView({Key? key}) : super(key: key);

  @override
  _AdmPageViewState createState() => _AdmPageViewState();
}

class _AdmPageViewState extends State<AdmPageView>
    with SingleTickerProviderStateMixin{
 late TabController _tabController ;
 @override
  void initState() {
   super.initState();
   String? _email = FirebaseAuth.instance.currentUser!.uid;
   print("email is: $_email");
   _tabController = TabController(length: 7, vsync: this);
 _subscribe();
 _subscribeOrders();
 String? _id = FirebaseAuth.instance.currentUser!.uid;
  print("admin $_id");
 }
 Future<void>  _subscribe()async{
     await FirebaseMessaging.instance.subscribeToTopic("admin").then((value){
     print("this is subscribeResult: ");
   });
 }
 Future<void>  _subscribeOrders()async{
   await FirebaseMessaging.instance.subscribeToTopic("admin_orders").then((value){
     print("this is subscribeResult: ");
   });
 }
  @override
  void dispose() {
   super.dispose();
   _tabController.dispose();
  } 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Icon(Icons.outbond_outlined, color: Colors.teal,size: 30,),
            Icon(Icons.input_sharp, color: Colors.red,size: 30,),
                Icon(Icons.person, color: Colors.teal,size: 30,),
             Icon(Icons.delete_forever,color: Colors.red,size: 30,)
            ,Icon(Icons.file_download_done,color: Colors.green,size: 30,),
            Icon(Icons.folder_shared_outlined, color: Colors.red, size: 30,)
            ,Icon(Icons.folder_shared_outlined, color: Colors.green, size: 30,)

          ],
        ),
      ),
      drawer: AdmNAvigator(),
      body: Container(
        child: TabBarView(
          controller: _tabController,

          children: [
            AdmBuyingOrdersScreen(),
            AdmSellingOrdersScreen(),
            UsersInAdminPage(),
            DeletedOrderAdmScreen(),
            AcceptedOrderAdminScreen(),
            AdmCounterAllBuyDone(),
            AdmCounterAllSellDone()
          ],
        ),
      ),
    );
  }

 
}
