import 'package:firebase_auth/firebase_auth.dart';
  import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:usdt_jordan/referal_code/genarateReferalCode.dart';

class AuthintecationController {

  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  CollectionReference _collectionReferenceReferel = FirebaseFirestore.instance.collection("referel_code");
  CollectionReference _collectionReference = FirebaseFirestore.instance.collection("usersInfo");
   CollectionReference _reference = FirebaseFirestore.instance.collection("all_chats");
  Future<User?> signIn(String email, String password) async{
     var user  =await _firebaseAuth.
     signInWithEmailAndPassword(email: email, password: password);
   var userrr = user.user;
   print("55555$userrr");
   return  userrr ;

 }
 Future<UserCredential> register(String email, String password) async{
  logOut();


  UserCredential  newUser = await  _firebaseAuth.createUserWithEmailAndPassword
    (email: email, password: password);
    print("555555$newUser ");

     
      return newUser ;
  }

   Future<void> saveDataOnSignUp(String name1,String name2, String password, String email, String number,
       String referel, String refrelVia)async {
     return
           await _collectionReference.doc(email).set(
     {
        'set_referel_code':referel,
       "first_nanme":name1,
       "full_name": name1 +" "+name2,
       "password": password,
       "email": email ,
       "number": number,
       'refrel_via': refrelVia


     }

   );
  }
  Future<void> saveReferal(  String referel, String email)async{

    return await _collectionReferenceReferel.doc(email).set({
      'referel': referel ,
      '#_sign_in': 0,
      '#_done_order':0
    });
  }
  Future<void> AddRederalRegisterDis(String writeCode)async{

    await _collectionReferenceReferel.where("referel",isEqualTo: writeCode).get().then((value){
      if(value.docs.length ==0){
        Fluttertoast.showToast(msg: "كود الدعوة اللي ادخلته غير موجود", toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER);
      }else{
        String _emailRegisterVia =  value.docs.first.id;
      }

    });
  }

  Future<void> logOut() async{
      await _firebaseAuth.signOut();
  }

  Future<void> UpdateSignUpNumber(String email)async{
      _collectionReferenceReferel.doc(email).get().then((value)async{
      int num_of_sign = value["#_sign_in"];
      await _collectionReferenceReferel.doc(email).update({
        "#_sign_in": num_of_sign +1
      });
    });
  }

}