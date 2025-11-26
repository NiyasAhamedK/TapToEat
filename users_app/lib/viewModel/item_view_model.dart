import 'package:cloud_firestore/cloud_firestore.dart';

class ItemViewModel
{
  retrieveItemsFromFirestore(String sellerUID,String menuID)
  {
    return FirebaseFirestore.instance
        .collection("sellers")
        .doc(sellerUID)
        .collection("menus")
        .doc(menuID)
        .collection("items")
        .orderBy("publishedDateTime",descending: true)
        .snapshots();

  }
}