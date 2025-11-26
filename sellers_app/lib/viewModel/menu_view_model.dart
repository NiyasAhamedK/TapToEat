import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sellers_app/global/global_vars.dart';

import 'package:firebase_storage/firebase_storage.dart' as fStorage;
import 'package:shared_preferences/shared_preferences.dart';

import '../global/global_instances.dart';

class MenuViewModel
{


  getCategories() async
  {
    // Clear the list before fetching new data
    categoryList.clear();

    await FirebaseFirestore.instance
        .collection("categories")
        .get()
        .then((QuerySnapshot dataSnapshot) {
      dataSnapshot.docs.forEach((doc) {
        categoryList.add(doc["name"]);
      });
    });
  }

  validateMenuUploadForm(infoText, titleText, context) async {
    if (imageFile != null) {
      if (infoText.isNotEmpty && titleText.isNotEmpty) {
        commonViewModel.showSnackBar("Uploading now, please wait...", context);

        String uniqueFileID = DateTime.now().millisecondsSinceEpoch.toString();

         String downloadUrl = await uploadImageToStorage(uniqueFileID);

         await saveMenuInfoToDatabase(infoText,titleText,downloadUrl,uniqueFileID, context);
      }
      else {
        commonViewModel.showSnackBar("Please fill all fields.", context);
      }
    }
    else {
      commonViewModel.showSnackBar("Please select menu image.", context);
    }
  }

  uploadImageToStorage(uniqueFileID) async {

      fStorage.Reference reference = fStorage.FirebaseStorage.instance.ref().child("menuImages");
      fStorage.UploadTask uploadTask = reference.child(uniqueFileID + ".jpg").putFile(File(imageFile!.path));
      fStorage.TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});
      String downloadURL = await taskSnapshot.ref.getDownloadURL();
      return downloadURL;
  }

  saveMenuInfoToDatabase(infoText,titleText,downloadUrl,uniqueFileID,context)
  async {

    final reference =FirebaseFirestore.instance.collection("sellers")
        .doc(sharedPreferences!
        .getString("uid"))
        .collection("menus");

      await reference.doc(uniqueFileID).set({
      "menuID": uniqueFileID,
      "sellerUID":sharedPreferences!.getString("uid"),
      "sellerName":sharedPreferences!.getString("name"),
      "menuInfo":infoText,
      "menuTitle":titleText,
      "menuImage":downloadUrl,
      "publishedDateTime":DateTime.now(),
      "status":"available",
    });
      commonViewModel.showSnackBar("Uploaded Successfully", context);
  }
  retrieveMenus() {
    return FirebaseFirestore.instance
        .collection("sellers")
        .doc(sharedPreferences!.getString("uid"))
        .collection("menus")
        .orderBy("publishedDateTime", descending: true)
        .snapshots();
  }

}