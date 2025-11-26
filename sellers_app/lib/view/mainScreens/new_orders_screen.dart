import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sellers_app/global/global_instances.dart';
import 'package:sellers_app/view/widgets/my_appbar.dart';
import 'package:sellers_app/view/widgets/order_card_ui_design.dart';
import 'package:sellers_app/viewModel/orders_view_model.dart';


class NewOrdersScreen extends StatefulWidget {
  const NewOrdersScreen({super.key});

  @override
  State<NewOrdersScreen> createState() => _NewOrdersScreenState();
}




class _NewOrdersScreenState extends State<NewOrdersScreen>
{
  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: MyAppbar(
        titleMsg: "New Orders",
        showBackButton: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: ordersViewModel.getNewOrders(),
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
                          .where("itemID", whereIn: ordersViewModel.separateItemIDsForOrder((snapshot.data!.docs[index].data()! as Map<String, dynamic>) ["productIDs"]))
                          .where("sellerUID", whereIn: (snapshot.data!.docs[index].data()! as Map<String, dynamic>)["uid"])
                          .orderBy("publishedDateTime", descending: true)
                          .get(),
                      builder: (c, snap)
                      {
                        return snap.hasData
                            ? Card(
                                elevation: 6,
                                color: Colors.black87,
                                child: OrderCardUIDesign(
                                  itemCount: snap.data!.docs.length,
                                  data: snap.data!.docs,
                                  orderID: snapshot.data!.docs[index].id,
                                  seperateQuantitiesList: ordersViewModel.separateOrderItemQuatitiesForOrder((snapshot.data!.docs[index].data()! as Map<String, dynamic>)["productIDs"]),

                                ),
                              )
                            : Center(child: CircularProgressIndicator(),);
                      }
                    );
                  }
                )
              : Center(child: CircularProgressIndicator(),);
        }
      ),
    );
  }
}
