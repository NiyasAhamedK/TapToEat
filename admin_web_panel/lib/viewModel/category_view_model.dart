import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../global/global_vars.dart';

class CategoryViewModel
{


  uploadCategoryImageToStoarage() async
  {
    imageDocID = DateTime.now().millisecondsSinceEpoch.toString() + fileName.toString();

    Reference bannersRef = FirebaseStorage.instance.ref()
        .child("categoryImages")
        .child(imageDocID);

    UploadTask uploadTask = bannersRef.putData(imageFile);

    TaskSnapshot taskSnapshot = await uploadTask.whenComplete((){});

    String downloadUrl = await taskSnapshot.ref.getDownloadURL();

    return downloadUrl;
  }

  saveCategoryInfoToFirestore() async
  {
    String downloadUrl = await uploadCategoryImageToStoarage();

    await FirebaseFirestore.instance.collection("categories").doc(imageDocID)
        .set(
        {
          "image": downloadUrl,
          "name": categoryName,
        });

  }

  readCategoriesFromFirestore()
  {
    Stream<QuerySnapshot> bannersStreamQuerySnapshot = FirebaseFirestore.instance
        .collection("categories")
        .snapshots();

    return bannersStreamQuerySnapshot;
  }
}