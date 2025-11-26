// orders_view_holder.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:riders_app/view/mainScreens/parcel_delivering_screen.dart';
import 'package:riders_app/view/mainScreens/parcel_picking_screen.dart';
import 'package:url_launcher/url_launcher.dart';

import '../global/global_vars.dart';
import '../model/address.dart';


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

  retrieveNewOrders()
  {
    return FirebaseFirestore.instance
        .collection("orders")
        .where("status", isEqualTo: "normal")
        .orderBy("orderTime", descending: true)
        .snapshots();
  }

  retrieveOrdersPicked()
  {
    return FirebaseFirestore.instance
        .collection("orders")
        .where("riderUID", isEqualTo: sharedPreferences!.getString("uid"))
        .where("status", isEqualTo: "picking")
        .orderBy("orderTime", descending: true)
        .snapshots();
  }

  retrieveOrdersNotYetDelivered()
  {
    return FirebaseFirestore.instance
        .collection("orders")
        .where("riderUID", isEqualTo: sharedPreferences!.getString("uid"))
        .where("status", isEqualTo: "delivering")
        .orderBy("orderTime", descending: true)
        .snapshots();
  }

  retrieveOrdersHistory()
  {
    return FirebaseFirestore.instance
        .collection("orders")
        .where("riderUID", isEqualTo: sharedPreferences!.getString("uid"))
        .where("status", isEqualTo: "ended")
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
        .collection("orders")
        .doc(orderID)
        .get();
  }

  getShipmentAddress(String addressID, String orderByUserID)
  {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(orderByUserID)
        .collection("userAddress")
        .doc(addressID)
        .get();
  }
  confirmToDeliverParcel(orderId,sellerId,orderByUser,completeAddress,context, Address model) async
  {
    await FirebaseFirestore.instance
        .collection("orders")
        .doc(orderId)
        .update({
      "riderUID": sharedPreferences!.getString("uid"),
      "riderName": sharedPreferences!.getString("name"),
      "status": "picking",
      "lat": position!.latitude,
      "lng": position!.longitude,
      "address": completeAddress,
    }).then((value) {
      Navigator.push(context, MaterialPageRoute(builder: (c) =>
          ParcelPickingScreen(
            purchaserId: orderByUser,
            purchaserAddress: model.fullAddress,
            purchaserLat: model.lat.toString(),
            purchaserLng: model.lng.toString(),
            sellerId: sellerId,
            getOrderID: orderId,


          )));
      //send rider to parcel picking screen
    });
  }
  confirmParcelHasBeenPicked(getOrderId,sellerId,purchaserId,purchaserAddress,purchaserLat, purchaserLng,completeAddress,context) async{
    await FirebaseFirestore.instance
        .collection("orders")
        .doc(getOrderId)
        .update({
      "status": "delivering",
      "address": completeAddress,
      "lat": position!.latitude,
      "lng":position!.longitude,
    });
    //delivering
    Navigator.push(context, MaterialPageRoute(builder: (c) =>
        ParcelDeliveringScreen(
          purchaserId: purchaserId,
          purchaserAddress:purchaserAddress,
          purchaserLat: purchaserLat,
          purchaserLng: purchaserLng,
          sellerId: sellerId,
          getOrderID: getOrderId,


        )));
  }
  confirmParcelHasBeenDelivered(getOrderId,sellerId,purchaserId,purchaserAddress,purchaserLat, purchaserLng,completeAddress) async
  {
    String totalEarningsOfRider = ((double.parse(previousRiderEarnings)) + (double.parse(amountChardedPerDelivery))).toString();
    String totalEarningsOfSeller = ((double.parse(previousSellerEarnings)) + (double.parse(orderTotalAmount))).toString();

    await FirebaseFirestore.instance
        .collection("orders")
        .doc(getOrderId)
        .update({
      "status": "ended",
      "address": completeAddress,
      "lat": position!.latitude,
      "lng":position!.longitude,
      "deliveryAmount": amountChardedPerDelivery,
    });

    await FirebaseFirestore.instance
        .collection("riders")
        .doc(sharedPreferences!.getString("uid"))
        .update({
      "earning": totalEarningsOfRider,
    });

    await FirebaseFirestore.instance
        .collection("sellers")
        .doc(sellerId)
        .update({
      "earning":totalEarningsOfSeller,
    });

    await FirebaseFirestore.instance
        .collection("users")
        .doc(purchaserId)
        .collection("orders")
        .doc(getOrderId)
        .update({
      "status": "ended",
      "riderUID": sharedPreferences!.getString("uid"),
    });
  }

  launchMapFromSourceToDestination(sourceLat, sourceLng, destinationLat, destinationLng) async
  {
    String mapOptions =
    [
      'saddr=$sourceLat,$sourceLng',
      'daddr=$destinationLat,$destinationLng',
      'dir_action=navigate'
    ].join('&');

    final googleMapUrl = 'https://www.google.com/maps?$mapOptions';

    if(await launchUrl(Uri.parse(googleMapUrl)))
    {
      await launchUrl(Uri.parse(googleMapUrl));
    }
    else
    {
      throw "Could not open the google map.";
    }
  }



}