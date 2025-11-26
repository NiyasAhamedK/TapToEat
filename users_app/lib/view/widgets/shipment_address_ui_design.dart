import 'package:flutter/material.dart';
import 'package:users_app/model/address.dart';
import 'package:users_app/view/splashScreen/splash_screen.dart';
class ShipmentAddressUIDesign extends StatelessWidget {
  
  Address? model;
  ShipmentAddressUIDesign({super.key,this.model});

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

        Padding(
            padding: const EdgeInsets.all(10.0),
            child:InkWell(
              onTap:()
              {
                Navigator.push(context, MaterialPageRoute(builder: (context)=> const MySplashScreen()));

              },
              child: Container(
                color: Colors.green,
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
