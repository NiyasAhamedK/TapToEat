import 'package:flutter/material.dart';
import 'package:number_inc_dec/number_inc_dec.dart';
import 'package:users_app/global/global_instances.dart';
import 'package:users_app/view/widgets/cart_appbar.dart';

import '../../model/item.dart';
class ItemDetailScreen extends StatefulWidget {
  Item? itemModel;
  ItemDetailScreen({super.key,this.itemModel});

  @override
  State<ItemDetailScreen> createState() => _ItemDetailScreenState();
}

class _ItemDetailScreenState extends State<ItemDetailScreen> {
  TextEditingController controllerCounter = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CartAppBar(
        sellerUID: widget.itemModel!.sellerUID,
        title: widget.itemModel!.itemTitle,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              widget.itemModel!.itemImage!,
            ),
            Padding(
                padding: const EdgeInsets.all(18.0),
                child: NumberInputPrefabbed.roundedButtons(
                  controller: controllerCounter,
                  incDecBgColor: Colors.black87,
                  incIconColor: Colors.white,
                  decIconColor: Colors.white,
                  min: 1,
                  max: 9,
                  initialValue: 1,
                  buttonArrangement: ButtonArrangement.incRightDecLeft,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
            ),
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  widget.itemModel!.itemTitle.toString(),
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                widget.itemModel!.description.toString(),
                textAlign: TextAlign.justify,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),

            Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "${widget.itemModel!.price} ₹",
                  style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 30),
                ),


            ),
            const SizedBox(height: 10,),
            Center(
              child: ElevatedButton(
                  onPressed: ()
                  {
                    int quantityNumber = int.parse(controllerCounter.text);

                    List<String> separateItemIDsList = cartViewModel.separateItemIDs();
                    //1.check if item exist already in cart
                    separateItemIDsList.contains(widget.itemModel!.itemID)
                        ?
                    commonViewModel.showSnackBar("Item is already in Cart.", context)
                        :
                    //2.add to cart
                    cartViewModel.addItemToCart(widget.itemModel!.itemID, context, quantityNumber);
                  },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(horizontal: 120),
                ),
                  child: Text(
                    "Add to Cart",
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 16,
                    ),
                  ),
              ),
            ),
          ],


        ),
      ),

    );
  }
}
