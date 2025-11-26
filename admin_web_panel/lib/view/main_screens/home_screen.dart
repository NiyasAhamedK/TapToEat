import 'package:admin_web_panel/view/main_screens/banner_screen.dart';
import 'package:admin_web_panel/view/main_screens/category_screen.dart';
import 'package:admin_web_panel/view/riders/all_blocked_riders_screen.dart';
import 'package:admin_web_panel/view/riders/all_verified_riders_screen.dart';
import 'package:admin_web_panel/view/sellers/all_blocked_sellers_screen.dart';
import 'package:admin_web_panel/view/sellers/all_verified_sellers_screen.dart';
import 'package:admin_web_panel/view/users/all_blocked_users_screen.dart';
import 'package:admin_web_panel/view/users/all_verified_users_screen.dart';
import 'package:admin_web_panel/view/widgets/my_appbar.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppbar(
        titleMsg: "Admin Web Panel",
        showBackButton: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            //upload banner and category
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                //bannerbutton
                ElevatedButton.icon(
                  onPressed: ()
                  {
                      Navigator.push(context, MaterialPageRoute(builder: (c)=>BannerScreen()));
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 117, vertical: 31),
                    backgroundColor:  Colors.deepOrange,
                  ),
                  icon:const Icon(Icons.screen_share_outlined, color: Colors.white,),
                  label: Text(
                    "Upload Banner".toUpperCase(),
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      letterSpacing: 3,
                    ),
                  )

                ),

                const SizedBox(width: 20,),
                //upload category btn
                ElevatedButton.icon(
                    onPressed: ()
                    {
                      Navigator.push(context, MaterialPageRoute(builder: (c)=>CategoryScreen()));
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 110, vertical: 30),
                      backgroundColor:  Colors.purple,
                    ),
                    icon:const Icon(Icons.category_outlined, color: Colors.white,),
                    label: Text(
                      "Upload category".toUpperCase(),
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        letterSpacing: 3,
                      ),
                    )

                ),
              ],
            ),
            //user activate and block account
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                //user activate account
                ElevatedButton.icon(
                    onPressed: ()
                    {
                      Navigator.push(context, MaterialPageRoute(builder: (c)=>AllVerifiedUsersScreen()));
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 45, vertical: 30),
                      backgroundColor:  Colors.green,
                    ),
                    icon:const Icon(Icons.check_circle_outline, color: Colors.white,),
                    label: Text(
                      "All verified Users accounts".toUpperCase(),
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        letterSpacing: 3,
                      ),
                    )

                ),

                const SizedBox(width: 20,),
                //uuser block account
                ElevatedButton.icon(
                    onPressed: ()
                    {
                      Navigator.push(context, MaterialPageRoute(builder: (c)=>AllBlockedUsersScreen()));
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 45, vertical: 30),
                      backgroundColor:  Colors.red,
                    ),
                    icon:const Icon(Icons.block_flipped, color: Colors.white,),
                    label: Text(
                      "All blocked users account".toUpperCase(),
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        letterSpacing: 3,
                      ),
                    )

                ),
              ],
            ),
            //sellers activate and block account
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                //seller activate account
                ElevatedButton.icon(
                    onPressed: ()
                    {
                      Navigator.push(context, MaterialPageRoute(builder: (c)=>AllVerifiedSellersScreen()));
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 30),
                      backgroundColor:  Colors.green,
                    ),
                    icon:const Icon(Icons.check_circle_outline, color: Colors.white,),
                    label: Text(
                      "All verified Sellers accounts".toUpperCase(),
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        letterSpacing: 3,
                      ),
                    )

                ),

                const SizedBox(width: 20,),
                //seller block account
                ElevatedButton.icon(
                    onPressed: ()
                    {
                      Navigator.push(context, MaterialPageRoute(builder: (c)=>AllBlockedSellersScreen()));
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 30),
                      backgroundColor:  Colors.red,
                    ),
                    icon:const Icon(Icons.block_flipped, color: Colors.white,),
                    label: Text(
                      "All blocked Sellers account".toUpperCase(),
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        letterSpacing: 3,
                      ),
                    )

                ),
              ],
            ),
            //riders activate and block account
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                //seller activate account
                ElevatedButton.icon(
                    onPressed: ()
                    {
                      Navigator.push(context, MaterialPageRoute(builder: (c)=>AllVerifiedRidersScreen()));
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
                      backgroundColor:  Colors.green,
                    ),
                    icon:const Icon(Icons.check_circle_outline, color: Colors.white,),
                    label: Text(
                      "All verified riders accounts".toUpperCase(),
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        letterSpacing: 3,
                      ),
                    )

                ),

                const SizedBox(width: 20,),
                //seller block account
                ElevatedButton.icon(
                    onPressed: ()
                    {
                      Navigator.push(context, MaterialPageRoute(builder: (c)=>AllBlockedRidersScreen()));
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
                      backgroundColor:  Colors.red,
                    ),
                    icon:const Icon(Icons.block_flipped, color: Colors.white,),
                    label: Text(
                      "All blocked riders account".toUpperCase(),
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        letterSpacing: 3,
                      ),
                    )

                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
