import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as fStorage;
import 'package:shared_preferences/shared_preferences.dart';
import '../global/global_instances.dart';
import '../global/global_vars.dart';
import '../view/mainScreens/home_screen.dart';

class AuthViewModel{
   validateSignUpForm(XFile? imageXFile, String password, String confirmPassword, String name, String email, String phone, String locationAddress, BuildContext context) async
   {
     if(imageXFile == null){
       commonViewModel.showSnackBar("Please select image", context);
       return;

     }
     else{
       if(password == confirmPassword)
       {
         if(name.isNotEmpty && email.isNotEmpty && password.isNotEmpty && confirmPassword.isNotEmpty && phone.isNotEmpty && locationAddress.isNotEmpty){

           commonViewModel.showSnackBar("Please Wait..", context);
           User? currentFirebaseUser = await createUserInFirebaseAuth(email,password,context);

           String downloadUrl = await uploadImageToStorage(imageXFile);
           await saveUserDataToFirestore(currentFirebaseUser, downloadUrl, name, email, password, locationAddress, phone);

          Navigator.push(context, MaterialPageRoute(builder: (c)=> HomeScreen()));

          commonViewModel.showSnackBar("Account Created Succesfully.", context);
         }
         else{
           commonViewModel.showSnackBar("Please fill all fields", context);
           return;
         }
       }
       else{
         commonViewModel.showSnackBar("Confirm password do not match", context);
         return;
       }
     }
   }
   createUserInFirebaseAuth(String email,String password,BuildContext context) async{
     User? currentFirebaseUser;
     await FirebaseAuth.instance.createUserWithEmailAndPassword(
         email: email, password: password
     ).then((valueAuth){
      currentFirebaseUser = valueAuth.user;
     }).catchError((errorMsg){
       commonViewModel.showSnackBar(errorMsg, context);
     });

     if(currentFirebaseUser == null){
       FirebaseAuth.instance.signOut();
       return;
     }

     return currentFirebaseUser;
   }

   uploadImageToStorage(imageXfile) async{
     String downloadUrl = "";
     String fileName = DateTime.now().millisecondsSinceEpoch.toString();
     fStorage.Reference storageRef = fStorage.FirebaseStorage.instance.ref().child("ridersImages").child(fileName);
     fStorage.UploadTask uploadTask = storageRef.putFile(File(imageXfile!.path));
     fStorage.TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => {});
     await taskSnapshot.ref.getDownloadURL().then((urlImage)
     {
       downloadUrl = urlImage;
     });
      return downloadUrl;

   }

   saveUserDataToFirestore(currentFirebaseUser, downloadUrl, name, email, password, locationAddress,phone) async {
     FirebaseFirestore.instance.collection("riders").doc(currentFirebaseUser.uid).
     set({

       "uid": currentFirebaseUser.uid,
       "email": email,
       "name": name,
       "image": downloadUrl,
       "phone": phone,
       "address": locationAddress,
       "status": "approved",
       "earning": 0.0,
       "latitude": position!.latitude,
       "longitude": position!.longitude,
     });

     await sharedPreferences!.setString("uid", currentFirebaseUser.uid);
     await sharedPreferences!.setString("email", email);
     await sharedPreferences!.setString("name", name);
     await sharedPreferences!.setString("imageUrl", downloadUrl);
   }


   validateSignInForm(String email, String password, BuildContext context) async
   {
     if(email.isNotEmpty && password.isNotEmpty)
     {
       commonViewModel.showSnackBar("Checking credentials...", context);

       User? currentFirebaseUser = await loginUser(email, password, context);

       await readDataFromFirestoreAndSetDataLocally(currentFirebaseUser, context);

       Navigator.push(context, MaterialPageRoute(builder: (c)=> HomeScreen()));

       commonViewModel.showSnackBar("Logged-in successful.", context);
     }
     else
     {
       commonViewModel.showSnackBar("Password and Email are required.", context);
       return;
     }
   }


   loginUser(email, password, context) async
   {
     User? currentFirebaseUser;

     await FirebaseAuth.instance.signInWithEmailAndPassword(
         email: email,
         password: password
     ).then((valueAuth)
     {
       currentFirebaseUser = valueAuth.user;
     }).catchError((errorMsg)
     {
       commonViewModel.showSnackBar(errorMsg, context);
     });

     if(currentFirebaseUser == null)
     {
       FirebaseAuth.instance.signOut();
       return;
     }

     return currentFirebaseUser;
   }

   readDataFromFirestoreAndSetDataLocally(User? currentFirebaseUser,BuildContext context) async
   {
     await FirebaseFirestore.instance
         .collection("riders")
         .doc(currentFirebaseUser!.uid)
         .get()
         .then((dataSnapshot) async
     {
       if(dataSnapshot.exists)
       {
         if(dataSnapshot.data()!["status"] == "approved")
         {
           await sharedPreferences!.setString("uid", currentFirebaseUser.uid);
           await sharedPreferences!.setString("email", dataSnapshot.data()!["email"]);
           await sharedPreferences!.setString("name", dataSnapshot.data()!["name"]);
           await sharedPreferences!.setString("imageUrl", dataSnapshot.data()!["image"]);
         }
         else
         {
           commonViewModel.showSnackBar("You are blocked by admin. Contact: koonariniyas@gmail.com", context);
           FirebaseAuth.instance.signOut();
           return;

         }
       }
       else
         {
           commonViewModel.showSnackBar("This seller record do not exists.", context);
           FirebaseAuth.instance.signOut();
           return;
         }
     });
   }

}

