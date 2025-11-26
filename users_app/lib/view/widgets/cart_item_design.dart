import 'package:flutter/material.dart';

import '../../model/item.dart';

class CartItemDesign extends StatefulWidget
{
  final Item? itemModel;
  final int? quantityNumber;

  CartItemDesign({super.key, this.itemModel, this.quantityNumber,});

  @override
  State<CartItemDesign> createState() => _CartItemDesignState();
}

class _CartItemDesignState extends State<CartItemDesign> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: SizedBox(
          height: 100,
          width: MediaQuery.of(context).size.width,
          child: Row(
            children: [

              //item image
              Image.network(widget.itemModel!.itemImage!, width: 140, height: 120,),

              const SizedBox(width: 6,),

              //title
              //quantity number
              //price
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [

                  //title
                  Text(
                    widget.itemModel!.itemTitle!,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                      fontFamily: "Kiwi",
                    ),
                  ),

                  const SizedBox(
                    height: 1,
                  ),


                  //quantity number
                  Row(
                    children: [

                      const Text(
                        "x ",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 19,
                        ),
                      ),

                      Text(
                        widget.quantityNumber.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 23,
                        ),
                      ),

                    ],
                  ),


                  //price
                  Row(
                    children: [

                      const Text(
                        "Price: ",
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey,
                        ),
                      ),

                      const Text(
                        "₹",
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 16.0
                        ),
                      ),

                      Text(
                        widget.itemModel!.price.toString(),
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.blue,
                        ),
                      )

                    ],
                  ),

                ],
              )

            ],
          ),
        ),
      ),
    );
  }
}
