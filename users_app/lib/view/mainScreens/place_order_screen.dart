import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pay/pay.dart';
import 'package:users_app/global/global_instances.dart';
import 'package:users_app/global/global_vars.dart';
import 'package:users_app/paymentSystem/payment_config.dart';
import 'package:users_app/view/mainScreens/home_screen.dart';
import 'package:users_app/view/splashScreen/splash_screen.dart';

class PlaceOrderScreen extends StatefulWidget
{
  String? addressID;
  double? totalAmount;
  String? sellerUID;


  PlaceOrderScreen({super.key, this.addressID, this.totalAmount, this.sellerUID,});

  @override
  State<PlaceOrderScreen> createState() => _PlaceOrderScreenState();
}



class _PlaceOrderScreenState extends State<PlaceOrderScreen>
{
  String orderId = DateTime.now().microsecondsSinceEpoch.toString();

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          Image.asset("images/pay_now.png"),

          const SizedBox(height: 30,),

          paymentResult != ""
              ?
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
            ),
            onPressed: ()
            {
              setState(() {
                paymentResult = "";
                orderId = "";
              });

              Navigator.push(context, MaterialPageRoute(builder: (context) => const MySplashScreen()));
              commonViewModel.showSnackBar("Congratulation, Order has been placed successfully.", context);
            },
            child: const Text(
                "Order Placed Successfully, OK"
            ),
          )
              : Platform.isIOS
              ? ApplePayButton(
            paymentConfiguration: PaymentConfiguration.fromJsonString(defaultApplePay),
            paymentItems: [
              PaymentItem(
                label: 'Total',
                amount: widget.totalAmount.toString(),
                status: PaymentItemStatus.final_price,
              ),
            ],
            style: ApplePayButtonStyle.black,
            width: double.infinity,
            height: 50,
            type: ApplePayButtonType.buy,
            margin: const EdgeInsets.only(top: 15.0),
            onPaymentResult: (result) async
            {
              print("Payment Result = $result");

              setState(() {
                paymentResult = result.toString();
              });

              //save order details to DB
              await orderViewModel.saveOrderDetailsToDatabase(
                widget.addressID,
                widget.totalAmount,
                widget.sellerUID,
                  orderId,
              );
            },
            loadingIndicator: const Center(
              child: CircularProgressIndicator(color: Colors.green,),
            ),
          )
              : GooglePayButton(
            paymentConfiguration: PaymentConfiguration.fromJsonString(defaultGooglePay),
            paymentItems:  [
              PaymentItem(
                label: 'Total',
                amount: widget.totalAmount.toString(),
                status: PaymentItemStatus.final_price,
              ),
            ],
            type: GooglePayButtonType.pay,
            margin: const EdgeInsets.only(top: 15.0),
            onPaymentResult: (result) async
            {
              print("Payment Result = $result");

              setState(() {
                paymentResult = result.toString();
              });

              //save order details to DB
              await orderViewModel.saveOrderDetailsToDatabase(
                widget.addressID,
                widget.totalAmount,
                widget.sellerUID,
                  orderId,
              );
            },
            loadingIndicator: const Center(
              child: CircularProgressIndicator(color: Colors.green,),
            ),
          ),

        ],
      ),
    );
  }
}

