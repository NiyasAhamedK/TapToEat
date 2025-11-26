import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:users_app/global/global_instances.dart';
import 'package:users_app/model/item.dart';
import 'package:users_app/provider/cart_item_counter.dart';
import 'package:users_app/provider/total_amount.dart';
import 'package:users_app/view/mainScreens/address_screen.dart';
import 'package:users_app/view/splashScreen/splash_screen.dart';
import 'package:users_app/view/widgets/cart_item_design.dart';

class CartScreen extends StatefulWidget
{
  String? sellerUID;

  CartScreen({super.key, this.sellerUID});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen>
{
  List<int>? separateItemQuantityList;
  num totalAmount = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    totalAmount = 0;


    separateItemQuantityList = cartViewModel.separateItemQuantities();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.clear_all),
          onPressed: ()
          {
            //clear cart
            cartViewModel.clearCartNow(context);

            Navigator.push(context, MaterialPageRoute(builder: (c)=> const MySplashScreen()));
          },
        ),
        title: const Text(
          "My Cart",
          style: TextStyle(fontSize: 24,),
        ),
        centerTitle: true,
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [

          const SizedBox(width: 10,),

          Align(
            alignment: Alignment.bottomLeft,
            child: FloatingActionButton.extended(
              heroTag: "btn1",
              label: const Text("Clear cart", style: TextStyle(fontSize: 16),),
              backgroundColor: Colors.black87,
              icon: const Icon(Icons.clear_all),
              onPressed: ()
              {
                //clear the cart
                cartViewModel.clearCartNow(context);

                Navigator.push(context, MaterialPageRoute(builder: (c)=> const MySplashScreen()));

                commonViewModel.showSnackBar("Cart has been cleared", context);
              },
            ),
          ),

          Align(
            alignment: Alignment.bottomLeft,
            child: FloatingActionButton.extended(
              heroTag: "btn2",
              label: const Text("Check Out", style: TextStyle(fontSize: 16),),
              backgroundColor: Colors.black87,
              icon: const Icon(Icons.navigate_next),
              onPressed: ()
              {
                Navigator.push(context, MaterialPageRoute(builder: (c)=> AddressScreen(
                    totalAmount: totalAmount.toDouble(),
                  sellerUID: widget.sellerUID,
                )));
              },
            ),
          ),

        ],
      ),
      body: Column(
        children: [

          Consumer2<TotalAmount, CartItemCounter>(builder: (context, amountProvider, cartProvider, c)
          {
            return Padding(
              padding: const EdgeInsets.all(12),
              child: Center(
                child: cartProvider.count == 0
                    ? Container()
                    : Text(
                        "Total Amount: " + amountProvider.totalAmount.toString(),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white
                        ),
                      ),
              ),
            );
          }),

          Flexible(
            child: StreamBuilder<QuerySnapshot>(
              stream: cartViewModel.getCartItems(),
              builder: (context, snapshot)
              {
                return !snapshot.hasData
                    ? const Center(child: Text("no items found"),)
                    : ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index)
                    {
                      Item itemModel = Item.fromJson(
                          snapshot.data!.docs[index].data() as Map<String, dynamic>
                      );

                      if(index == 0)
                      {
                        totalAmount = 0;
                        totalAmount = totalAmount + (itemModel.price! * separateItemQuantityList![index]);
                      }
                      else
                      {
                        totalAmount = totalAmount + (itemModel.price! * separateItemQuantityList![index]);
                      }

                      if(snapshot.data!.docs.length - 1 == index)
                      {
                        WidgetsBinding.instance!.addPostFrameCallback((timeStamp)
                        {
                          Provider.of<TotalAmount>(context, listen: false).displayTotalAmount(totalAmount.toDouble());
                        });
                      }

                      return Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 8, top: 3),
                        child: Card(
                          elevation: 6,
                          child: CartItemDesign(
                            itemModel: itemModel,
                            quantityNumber: separateItemQuantityList![index],
                          ),
                        ),
                      );
                    }
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
