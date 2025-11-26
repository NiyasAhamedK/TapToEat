import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:users_app/global/global_instances.dart';
import 'package:users_app/model/address.dart';
import 'package:users_app/provider/address_changer.dart';
import 'package:users_app/view/mainScreens/place_order_screen.dart';
class AddressUIDesign extends StatefulWidget {
  final Address? model;
  final int? currentIndex;
  final int? value;
  final String? addressID;
  final double? totalAmount;
  final String? sellerUID;

   AddressUIDesign({super.key,
     this.model,
     this.currentIndex,
     this.value,
     this.addressID,
     this.totalAmount,
     this.sellerUID
   }
  );

  @override
  State<AddressUIDesign> createState() => _AddressUIDesignState();
}

class _AddressUIDesignState extends State<AddressUIDesign> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ()
      {
        Provider.of<AddressChanger>(context,listen: false).displayResult(widget.value);
      },
      child: Card(
        color: Colors.grey[10],
        elevation: 6,
        child: Column(
          children: [

            //0  address info
            Row(
              children: [
                Radio(
                    groupValue: widget.currentIndex!,
                    value: widget.value!,
                    activeColor: Colors.amber,
                    onChanged: (val)
                  {
                    Provider.of<AddressChanger>(context,listen: false).displayResult(val);
                  },
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Container(
                      padding: const EdgeInsets.all(10),
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: Table(
                        children: [

                          TableRow(
                            children:
                              [
                                const Text(
                                  "Name: ",
                                  style: TextStyle(color:  Colors.white,
                                  fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  widget.model!.name.toString(),
                                  style: const TextStyle(
                                    color: Colors.white70,
                                  ),
                                ),
                              ]
                          ),
                          TableRow(
                              children:
                              [
                                const Text(
                                  "Phone Number: ",
                                  style: TextStyle(color:  Colors.white, fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  widget.model!.phoneNumber.toString(),
                                  style: const TextStyle(
                                    color: Colors.white70,
                                  ),
                                ),
                              ]
                          ),
                          TableRow(
                              children:
                              [
                                const Text(
                                  "Flat Number: ",
                                  style: TextStyle(color:  Colors.white, fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  widget.model!.flatNumber.toString(),
                                  style: const TextStyle(
                                    color: Colors.white70,
                                  ),
                                ),
                              ]
                          ),
                          TableRow(
                              children:
                              [
                                const Text(
                                  "City : ",
                                  style: TextStyle(color:  Colors.white, fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  widget.model!.city.toString(),
                                  style: const TextStyle(
                                    color: Colors.white70,
                                  ),
                                ),
                              ]
                          ),
                          TableRow(
                              children:
                              [
                                const Text(
                                  "State : ",
                                  style: TextStyle(color:  Colors.white, fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  widget.model!.state.toString(),
                                  style: const TextStyle(
                                    color: Colors.white70,
                                  ),
                                ),
                              ]
                          ),
                          TableRow(
                              children:
                              [
                                const Text(
                                  "Full Address: ",
                                  style: TextStyle(color:  Colors.white, fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  widget.model!.fullAddress.toString(),
                                  style: const TextStyle(
                                    color: Colors.white70,
                                  ),
                                ),
                              ]
                          )
                        ],
                      ),

                    )
                  ],
                ),
              ],
            ),


            //button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black45
              ),
              onPressed: ()
              {
                addressViewModel.openGoogleMapWithGeoGraphicPosition(widget.model!.lat!, widget.model!.lng!);
              },
              child: const Text("Check on Maps"),
            ),

            widget.value == Provider.of<AddressChanger>(context).count ?
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white24,
                ),
                onPressed: ()
                {
                  Navigator.push(context, MaterialPageRoute(builder: (c)=> PlaceOrderScreen(
                    addressID: widget.addressID,
                    totalAmount: widget.totalAmount,
                    sellerUID: widget.sellerUID,
                  )));
                },
                child: const Text("Proceed"),
              ),
            ) : Container(),

          ],
        ),
      ),
    );
  }
}
