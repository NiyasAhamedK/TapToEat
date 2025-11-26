import 'package:cloud_firestore/cloud_firestore.dart';

class MenuViewModel{
  retrieveMenusFromFirestore(String sellerUID){
     return FirebaseFirestore.instance
        .collection("sellers")
        .doc(sellerUID)
        .collection("menus")
        .orderBy("publishedDateTime",descending: true)
        .snapshots();

  }
}