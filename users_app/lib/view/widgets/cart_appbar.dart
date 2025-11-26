
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:users_app/provider/cart_item_counter.dart';
import 'package:users_app/view/mainScreens/cart_screen.dart';

import '../mainScreens/home_screen.dart';
class CartAppBar extends StatelessWidget implements PreferredSizeWidget {


  String? sellerUID;
  String? title;

  PreferredSizeWidget? bottom;

  CartAppBar(
      {super.key,this.sellerUID,this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: true,
      centerTitle: true,
      title: Text(
        title.toString(),
        style: const TextStyle(
          fontSize: 20,
          letterSpacing: 3,
          color: Colors.white,
        ),
      ),
      actions: [
        Stack(
          children: [
            IconButton(
              icon: const Icon(Icons.shopping_cart,color: Colors.white,),
              onPressed:()
              {
                //
                Navigator.push(context, MaterialPageRoute(builder: (c)=> CartScreen(sellerUID: sellerUID)));
              },
              ),
            Positioned(
                child: Stack(
                  children: [
                    const Icon(
                      Icons.brightness_1,
                      size: 20.0,
                      color: Colors.green,
                    ),
            Positioned(
                top: 3,
                right: 4,
                child: Center(
                  child: Consumer<CartItemCounter>(
                    builder: (context, counter, c)
                    {
                      return Text(
                        counter.count.toString(),
                        style: const TextStyle(color: Colors.white, fontSize: 12),
                      );
                    },
                  ),
                ),),
                  ],
                ),),
          ],
        ),
      ],
    );
  }

  @override
  Size get preferredSize => bottom==null
      ?Size(57, AppBar().preferredSize.height)
      :Size(57, 80+AppBar().preferredSize.height);
}
