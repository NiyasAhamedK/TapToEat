import 'package:flutter/material.dart';
import 'package:users_app/view/mainScreens/item_details_screen.dart';
import '../../model/item.dart';



class ItemUIDesign extends StatefulWidget {
  final Item? itemModel;

  const ItemUIDesign({super.key,this.itemModel});

  @override
  State<ItemUIDesign> createState() => _ItemUIDesignState();
}

class _ItemUIDesignState extends State<ItemUIDesign> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ()
      {
        Navigator.push(context, MaterialPageRoute(builder: (c)=> ItemDetailScreen(itemModel: widget.itemModel,)));

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

