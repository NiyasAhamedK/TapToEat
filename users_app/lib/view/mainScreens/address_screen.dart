import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:users_app/global/global_instances.dart';
import 'package:users_app/model/address.dart';
import 'package:users_app/provider/address_changer.dart';
import 'package:users_app/view/mainScreens/save_address_screen.dart';
import 'package:users_app/view/widgets/address_ui_design.dart';
class AddressScreen extends StatefulWidget {
  double? totalAmount;
  String? sellerUID;
  AddressScreen({super.key, this.totalAmount, this.sellerUID});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select Address"),
        centerTitle: true,
        automaticallyImplyLeading: true,
      ),
      floatingActionButton: FloatingActionButton.extended
        (
          label: const Text("Add New Address"),
          backgroundColor: Colors.green,
          icon: const Icon(Icons.add_location, color: Colors.white,),
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (c)=> SaveAddressScreen()));
          },
        ),
    body: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [

        Consumer<AddressChanger>(builder : (context,address, c)
        {
          return Flexible(
              child: StreamBuilder<QuerySnapshot>(
              stream: addressViewModel.retrieveUserShipmentAddress(),
                builder: (context,snapshot)
                {
                  return !snapshot.hasData
                      ? const Center(child: Text("No Address", style: TextStyle(color: Colors.white),),)
                      : snapshot.data!.docs.length==0
                      ? const Center(child: Text("Please add new Address first."),)
                      : ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          shrinkWrap: true,
                          itemBuilder: (context,index)
                        {
                          return AddressUIDesign(
                            currentIndex: address.count,
                            value: index,
                            addressID: snapshot.data!.docs[index].id,
                            totalAmount: widget.totalAmount,
                            sellerUID: widget.sellerUID,
                            model: Address.fromJson(
                              snapshot.data!.docs[index].data()! as Map<String, dynamic>
                            ),
                          ) ;
                        },
                  );
                },
          ),
          );
        }),
      ],
    ),
    //body: ,
    );
  }
}
