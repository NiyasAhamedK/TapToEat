import 'package:flutter/material.dart';
import 'package:riders_app/view/splashScreen/splash_screen.dart';

import '../../global/global_instances.dart';
import '../../global/global_vars.dart';

class ParcelDeliveringScreen extends StatefulWidget {
  String? purchaserId;
  String? sellerId;
  String? getOrderID;
  String? purchaserAddress;
  String? purchaserLat;
  String? purchaserLng;
  ParcelDeliveringScreen({super.key,

    this.purchaserId,
    this.sellerId,
    this.getOrderID,
    this.purchaserAddress,
    this.purchaserLat,
    this.purchaserLng,
  });

  @override
  State<ParcelDeliveringScreen> createState() => _ParcelDeliveringScreenState();
}

class _ParcelDeliveringScreenState extends State<ParcelDeliveringScreen> {
  getUpdatedInfo() async{
    await commonViewModel.getRiderPreviousEarnings();
    await commonViewModel.getSellerPreviousEarnings(widget.sellerId.toString());
    await commonViewModel.getOrderTotalAmount(widget.getOrderID.toString());
  }

  @override
  void initState(){
    super.initState();
    getUpdatedInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          Image.asset("images/confirm2.png",
          ),
          const SizedBox(height: 5,),
          GestureDetector(
            onTap: ()
            {
              //show location from rider current location towards user location
              orderViewModel.launchMapFromSourceToDestination(
                  position!.latitude,
                  position!.longitude,
                  widget.purchaserLat,
                  widget.purchaserLng,
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
              //     "Show Delivery Drop-off Location",
              //     style: TextStyle(
              //         fontSize: 18,
              //         letterSpacing: 2,
              //         color: Colors.black),
              //   ),
              // ],
            ),
          ),



          const SizedBox(height: 40,),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Center(
              child: InkWell(
                onTap: () async
                {
                  //rider location updated
                  String completeAddress = await commonViewModel.getCurrentLocation();
                  //confirmed-order delivered
                  await orderViewModel.confirmParcelHasBeenDelivered(
                      widget.getOrderID,
                      widget.sellerId,
                      widget.purchaserId,
                      widget.purchaserAddress,
                      widget.purchaserLat,
                      widget.purchaserLng,
                      completeAddress,);
                  commonViewModel.showSnackBar("Order Status Updated to ended Successfully.", context);
                Navigator.push(context, MaterialPageRoute(builder: (c)=> const MySplashScreen()));
                  },
                child: Container(
                  color: Colors.black,
                  width: MediaQuery.of(context).size.width - 90,
                  height: 50,
                  child: const Center(
                    child: Text(
                      "Order has been Delivered -Confirmed",
                      style: TextStyle(color: Colors.white,fontSize: 15.0),
                    ),
                  ),
                ),
              ),
            ),),
        ],
      ),

    );
  }
}
