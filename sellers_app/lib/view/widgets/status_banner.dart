import 'package:flutter/material.dart';

import '../mainScreens/home_screen.dart';



class StatusBanner extends StatelessWidget
{
  bool? status;
  String? orderStatus;

  StatusBanner({super.key, this.status, this.orderStatus,});

  @override
  Widget build(BuildContext context)
  {
    String? message;
    IconData? iconData;

    status! ? iconData = Icons.done : iconData = Icons.cancel;
    status! ? message = "Successful" : message = "Unsuccessful";

    return Container(
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          GestureDetector(
            onTap: ()
            {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const HomeScreen()));
            },
            child: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ),

          const SizedBox(
            width: 20,
          ),

          Text(
            orderStatus == "ended" ? "Parcel Deliverd $message" : "Order Placed $message",
            style: const TextStyle(
              color: Colors.white,
            ),
          ),

          const SizedBox(
            width: 5,
          ),

          CircleAvatar(
            radius: 8,
            backgroundColor: Colors.white,
            child: Center(
              child: Icon(
                iconData,
                color: Colors.green,
                size: 14,
              ),
            ),
          ),

        ],
      ),
    );
  }
}
