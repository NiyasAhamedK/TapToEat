import 'package:flutter/material.dart';
import 'package:users_app/view/mainScreens/menu_screen.dart';


import '../../model/seller.dart';



class SellerUIDesign extends StatefulWidget {
   final Seller ? sellerModel;

  const SellerUIDesign({super.key,this.sellerModel});

  @override
  State<SellerUIDesign> createState() => _SellerUIDesignState();
}

class _SellerUIDesignState extends State<SellerUIDesign> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ()
      {
        Navigator.push(context, MaterialPageRoute(builder: (c)=> MenuScreen(sellerModel: widget.sellerModel)));

      },
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: SizedBox(

          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Image.network(
                widget.sellerModel!.image.toString(),
                width: MediaQuery.of(context).size.width,
                height: 210,
                fit: BoxFit.cover,
              ),

              const SizedBox(height: 1.0,),

              Text(
                widget.sellerModel!.name.toString(),
                style: const TextStyle(
                    color: Colors.cyan,
                    fontSize: 20,
                    fontFamily: "Train"
                ),
              ),
              Text(
                widget.sellerModel!.email.toString(),
                style: const TextStyle(
                    color: Colors.cyan,
                    fontSize: 12,

                ),
              ),

              const SizedBox(height: 2.0,),




            ],
          ),
        ),
      ),
    );
  }
}

