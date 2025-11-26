import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sellers_app/model/menu.dart';

import '../global/global_instances.dart';
import '../global/global_vars.dart';
import 'package:firebase_storage/firebase_storage.dart' as fStorage;

class ItemViewModel
{
  validateItemUploadForm(infoText, titleText, descriptionText, priceItem, Menu menuModel, context) async {
    if (imageFile != null) {
      if (infoText.isNotEmpty && titleText.isNotEmpty && descriptionText.isNotEmpty && priceItem.isNotEmpty)
      {
        commonViewModel.showSnackBar("Uploading now, please wait...", context);

        String uniqueFileID = DateTime.now().millisecondsSinceEpoch.toString();

        String downloadUrl = await uploadImageToStorage(uniqueFileID);

        await saveItemInfoToDatabase(infoText, titleText, descriptionText, priceItem, downloadUrl, menuModel, uniqueFileID, context);
      }
      else {
        commonViewModel.showSnackBar("Please fill all fields.", context);
      }
    }
    else {
      commonViewModel.showSnackBar("Please select item image.", context);
    }
  }

  uploadImageToStorage(uniqueFileID) async {

    fStorage.Reference reference = fStorage.FirebaseStorage.instance.ref().child("itemImages");

    fStorage.UploadTask uploadTask = reference.child(uniqueFileID + ".jpg").putFile(File(imageFile!.path));

    fStorage.TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});

    String downloadURL = await taskSnapshot.ref.getDownloadURL();

    return downloadURL;
  }

  saveItemInfoToDatabase(infoText, titleText, descriptionText, priceItem, downloadUrl, Menu menuModel, uniqueFileID, context) async
  {


    final referenceSeller = FirebaseFirestore.instance
        .collection("sellers")
        .doc(sharedPreferences!.getString("uid"))
        .collection("menus")
        .doc(menuModel.menuID)
        .collection("items");

    final referenceMain = FirebaseFirestore.instance.collection("items");

    await referenceSeller.doc(uniqueFileID).set(
        {
          "menuID": menuModel.menuID,
          "menuName": menuModel.menuTitle,
          "itemID": uniqueFileID,
          "sellerUID":sharedPreferences!.getString("uid"),
          "sellerName":sharedPreferences!.getString("name"),
          "itemInfo":infoText,
          "itemTitle":titleText,
          "itemImage":downloadUrl,
          "description":descriptionText,
          "price":int.parse(priceItem),
          "publishedDateTime":DateTime.now(),
          "status":"available",
    }).then((value) async
    {
      await referenceMain.doc(uniqueFileID).set(
          {
            "menuID": menuModel.menuID,
            "menuName": menuModel.menuTitle,
            "itemID": uniqueFileID,
            "sellerUID":sharedPreferences!.getString("uid"),
            "sellerName":sharedPreferences!.getString("name"),
            "itemInfo":infoText,
            "itemTitle":titleText,
            "itemImage":downloadUrl,
            "description":descriptionText,
            "price":int.parse(priceItem),
            "publishedDateTime":DateTime.now(),
            "status":"available",
            "isRecommended":false,
            "isPopular":false,
          });
    });

    commonViewModel.showSnackBar("Uploaded Successfully", context);
  }
  
  retrieveItems(menuID)
  {
    return FirebaseFirestore.instance
        .collection("sellers")
        .doc(sharedPreferences!.getString("uid"))
        .collection("menus")
        .doc(menuID)
        .collection("items")
        .orderBy("publishedDateTime", descending: true)
        .snapshots();
  }
}
