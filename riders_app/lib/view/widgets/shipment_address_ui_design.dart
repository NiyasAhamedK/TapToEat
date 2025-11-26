import 'package:flutter/material.dart';
import 'package:riders_app/global/global_instances.dart';

import '../../model/address.dart';


import '../splashScreen/splash_screen.dart';

class ShipmentAddressUIDesign extends StatelessWidget {
  
  Address? model;
  String? orderStatus;
  String? orderId;
  String? sellerId;
  String? orderByUser;

  ShipmentAddressUIDesign({super.key,this.model,this.orderStatus,this.orderId,this.sellerId,this.orderByUser});

  @override
  Widget build(BuildContext context) {
    return Column (
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(10.0),
        child: Text(
          'Shipping Details:',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        ),
        const SizedBox(
          height: 6.0,
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 90, vertical: 5),
          width: MediaQuery.of(context).size.width,
          child: Table(
            children: [

              TableRow(
                children: [
                  const Text(
                    "Name",
                    style: TextStyle(color: Colors.white),
                  ),
                  Text(model!.name!),
                ]
              ),
              TableRow(
                  children: [
                    const Text(
                      "Phone Number",
                      style: TextStyle(color: Colors.white),
                    ),
                    Text(model!.phoneNumber!),
                  ],
              ),

              TableRow(
                children: [
                  const Text(
                    "Building Name",
                    style: TextStyle(color: Colors.white),
                  ),
                  Text(model!.buildingName!),
                ],
              )


            ],
          ),
        ),
        const SizedBox(
          height: 20,
        ),


        orderStatus == "ended"
            ? Container()
            :  Padding(
          padding: const EdgeInsets.all(10.0),
          child:InkWell(
            onTap:() async
            {
              //rider location updated
              String completeAddress = await commonViewModel.getCurrentLocation();
              //confirm to deliver
              orderViewModel.confirmToDeliverParcel(orderId,
                  sellerId,
                  orderByUser,
                  completeAddress,
                  context,
                  model!);

            },
            child: Container(
              color: Colors.green,
              width: MediaQuery.of(context).size.width -40,
              height: 50,
              child: const Center(
                child: Text(
                  "Confirm - To Deliver this Parcel",
                  style: TextStyle(color: Colors.white, fontSize: 15.0),
                ),
              ),

            ),
          ),
        ),
        Padding(
            padding: const EdgeInsets.all(10.0),
            child:InkWell(
              onTap:()
              {
                Navigator.push(context, MaterialPageRoute(builder: (context)=> const MySplashScreen()));

              },
              child: Container(
                color: Colors.purple,
                width: MediaQuery.of(context).size.width -40,
                height: 50,
                child: const Center(
                  child: Text(
                    "Go Back",
                    style: TextStyle(color: Colors.white, fontSize: 15.0),
                  ),
                ),

              ),
            ),
        ),

        
      ],
    );
  }
}
