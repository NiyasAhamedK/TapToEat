import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../global/global_instances.dart';
import '../widgets/my_appbar.dart';
import '../widgets/order_card_ui_design.dart';


class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}


class _HistoryScreenState extends State<HistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppbar(titleMsg: "History", showBackButton: true),
      body: StreamBuilder<QuerySnapshot>(
        stream: orderViewModel.retrieveOrdersHistory(),
        builder: (c, snapshot)
        {
          return snapshot.hasData
              ? ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (c, index)
            {
              // 1. EXTRACT THE ORDER DATA (Map)
              Map<String, dynamic> orderData = snapshot.data!.docs[index].data() as Map<String, dynamic>;

              // 2. EXTRACT THE SELLER UID (CRITICAL STEP)
              String sellerUID = orderData["sellerUID"] ?? "";


              return FutureBuilder<QuerySnapshot>(
                future: FirebaseFirestore.instance
                    .collection("items")
                    .where("itemID", whereIn: orderViewModel.separateItemIDsForOrder(orderData["productIDs"]))
                    .where("orderBy", whereIn: orderData["uid"])
                    .orderBy("publishedDateTime", descending: true)
                    .get(),
                builder: (c, snap)
                {
                  return snap.hasData
                      ? Card(
                    child: OrderCardUIDesign(
                      itemCount: snap.data!.docs.length,
                      data: snap.data!.docs,
                      orderID: snapshot.data!.docs[index].id,
                      seperateQuantitiesList: orderViewModel.separateOrderItemQuatitiesForOrder(orderData["productIDs"]),

                      // 3. PASS THE SELLER UID TO THE WIDGET
                      sellerUID: sellerUID,
                    ),
                  )
                      : const Center(child: CircularProgressIndicator());
                },
              );
            },
          )
              : const Center(child: CircularProgressIndicator(color: Colors.red,),);
        },

      ),
    );
  }
}