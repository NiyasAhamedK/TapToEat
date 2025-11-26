import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../model/item.dart';
import '../mainScreens/order_details_screen.dart';

// Assuming this function is available (from the previous step)
Future<DocumentSnapshot> getSellerDetails(String sellerUID) {
  return FirebaseFirestore.instance
      .collection("sellers")
      .doc(sellerUID)
      .get();
}

class OrderCardUIDesign extends StatelessWidget {
  final int? itemCount;
  final List<DocumentSnapshot>? data;
  final String? orderID;
  final List<String>? seperateQuantitiesList;

  // CRITICAL: ADD sellerUID here to enable lookup
  final String? sellerUID;

  const OrderCardUIDesign({
    super.key,
    this.itemCount,
    this.data,
    this.orderID,
    this.seperateQuantitiesList,
    this.sellerUID, // Add sellerUID to the constructor
  });

  @override
  Widget build(BuildContext context) {
    // Check if sellerUID is available before trying to look up
    final bool hasSellerUID = sellerUID != null && sellerUID!.isNotEmpty;

    return InkWell(
      onTap: ()
      {
        Navigator.push(context, MaterialPageRoute(builder: (c)=> OrderDetailScreen(orderID: orderID,)));
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.all(10),
        // Increased height slightly to accommodate the Seller Name Text
        height: (itemCount! * 125) + 30,

        child: Column(
          children: [

            // --- SELLER NAME DISPLAY (NEW) ---
            if (hasSellerUID)
              FutureBuilder<DocumentSnapshot>(
                future: getSellerDetails(sellerUID!), // Call the lookup
                builder: (context, sellerSnapshot) {
                  // Display Loading state
                  if (sellerSnapshot.connectionState == ConnectionState.waiting) {
                    return const Padding(
                      padding: EdgeInsets.only(bottom: 8.0),
                      child: Text("Sold by: Loading...", style: TextStyle(color: Colors.white70)),
                    );
                  }

                  // Display Error or Default Name
                  if (!sellerSnapshot.hasData || sellerSnapshot.data!.data() == null) {
                    return const Padding(
                      padding: EdgeInsets.only(bottom: 8.0),
                      child: Text("Sold by: Unknown Shop", style: TextStyle(color: Colors.redAccent)),
                    );
                  }

                  // Display Seller Name
                  Map<String, dynamic> sellerData = sellerSnapshot.data!.data() as Map<String, dynamic>;
                  String sellerName = sellerData['name'] ?? 'Shop N/A';

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "$sellerName",
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.blueAccent),
                      ),
                    ),
                  );
                },
              ),

            // --- ITEM LIST (Original ListView.builder) ---
            Expanded(
              child: ListView.builder(
                itemCount: itemCount,
                itemBuilder: (context,index)
                {
                  Item model =Item.fromJson(data![index].data()! as Map<String, dynamic>);

                  return placeOrderDesignWidget(model, context, seperateQuantitiesList![index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Keep placeOrderDesignWidget exactly as it is (No changes needed here)
Widget placeOrderDesignWidget(Item model, BuildContext context, String quantityNumber)
{
  // ... (Your existing item design widget code) ...
  return SizedBox(
    width: MediaQuery.of(context).size.width,
    height: 120,
    child: Row(
      children: [
        Image.network(model.itemImage!, width: 120,), // Missing comma here
        const SizedBox(width: 10.0,), // Missing comma here
        Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 20,
                ),
                //title - price
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [

                    Expanded(
                      child: Text(
                        model.itemTitle!,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                          fontFamily: "Acme",
                        ),
                      ),
                    ),

                    const SizedBox(
                      width: 10,

                    ),
                    const Text(
                      "₹ ",
                      style: TextStyle(fontSize: 16.0, color: Colors.blue),
                    ),

                    Text(
                      model.price.toString(),
                      style: const TextStyle(
                        color:  Colors.white70,
                        fontSize: 18.0,
                      ),
                    ),
                  ],
                ),

                const SizedBox(
                  height: 20,
                ),
                //x 5
                Row(
                  children: [
                    const Text(
                      "x ",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        quantityNumber,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontFamily: "Acme",
                        ),
                      ),
                    ),
                  ],
                )
              ],
            )
        ),
      ],
    ),
  );
}