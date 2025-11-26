import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:riders_app/global/global_vars.dart';
import 'package:riders_app/view/mainScreens/earnings_screen.dart';
import 'package:riders_app/view/mainScreens/history_screen.dart';
import 'package:riders_app/view/mainScreens/new_available_orders_screen.dart';
import 'package:riders_app/view/mainScreens/not_yet_delivered_screen.dart';
import 'package:riders_app/view/mainScreens/parcels_in_progress_screen.dart';
import 'package:riders_app/view/splashScreen/splash_screen.dart';

import '../../global/global_instances.dart';




class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}



class _HomeScreenState extends State<HomeScreen> {

  Card dashboardItem(String title, IconData iconData, int index)
  {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.all(15),
      child: Container(
        decoration: index == 0 || index == 3 || index == 4
            ? const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.black, Colors.grey],
                  begin: FractionalOffset(0.0, 0.0),
                  end: FractionalOffset(1.0, 0.0),
                  tileMode: TileMode.clamp,
                )
              )
            : const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.grey, Colors.black],
                  begin: FractionalOffset(0.0, 0.0),
                  end: FractionalOffset(1.0, 0.0),
                  tileMode: TileMode.clamp,
                )
              ),
        child: InkWell(
          onTap: ()
          {
            if(index==0){
              Navigator.push(context, MaterialPageRoute(builder: (c)=>NewAvailableOrdersScreen()));
            }
            if(index==1){
              Navigator.push(context, MaterialPageRoute(builder: (c)=>ParcelInProgressScreen()));
            }
            if(index==2){
              Navigator.push(context, MaterialPageRoute(builder: (c)=>NotYetDeliveredScreen()));
            }
            if(index==3){
              Navigator.push(context, MaterialPageRoute(builder: (c)=>HistoryScreen()));
            }
            if(index==4){
              Navigator.push(context, MaterialPageRoute(builder: (c)=>EarningsScreen()));
            }
            if(index==5){
              FirebaseAuth.instance.signOut();
              Navigator.push(context, MaterialPageRoute(builder: (c)=>MySplashScreen()));
            }

          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            verticalDirection: VerticalDirection.down,
            children: [

              const SizedBox(height: 50.0),

              Center(
                child: Icon(
                  iconData,
                  size: 40,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 10.0),

              Center(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }

  getUpdatedInfo() async
  {
    await commonViewModel.getRiderPreviousEarnings();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getUpdatedInfo();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          "Welcome  ${sharedPreferences!.getString("name")}",
          style: const TextStyle(
            fontSize: 18,
            color: Colors.white,
            letterSpacing: 2,
          ),

        ),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 1),
        child: GridView.count(
          crossAxisCount: 2,
          children: [

            dashboardItem("New Available Orders", Icons.assignment, 0),
            dashboardItem("Parcels in Progress", Icons.airport_shuttle, 1),
            dashboardItem("Not Yet Delivered", Icons.location_history, 2),
            dashboardItem("History", Icons.done_all, 3),
            dashboardItem("Total Earnings", Icons.currency_rupee, 4),
            dashboardItem("Logout", Icons.logout, 5),

          ],
        ),
      ),
    );
  }
}
