import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:riders_app/global/global_instances.dart';
import 'package:riders_app/global/global_vars.dart';

class ParcelPickingScreen extends StatefulWidget {
  String? purchaserId;
  String? sellerId;
  String? getOrderID;
  String? purchaserAddress;
  String? purchaserLat;
  String? purchaserLng;

  ParcelPickingScreen({
    super.key,
    this.purchaserId,
    this.sellerId,
    this.getOrderID,
    this.purchaserAddress,
    this.purchaserLat,
    this.purchaserLng,

  });

  @override
  State<ParcelPickingScreen> createState() => _ParcelPickingScreenState();
}

class _ParcelPickingScreenState extends State<ParcelPickingScreen> 
{
  double? sellerLat, sellerLng;

  getSellerData() async
  {
    await FirebaseFirestore.instance
        .collection("sellers")
        .doc(widget.sellerId)
        .get()
        .then((snapshot)
    {
      sellerLat = snapshot.data()!["latitude"];
      sellerLng = snapshot.data()!["longitude"];
    });
  }
  // getSellerData() async {
  //   await FirebaseFirestore.instance
  //       .collection("sellers")
  //       .doc(widget.sellerId)
  //       .get()
  //       .then((snapshot) {
  //     setState(() {
  //       sellerLat = double.tryParse(snapshot.data()!["latitude"].toString());
  //       sellerLng = double.tryParse(snapshot.data()!["longitude"].toString());
  //     });
  //   });
  // }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getSellerData();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "images/confirm1.png",
              width: 350,
            ),

            const SizedBox(height: 5),

            GestureDetector(
              onTap: () {
                //show location from rider current location towards seller location
                orderViewModel.launchMapFromSourceToDestination(
                    position!.latitude, 
                    position!.longitude, 
                    sellerLat,
                    sellerLng
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,

                // children: [
                //   Image.asset(
                //     'images/restaurant.png',
                //     width: 50,
                //   ),
                //   const SizedBox(width: 7),
                //   const Text(
                //     "Show Cafe/Restaurent Location",
                //     style: TextStyle(
                //         fontSize: 18,
                //         letterSpacing: 2,
                //         color: Colors.black),
                //   ),
                // ],
              ),
            ),
            const SizedBox(height: 40),
            Padding(
                padding: const EdgeInsets.all(10.0),
                child: Center(
                  child: InkWell(
                    onTap: () async
                    {
                      //rider location updated
                      String completeAddress = await commonViewModel.getCurrentLocation();
                      //confirmed-that rider has picked parcel from seller
                      orderViewModel.confirmParcelHasBeenPicked(
                        widget.getOrderID,
                        widget.sellerId,
                        widget.purchaserId,
                        widget.purchaserAddress,
                        widget.purchaserLat,
                        widget.purchaserLng,
                        completeAddress,
                        context,
                      );
                    },
                    child: Container(
                      color: Colors.black,
                      width: MediaQuery.of(context).size.width - 90,
                      height: 50,
                      child: const Center(
                        child: Text(
                          "Order has been Picked -Confirmed",
                          style: TextStyle(color: Colors.white,fontSize: 15.0),
                        ),
                      ),
                    ),
                  ),
                ),),
          ],
        ),
      ),
    );
  }
}
