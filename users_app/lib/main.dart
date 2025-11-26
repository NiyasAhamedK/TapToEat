import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:users_app/provider/address_changer.dart';
import 'package:users_app/provider/cart_item_counter.dart';
import 'package:users_app/provider/total_amount.dart';
import 'package:users_app/view/splashScreen/splash_screen.dart';
import 'global/global_vars.dart';


Future<void> main() async
{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  sharedPreferences = await SharedPreferences.getInstance();

  await Permission.locationWhenInUse.isDenied.then((valueOfPermission)
  {
    if(valueOfPermission)
    {
      Permission.locationWhenInUse.request();
    }
  });

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (c)=> CartItemCounter()),
        ChangeNotifierProvider(create: (c)=> TotalAmount()),
        ChangeNotifierProvider(create: (c)=> AddressChanger()),


      ],
      child: MaterialApp(
        title: 'Users App',
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: Colors.black,
        ),
        debugShowCheckedModeBanner: false,
        home: MySplashScreen(),
      ),
    );
  }
}


