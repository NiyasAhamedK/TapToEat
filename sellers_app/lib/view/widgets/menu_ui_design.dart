import 'package:flutter/material.dart';
import 'package:sellers_app/view/mainScreens/items/items_screen.dart';

import '../../model/menu.dart';
class MenuUIDesign extends StatefulWidget {
  final Menu? menuModel;
  const MenuUIDesign({super.key,this.menuModel});

  @override
  State<MenuUIDesign> createState() => _MenuUIDesignState();
}

class _MenuUIDesignState extends State<MenuUIDesign> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ()
      {
        Navigator.push(context, MaterialPageRoute(builder: (c)=> ItemsScreen(menuModel: widget.menuModel,)));

      },
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: SizedBox(
          height: 270,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Image.network(
                widget.menuModel!.menuImage.toString(),
                width: MediaQuery.of(context).size.width,
                height: 220,
                fit: BoxFit.cover,

              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  Text(
                    widget.menuModel!.menuTitle.toString(),
                    style: const TextStyle(
                        color: Colors.cyan,
                        fontSize: 20,
                        fontFamily: "Train"
                    ),
                  ),

                ],
              )



            ],
          ),
        ),
      ),
    );
  }
}

