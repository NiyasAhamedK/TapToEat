import 'package:admin_web_panel/view/main_screens/home_screen.dart';
import 'package:flutter/material.dart';
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
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.deepOrange,
              Colors.purple,
            ],
            begin: FractionalOffset(0.0, 0.0),
            end: FractionalOffset(1.0, 0.0),
            stops: [0.0, 1.0],

            tileMode: TileMode.clamp,
          ),
        ),
      ),
      leading: showBackButton == true
          ? IconButton(
        icon: Icon(
          Icons.arrow_back, color: Colors.white,
        ),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (c) => HomeScreen()));
        },
      )
          : Container(),
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
