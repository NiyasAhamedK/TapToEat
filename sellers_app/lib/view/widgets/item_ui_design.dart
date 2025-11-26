import 'package:flutter/material.dart';
import 'package:sellers_app/model/item.dart';


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
        //Navigator.push(context, MaterialPageRoute(builder: (c)=> ItemsScreen(menuModel: widget.itemModel,)));

      },
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: SizedBox(
          height: 252,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Image.network(
                widget.itemModel!.itemImage.toString(),
                width: MediaQuery.of(context).size.width,
                height: 220,
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

