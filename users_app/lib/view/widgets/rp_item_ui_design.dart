import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:users_app/global/global_instances.dart';
import 'package:users_app/model/menu.dart';
import 'package:users_app/view/mainScreens/item_details_screen.dart';
import 'package:users_app/view/mainScreens/items_screen.dart';
import '../../model/item.dart';



class RPItemUIDesign extends StatefulWidget {
  final Item? itemModel;

  const RPItemUIDesign({super.key,this.itemModel});

  @override
  State<RPItemUIDesign> createState() => _RPItemUIDesignState();
}

class _RPItemUIDesignState extends State<RPItemUIDesign> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async
      {
        cartViewModel.clearCartNow(context);

        Menu menuModel = Menu();

        await FirebaseFirestore.instance
            .collection("sellers")
            .doc(widget.itemModel!.sellerUID)
            .collection("menus")
            .doc(widget.itemModel!.menuID)
            .get()
            .then((snapshot)
        {
          menuModel.menuID = snapshot.data()!["menuID"];
          menuModel.sellerUID = snapshot.data()!["sellerUID"];
          menuModel.sellerName = snapshot.data()!["sellerName"];
          menuModel.menuTitle = snapshot.data()!["menuTitle"];
          menuModel.menuInfo = snapshot.data()!["menuInfo"];
          menuModel.menuImage = snapshot.data()!["menuImage"];
          menuModel.publishedDateTime = snapshot.data()!["publishedDateTime"];
          menuModel.status = snapshot.data()!["status"];

          Navigator.push(context, MaterialPageRoute(builder: (c)=> ItemsScreen(
            menuModel: menuModel,
            value: "rp",
          )));
        });
      },
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: SizedBox(

          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Image.network(
                widget.itemModel!.itemImage.toString(),
                width: MediaQuery.of(context).size.width,
                height: 210,
                fit: BoxFit.cover,
              ),

              const SizedBox(height: 2.0,),

              Text(
                widget.itemModel!.itemTitle.toString(),
                style: const TextStyle(
                    color: Colors.cyan,
                    fontSize: 20,
                    fontFamily: "Train"
                ),
              ),




            ],
          ),
        ),
      ),
    );
  }
}

