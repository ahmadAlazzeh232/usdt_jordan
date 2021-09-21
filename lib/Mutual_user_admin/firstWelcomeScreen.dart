import 'package:flutter/material.dart';
import 'package:usdt_jordan/Authentication/sign_up_screen.dart';
import 'package:usdt_jordan/Utilities/AppText.dart';
import 'package:usdt_jordan/Utilities/MyBackgroundsColors.dart';
import 'package:usdt_jordan/Utilities/generalStyle.dart';

class FirstWelcomeScreen extends StatefulWidget {
  const FirstWelcomeScreen({Key? key}) : super(key: key);

  @override
  _FirstWelcomeScreenState createState() => _FirstWelcomeScreenState();
}

class _FirstWelcomeScreenState extends State<FirstWelcomeScreen> with
SingleTickerProviderStateMixin{
 late TabController _tabController ;
  @override
  void initState() {
   super.initState();
   _tabController = TabController(length: 2, vsync:this );

  }


 @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
//
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyBackGrounsColors.appBarColor(),
        title: Text("USDT", style: Generalstyle.appBarTextImportant(),),
        centerTitle: true,
        bottom:TabBar(

          tabs: [
            Tab(text: "welcome",),
            Tab(text:"sign Up")
          ],
          controller: _tabController,
        ) ,
      ),
      body: TabBarView(

        controller: _tabController,
        children: [
          _drawFirstPage(),
          _darwThirdScreen()
        ],
      ),
    );
  }

 Widget _drawFirstPage() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height:  MediaQuery.of(context).size.height,
      color: MyBackGrounsColors.appBodyColor(),
      child: Stack(
        children: [
          SizedBox(
           width: MediaQuery.of(context).size.width,
           height: MediaQuery.of(context).size.height,
           child: Image(image: ExactAssetImage("assets/images/Usdt_logo.png"),fit:BoxFit.cover,),
         ),

        Align(
            alignment: Alignment.topCenter,
            child: Text(welcomeText,style: Generalstyle.bodyTextImportant(),textDirection: TextDirection.rtl,)),

          Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 30,bottom: 50),
                child: ElevatedButton(
           style: Generalstyle.appButtonStyle(),

                  child: Text("التالي",style: Generalstyle.bodyTextStyleBold(),),
                   onPressed:  (){ return
                     setState(() {

                       _tabController.index= 1;
                     });
                   },)

              ),
              )
        ],
      ),

    );
 }

 Widget _darwThirdScreen() {
   return SignUpScreen();
 }

 Widget _drawSecondPage() {
   return Container(
     width: MediaQuery.of(context).size.width,
     height:  MediaQuery.of(context).size.height,
     color: MyBackGrounsColors.appButtonsColor(),

   );
 }


}
