import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sellers_app/global/global_instances.dart';
import 'package:sellers_app/global/global_vars.dart';
import 'package:sellers_app/view/mainScreens/earnings_screen.dart';
import 'package:sellers_app/view/mainScreens/history_screen.dart';
import 'package:sellers_app/view/mainScreens/home_screen.dart';
import 'package:sellers_app/view/mainScreens/new_orders_screen.dart';
import 'package:sellers_app/view/splashScreen/splash_screen.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children:
        [

          //header
          Container(
            padding: const EdgeInsets.only(top: 25, bottom: 10),
            child: Column(
              children: [

                //image
                Material(
                  borderRadius: const BorderRadius.all(Radius.circular(81)),
                  elevation: 8,
                  child: SizedBox(
                    height: 158,
                    width: 158,
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(
                        sharedPreferences!.getString("imageUrl").toString(),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 12,),

                Text(
                  sharedPreferences!.getString("name").toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

              ],
            ),
          ),

          const SizedBox(height: 12,),

          //body
          Container(
            child: Column(
              children: [

                const Divider(
                  height: 10,
                  color: Colors.grey,
                  thickness: 2,
                ),
                ListTile(
                  leading: const Icon(Icons.home, color: Colors.white,),
                  title: const Text(
                    "Home",
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: ()
                  {
                    Navigator.push(context, MaterialPageRoute(builder: (c)=> HomeScreen()));
                  },
                ),

                const Divider(
                  height: 10,
                  color: Colors.grey,
                  thickness: 2,
                ),
                ListTile(
                  leading: const Icon(Icons.currency_rupee, color: Colors.white,),
                  title: const Text(
                    "My Earnings",
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: ()
                  {
                    Navigator.push(context, MaterialPageRoute(builder: (c)=> EarningsScreen()));
                  },
                ),

                const Divider(
                  height: 10,
                  color: Colors.grey,
                  thickness: 2,
                ),
                ListTile(
                  leading: const Icon(Icons.reorder, color: Colors.white,),
                  title: const Text(
                    "New Orders",
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: ()
                  {
                    Navigator.push(context, MaterialPageRoute(builder: (c)=> NewOrdersScreen()));
                  },
                ),

                const Divider(
                  height: 10,
                  color: Colors.grey,
                  thickness: 2,
                ),
                ListTile(
                  leading: const Icon(Icons.local_shipping, color: Colors.white,),
                  title: const Text(
                    "History - Orders",
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: ()
                  {
                    Navigator.push(context, MaterialPageRoute(builder: (c)=> HistoryScreen()));
                  },
                ),

                const Divider(
                  height: 10,
                  color: Colors.grey,
                  thickness: 2,
                ),
                ListTile(
                  leading: const Icon(Icons.share_location, color: Colors.white,),
                  title: const Text(
                    "Update My Address",
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: ()
                  {
                    commonViewModel.updateLocationInDatabase();
                    commonViewModel.showSnackBar("your restaurant/cafe address update successfully", context);
                  },
                ),

                const Divider(
                  height: 10,
                  color: Colors.grey,
                  thickness: 2,
                ),
                ListTile(
                  leading: const Icon(Icons.exit_to_app, color: Colors.white,),
                  title: const Text(
                    "Sign Out",
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: ()
                  {
                    FirebaseAuth.instance.signOut();

                    Navigator.push(context, MaterialPageRoute(builder: (c)=> MySplashScreen()));
                  },
                ),

                const Divider(
                  height: 10,
                  color: Colors.grey,
                  thickness: 2,
                ),

              ],
            ),
          ),

        ],
      ),
    );
  }
}
