import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sellers_app/global/global_instances.dart';

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
  String sellerId = "";
  
  getOrderInfo() async
  {
    await FirebaseFirestore.instance
        .collection("orders")
        .doc(widget.orderID)
        .get()
        .then((snap)
    {
      orderStatus = snap.data()!["status"].toString();
      orderByUser = snap.data()!["orderBy"].toString();
      sellerId = snap.data()!["sellerUID"].toString();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getOrderInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: FutureBuilder<DocumentSnapshot>(
          future: ordersViewModel.getSpecificOrder(widget.orderID.toString()),
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
                          orderStatus != "ended"
                              ? Image.asset("images/packing.png")
                              : Image.asset("images/delivered.jpg"),

                      const Divider(thickness: 4,),
                      FutureBuilder<DocumentSnapshot>(
                        future: ordersViewModel.getShipmentAddress(dataMap["addressID"], orderByUser),
                        builder: (c, snapshotAddress){

                          return snapshotAddress.hasData
                              ? ShipmentAddressUIDesign(
                                orderStatus: orderStatus,
                                model: Address.fromJson(
                                  snapshotAddress.data!.data() as Map<String, dynamic>
                                ),
                          )
                              : const Center(
                                  child: CircularProgressIndicator(),
                          );
                        },


                      ),



                    ],
                  )
                : const Center(child: CircularProgressIndicator(),);
          },
        ),
      ),
    );
  }
}
