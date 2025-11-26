import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../model/item.dart';
import '../mainScreens/order_details_screen.dart';

class OrderCardUIDesign extends StatelessWidget {
  final int? itemCount;
  final List<DocumentSnapshot>? data;
  final String? orderID;
  final List<String>? seperateQuantitiesList;

  const OrderCardUIDesign({super.key,this.itemCount,this.data,this.orderID,this.seperateQuantitiesList});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ()
      {
        Navigator.push(context, MaterialPageRoute(builder: (c)=> OrderDetailScreen(orderID: orderID,)));
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.all(10),
        height: itemCount! * 125,
        child: ListView.builder(
          itemCount: itemCount,

        itemBuilder: (context,index)
            {
              Item model =Item.fromJson(data![index].data()! as Map<String, dynamic>);

              return placeOrderDesignWidget(model, context, seperateQuantitiesList![index]);
            },
        ),
      ),
    );
  }
}

Widget placeOrderDesignWidget(Item model, BuildContext context, String quantityNumber)
{
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
