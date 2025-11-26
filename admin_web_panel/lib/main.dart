import 'package:admin_web_panel/view/main_screens/home_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> main() async
{
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: const FirebaseOptions(
        apiKey: "AIzaSyAnLpJpQpr3yQdnTZDJhAZizwpHrtl0P9k",
        authDomain: "projecta-fd083.firebaseapp.com",
        projectId: "projecta-fd083",
        storageBucket: "projecta-fd083.firebasestorage.app",
        messagingSenderId: "192432454039",
        appId: "1:192432454039:web:37bd133bd0365bca68ecd2"
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Admin Web Panel',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
      ),
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}
