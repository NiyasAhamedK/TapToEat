import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sellers_app/global/global_vars.dart';

class OrdersViewModel
{
  getNewOrders()
  {
    return FirebaseFirestore.instance
        .collection("orders")
        .where("status", isEqualTo: "normal")
        .where("sellerUID", isEqualTo: sharedPreferences!.getString("uid"))
        .snapshots();
  }

  separateItemIDsForOrder(orderIDs)
  {
    List<String> separateItemIDsList=[], defaultItemList=[];
    int i=0;

    //defaultItemList = sharedPreferences!.getStringList("userCart")!;
    //defaultItemList = sharedPreferences?.getStringList("userCart") ?? [];
    defaultItemList = List<String>.from(orderIDs);

    for(i; i<defaultItemList.length; i++)
    {
      String item = defaultItemList[i].toString();
      //print("\nThis is itemID : quantityNumber = " + item);
      var pos = item.lastIndexOf(":");

      String getItemId = (pos != -1) ? item.substring(0, pos) : item;

      //print("\nThis is itemID now = " + getItemId);

      separateItemIDsList.add(getItemId);
    }

    //print("\nThis is Item list now = ");
    //print(separateItemIDsList);
    return separateItemIDsList;
  }

  separateOrderItemQuatitiesForOrder(orderIDs) {
    List<String> separateItemQuantityList = [];
    List<String> defaultItemList = [];
    int i = 1;

    // defaultItemList = sharedPreferences!.getStringList("userCart")!;
    //defaultItemList = sharedPreferences?.getStringList("userCart") ?? [];
    defaultItemList = List<String>.from(orderIDs);


    for (i; i < defaultItemList.length; i++) {
      String item = defaultItemList[i].toString();

      List<String> listItemCharacters = item.split(":").toList();

      var quanNumber = int.parse(listItemCharacters[1].toString());

      separateItemQuantityList.add(quanNumber.toString());
    }
    return separateItemQuantityList;
  }

  getSpecificOrder(String orderID)
  {
    return FirebaseFirestore.instance
        .collection("orders")
        .doc(orderID)
        .get();
  }

  getShipmentAddress(String addressID, String orderByUser)
  {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(orderByUser)
        .collection("userAddress")
        .doc(addressID)
        .get();
  }
  retrieveOrdersHistory()
  {
    return FirebaseFirestore.instance
        .collection("orders")
        .where("sellerUID", isEqualTo: sharedPreferences!.getString("uid"))
        .where("status", isEqualTo: "ended")
        .orderBy("orderTime", descending: true)
        .snapshots();
  }
}