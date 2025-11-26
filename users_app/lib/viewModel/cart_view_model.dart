import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:users_app/global/global_instances.dart';
import 'package:users_app/global/global_vars.dart';
import 'package:users_app/provider/cart_item_counter.dart';

class CartViewModel{

  separateItemIDs()
  {
    List<String> separateItemIDsList=[], defaultItemList=[];
    int i=0;

    //defaultItemList = sharedPreferences!.getStringList("userCart")!;
    defaultItemList = sharedPreferences?.getStringList("userCart") ?? [];

    for(i; i<defaultItemList.length; i++)
    {
      String item = defaultItemList[i].toString();
      print("\nThis is itemID : quantityNumber = " + item);
      var pos = item.lastIndexOf(":");

      String getItemId = (pos != -1) ? item.substring(0, pos) : item;

      print("\nThis is itemID now = " + getItemId);

      separateItemIDsList.add(getItemId);
    }

    print("\nThis is Item list now = ");
    print(separateItemIDsList);
    return separateItemIDsList;

  }

  // List<String> separateItemIDs() {
  //   // If sharedPreferences is null OR key not found, return empty list
  //   List<String> defaultItemList = sharedPreferences?.getStringList("userCart") ?? [];
  //
  //   // Remove invalid entries
  //   defaultItemList.removeWhere((item) => !item.contains(":"));
  //
  //   List<String> separateItemIDList = [];
  //
  //   for (String item in defaultItemList) {
  //     List<String> parts = item.split(":");
  //     if (parts.isNotEmpty) {
  //       separateItemIDList.add(parts[0]); // itemID
  //     }
  //   }
  //
  //   return separateItemIDList;
  // }


  addItemToCart(String? itemId, BuildContext context,int quantityNumber){
    List<String>? tempList = sharedPreferences!.getStringList("userCart");
    tempList!.add(itemId! + ":" + quantityNumber.toString());
    FirebaseFirestore.instance.collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update(
        {
          "userCart": tempList,
        }).then((value)
    {
      sharedPreferences!.setStringList("userCart",tempList);

      commonViewModel.showSnackBar("Item Added Successfully to Cart.", context);

      //update the badge
      Provider.of<CartItemCounter>(context,listen: false).showCartListItemsNumber();

    });
  }

  getCartItems()
  {
    return FirebaseFirestore.instance
        .collection("items")
        .where("itemID", whereIn: separateItemIDs())// if its the item which in the user cart list
        .orderBy("publishedDateTime", descending: true)
        .snapshots();
  }

  // Inside your CartViewModel class

  // Stream<QuerySnapshot> getCartItems() {
  //   List<String> separateItemIDsList = separateItemIDs();
  //
  //   // If the list is empty, return an empty stream to avoid the crash
  //   if (separateItemIDsList.isEmpty) {
  //     return const Stream.empty();
  //   }
  //
  //   // Otherwise, proceed with the query
  //   return FirebaseFirestore.instance
  //       .collection("items")
  //       .where("itemID", whereIn: separateItemIDsList)
  //       .orderBy("publishedDateTime", descending: true)
  //       .snapshots();
  // }

  separateItemQuantities()
  {
    List<int> separateItemQuantityList=[];
    List<String> defaultItemList=[];
    int i=1;

    // defaultItemList = sharedPreferences!.getStringList("userCart")!;
    defaultItemList = sharedPreferences?.getStringList("userCart") ?? [];

    for(i; i<defaultItemList.length; i++)
    {

      String item = defaultItemList[i].toString();

      List<String> listItemCharacters = item.split(":").toList();

      var quanNumber = int.parse(listItemCharacters[1].toString());

      separateItemQuantityList.add(quanNumber);
    }

    return separateItemQuantityList;
  }

  // List<int> separateItemQuantities() {
  //   List<String> defaultItemList = sharedPreferences?.getStringList("userCart") ?? [];
  //   defaultItemList.removeWhere((item) => !item.contains(":"));
  //
  //   List<int> separateItemQuantityList = [];
  //
  //   for (String item in defaultItemList) {
  //     List<String> parts = item.split(":");
  //     if (parts.length > 1) {
  //       int qty = int.tryParse(parts[1]) ?? 1; // fallback to 1
  //       separateItemQuantityList.add(qty);
  //     }
  //   }
  //
  //   return separateItemQuantityList;
  // }


  clearCartNow(BuildContext context) async
  {
    sharedPreferences!.setStringList("userCart", ["garbageValue"]);
    List<String>? emptyList = sharedPreferences!.getStringList("userCart");

    await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update(
        {
          "userCart": emptyList,
        }).then((value)
    {
      sharedPreferences!.setStringList("userCart", emptyList!);
      Provider.of<CartItemCounter>(context, listen: false).showCartListItemsNumber();
    });

  }
}