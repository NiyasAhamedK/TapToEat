// orders_view_holder.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:users_app/global/global_instances.dart';
import 'package:users_app/global/global_vars.dart';

class OrderViewModel
{


  saveOrderDetailsToDatabase(addressID, totalAmount, sellerUID, orderId) async
  {
    // Retrieve the list of product IDs correctly
    List<String> productIDsList = sharedPreferences!.getStringList("userCart") ?? [];

    Map<String, dynamic> orderData = {
      "addressID": addressID,
      "totalAmount": totalAmount,
      "orderBy": sharedPreferences!.getString("uid"),
      "productIDs": productIDsList, // Corrected line
      "paymentDetails": "Online Payment",
      "orderTime": orderId,
      "isSuccess": true,
      "sellerUID": sellerUID,
      "riderUID": "",
      "status": "normal",
      "orderId": orderId,
    };

    await writeOrderDetailsForUser(orderData);
    await writeOrderDetailsForSeller(orderData);

  }

  writeOrderDetailsForUser(Map<String, dynamic> dataMap) async
  {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(sharedPreferences!.getString("uid"))
        .collection("orders")
        .doc(dataMap["orderId"])
        .set(dataMap);
  }

  writeOrderDetailsForSeller(Map<String, dynamic> dataMap) async
  {
    await FirebaseFirestore.instance
        .collection("orders")
        .doc(dataMap["orderId"])
        .set(dataMap);

  }

  retrieveOrders()
  {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(sharedPreferences!.getString("uid"))
        .collection("orders")
        .where("status", isEqualTo: "normal")
        .orderBy("orderTime", descending: true)
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
        .collection("users")
        .doc(sharedPreferences!.getString("uid"))
        .collection("orders")
        .doc(orderID)
        .get();
  }

  getShipmentAddress(String addressID)
  {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(sharedPreferences!.getString("uid"))
        .collection("userAddress")
        .doc(addressID)
        .get();
  }
  retrieveOrdersHistory()
  {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(sharedPreferences!.getString("uid"))
        .collection("orders")
        .where("status", isEqualTo: "ended")
        .orderBy("orderTime", descending: true)
        .snapshots();
  }
}