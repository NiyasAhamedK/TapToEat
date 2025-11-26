import 'package:flutter/cupertino.dart';
class AddressChanger extends ChangeNotifier
{
  int counter =0;
  int get count=>counter;

  displayResult(dynamic newValue)
  {
    counter = newValue;
    notifyListeners();
  }
}