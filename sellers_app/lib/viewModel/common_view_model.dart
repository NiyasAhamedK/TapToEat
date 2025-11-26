import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';

import '../global/global_vars.dart';

class CommonViewModel {
  getCurrentLocation() async
  {
    Position cPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    position = cPosition;
    placeMark =
    await placemarkFromCoordinates(cPosition.latitude, cPosition.longitude);

    Placemark placeMarkVar = placeMark![0];

    fullAddress = "${placeMarkVar.subThoroughfare} ${placeMarkVar
        .thoroughfare}, ${placeMarkVar.subLocality} ${placeMarkVar
        .locality}, ${placeMarkVar.subAdministrativeArea}, ${placeMarkVar
        .administrativeArea}, ${placeMarkVar.postalCode}, ${placeMarkVar
        .country}";

    return fullAddress;
  }

  updateLocationInDatabase() async
  {
    String address = await getCurrentLocation();

    await FirebaseFirestore.instance
        .collection("sellers")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update(
        {
          "address": address,
          "latitude": position!.latitude,
          "longitude": position!.longitude,
        });
  }

  showSnackBar(String message, BuildContext context) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  showDialogWithImageOption(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: const Text(
              "Choose Option",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            children: [
              SimpleDialogOption(
                onPressed: () async {
                  await captureImageWithPhoneCamera();

                  Navigator.pop(context, "selected");
                },
                child: Text(
                  "Capture with Camera",
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              SimpleDialogOption(
                onPressed: () async {
                  await pickImageFromGallery();

                  Navigator.pop(context, "selected");
                },
                child: Text(
                  "Select From Gallery",
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              SimpleDialogOption(
                onPressed: (){
                    Navigator.pop(context);
                },
                child: Text(
                  "Cancel",
                  style: TextStyle(color: Colors.grey),
                ),
              )
            ],
          );
        }
    );
  }

  pickImageFromGallery() async
  {
    imageFile = await pickerImage.pickImage(source: ImageSource.gallery);

  }
  captureImageWithPhoneCamera() async
  {
    imageFile = await pickerImage.pickImage(source: ImageSource.camera);


  }
}