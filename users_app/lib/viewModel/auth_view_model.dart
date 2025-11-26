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
  final String requiredDomain = '@srmist.edu.in'; // Define the required domain once

  validateSignUpForm(XFile? imageXFile, String password, String confirmPassword, String name, String email, BuildContext context) async
  {
    if(imageXFile == null){
      commonViewModel.showSnackBar("Please select image", context);
      return;
    }
    else{
      // --- CRITICAL EMAIL DOMAIN VALIDATION ---
      if (!email.endsWith(requiredDomain)) {
        commonViewModel.showSnackBar("Enter your college mail ID", context);
        return;
      }
      // ----------------------------------------

      if(password == confirmPassword)
      {
        if(name.isNotEmpty && email.isNotEmpty && password.isNotEmpty && confirmPassword.isNotEmpty){

          commonViewModel.showSnackBar("Please Wait..", context);
          User? currentFirebaseUser = await createUserInFirebaseAuth(email,password,context);

          // Check if user creation failed (e.g., email already in use)
          if (currentFirebaseUser == null) {
            return; // Exit validation if user creation failed (error already shown by createUserInFirebaseAuth)
          }

          String downloadUrl = await uploadImageToStorage(imageXFile);
          await saveUserDataToFirestore(currentFirebaseUser, downloadUrl, name, email, password);

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

  // ... (rest of the class methods remain unchanged) ...

  createUserInFirebaseAuth(String email,String password,BuildContext context) async{
    User? currentFirebaseUser;
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email, password: password
    ).then((valueAuth){
      currentFirebaseUser = valueAuth.user;
    }).catchError((errorMsg){
      commonViewModel.showSnackBar(errorMsg.toString(), context); // Ensure errorMsg is converted to String
    });

    if(currentFirebaseUser == null){
      FirebaseAuth.instance.signOut();
      return null; // Return null explicitly if creation failed
    }

    return currentFirebaseUser;
  }

  uploadImageToStorage(imageXfile) async{
    String downloadUrl = "";
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    fStorage.Reference storageRef = fStorage.FirebaseStorage.instance.ref().child("usersImages").child(fileName);
    fStorage.UploadTask uploadTask = storageRef.putFile(File(imageXfile!.path));
    fStorage.TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => {});
    await taskSnapshot.ref.getDownloadURL().then((urlImage)
    {
      downloadUrl = urlImage;
    });
    return downloadUrl;

  }

  saveUserDataToFirestore(currentFirebaseUser, downloadUrl, name, email, password) async {
    FirebaseFirestore.instance.collection("users").doc(currentFirebaseUser.uid).
    set({

      "uid": currentFirebaseUser.uid,
      "email": email,
      "name": name,
      "image": downloadUrl,
      "status": "approved",
      "userCart": ["garbageValue"]
    });

    await sharedPreferences!.setString("uid", currentFirebaseUser.uid);
    await sharedPreferences!.setString("email", email);
    await sharedPreferences!.setString("name", name);
    await sharedPreferences!.setString("imageUrl", downloadUrl);
    await sharedPreferences!.setStringList("userCart", ["garbageValue"]);
  }


  validateSignInForm(String email, String password, BuildContext context) async
  {
    if(email.isNotEmpty && password.isNotEmpty)
    {
      commonViewModel.showSnackBar("Checking credentials...", context);

      User? currentFirebaseUser = await loginUser(email, password, context);

      await readDataFromFirestoreAndSetDataLocally(currentFirebaseUser, context);

      Navigator.push(context, MaterialPageRoute(builder: (c)=> HomeScreen()));

      commonViewModel.showSnackBar("logged-in successfull. ", context);
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
      commonViewModel.showSnackBar(errorMsg.toString(), context); // Ensure errorMsg is converted to String
    });

    if(currentFirebaseUser == null)
    {
      FirebaseAuth.instance.signOut();
      return null; // Return null explicitly if login failed
    }

    return currentFirebaseUser;
  }

  readDataFromFirestoreAndSetDataLocally(User? currentFirebaseUser,BuildContext context) async
  {
    await FirebaseFirestore.instance
        .collection("users")
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