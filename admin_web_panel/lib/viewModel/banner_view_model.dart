import 'package:admin_web_panel/global/global_vars.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';


class BannerViewModel
{

  uploadBannerImageToStoarage() async
  {
    imageDocID = DateTime.now().millisecondsSinceEpoch.toString() + fileName.toString();

    Reference bannersRef = FirebaseStorage.instance.ref()
        .child("bannerImages")
        .child(imageDocID);

    UploadTask uploadTask = bannersRef.putData(imageFile);

    TaskSnapshot taskSnapshot = await uploadTask.whenComplete((){});

    String downloadUrl = await taskSnapshot.ref.getDownloadURL();

    return downloadUrl;
  }

  saveBannerImageInfoToFirestore() async
  {
    String downloadUrl = await uploadBannerImageToStoarage();

    await FirebaseFirestore.instance.collection("banners").doc(imageDocID)
        .set(
        {
          "image": downloadUrl,
        });

  }
  
  readBannersFromFirestore()
  {
    Stream<QuerySnapshot> bannersStreamQuerySnapshot = FirebaseFirestore.instance
        .collection("banners")
        .snapshots();

    return bannersStreamQuerySnapshot;
  }

}