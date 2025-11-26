
import 'package:flutter/material.dart';

import '../mainScreens/home_screen.dart';
class MyAppbar extends StatelessWidget implements PreferredSizeWidget {


  String titleMsg;
  bool showBackButton;
  PreferredSizeWidget? bottom;

  MyAppbar(
      {super.key, required this.titleMsg, required this.showBackButton, this.bottom});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: showBackButton,
      backgroundColor: Colors.black,
      leading: showBackButton == true
          ? IconButton(
              icon: const Icon(
              Icons.arrow_back, color: Colors.white,),
              onPressed: ()
              {
                  Navigator.push(context, MaterialPageRoute(builder: (c) => HomeScreen()));
              },
      )
          : showBackButton == false
          ? IconButton(
              icon: const Icon(
              Icons.menu, color: Colors.white,),
              onPressed: ()
            {
              Scaffold.of(context).openDrawer();
              },

            )
          :Container(),
      centerTitle: true,
      title: Text(
        titleMsg,
        style: const TextStyle(
          fontSize: 20,
          letterSpacing: 3,
          color: Colors.white,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => bottom==null
      ?Size(57, AppBar().preferredSize.height)
      :Size(57, 80+AppBar().preferredSize.height);
}
