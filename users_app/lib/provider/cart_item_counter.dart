// import 'package:flutter/material.dart';
// import 'package:users_app/global/global_vars.dart';
//
// class CartItemCounter extends ChangeNotifier{
//   int cartListItemCounter = sharedPreferences!.getStringList("userCart")!.length - 1;
//   int get count => cartListItemCounter;
//
//   showCartListItemsNumber() async
//   {
//     cartListItemCounter =sharedPreferences!.getStringList("userCart")!.length - 1;
//
//     notifyListeners();
//   }
// }

import 'package:flutter/material.dart';
import 'package:users_app/global/global_vars.dart';

class CartItemCounter extends ChangeNotifier {
  int cartListItemCounter = (sharedPreferences!.getStringList("userCart")?.length ?? 0) - 1;

  int get count => cartListItemCounter;

  showCartListItemsNumber() async {
    cartListItemCounter = (sharedPreferences!.getStringList("userCart")?.length ?? 0) - 1;
    notifyListeners();
  }
}