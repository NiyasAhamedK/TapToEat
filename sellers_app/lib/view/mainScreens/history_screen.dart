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
        stream: ordersViewModel.retrieveOrdersHistory(),
        builder: (c, snapshot)
        {
          return snapshot.hasData
              ? ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (c, index)
            {
              return FutureBuilder<QuerySnapshot>(
                future: FirebaseFirestore.instance
                    .collection("items")
                    .where("itemID", whereIn: ordersViewModel.separateItemIDsForOrder((snapshot.data!.docs[index].data() as Map<String, dynamic>)["productIDs"]))
                    .where("sellerUID", whereIn: (snapshot.data!.docs[index].data()! as Map<String, dynamic>)["uid"])
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
                        seperateQuantitiesList: ordersViewModel.separateOrderItemQuatitiesForOrder((snapshot.data!.docs[index].data() as Map<String, dynamic>)["productIDs"])),
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

