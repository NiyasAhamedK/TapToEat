import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../global/global_instances.dart';
import '../../model/address.dart';
import '../widgets/shipment_address_ui_design.dart';
import '../widgets/status_banner.dart';

class OrderDetailScreen extends StatefulWidget
{
  String? orderID;

  OrderDetailScreen({super.key, this.orderID,});

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}



class _OrderDetailScreenState extends State<OrderDetailScreen>
{
  String orderStatus = "";
  String orderByUser = "";
  String  sellerId = "";

  getOrderInfo(){
    FirebaseFirestore.instance
        .collection("orders")
        .doc(widget.orderID)
        .get().then((snapshot){
          orderStatus = snapshot.data()!["status"].toString();
          orderByUser = snapshot.data()!["orderBy"].toString();
          sellerId = snapshot.data()!["sellerUID"].toString();
    });
  }

  @override
  void initState(){
    super.initState();
     getOrderInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: FutureBuilder<DocumentSnapshot>(
          future: orderViewModel.getSpecificOrder(widget.orderID.toString()),
          builder: (c, snapshot)
          {
            Map? dataMap;

            if(snapshot.hasData)
            {
              dataMap = snapshot.data!.data() as Map<String, dynamic>;
              orderStatus = dataMap["status"].toString();
            }

            return snapshot.hasData
                ? Column(
                    children: [
                      StatusBanner(
                        status: dataMap!["isSuccess"],
                        orderStatus: orderStatus,
                      ),

                      const SizedBox(
                        height: 10.0,
                      ),

                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "₹ ${dataMap["totalAmount"]}",
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Order Id = " + widget.orderID!,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Order at: ${DateFormat('dd MMMM, yyyy - hh:mm aa')
                              .format(DateTime.fromMillisecondsSinceEpoch(int.parse(dataMap["orderTime"]))
                          )}",
                          style: const TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      ),

                      const Divider(thickness: 4,),
                          orderStatus=="ended"
                              ? Image.asset("images/success.jpg")
                              : Image.asset("images/confirm_pick.png"),

                      const Divider(thickness: 4,),
                      FutureBuilder<DocumentSnapshot>(
                        future: orderViewModel.getShipmentAddress(dataMap["addressID"],dataMap["orderBy"]),
                        builder: (c, snapshotAddress){

                          return snapshotAddress.hasData
                              ? ShipmentAddressUIDesign(
                                model: Address.fromJson(
                                  snapshotAddress.data!.data() as Map<String, dynamic>
                                ),
                                  orderStatus: orderStatus,
                                  orderId: widget.orderID,
                                  sellerId: sellerId,
                                  orderByUser: orderByUser,
                          )
                              : Center(
                                  child: CircularProgressIndicator(),
                          );
                        },


                      ),



                    ],
                  )
                : Center(child: CircularProgressIndicator(),);
          },
        ),
      ),
    );
  }
}
