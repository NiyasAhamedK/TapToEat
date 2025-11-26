import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:users_app/global/global_instances.dart';
import 'package:users_app/global/global_vars.dart';

class AddressViewModel
{
  // -----------------------------------------------------------
  // 1. UPDATED SAVE METHOD: Now combines user input with fixed building data
  //    (Note: The method signature is longer to explicitly pass all necessary data)
  // -----------------------------------------------------------
  saveShipmentAddressToDatabase(
      String name,                      // User Input: Recipient Name
      String phoneNumber,               // User Input: Recipient Phone
      String buildingName,              // Fixed: Building Display Name
      String buildingAddressID,         // Fixed: Document ID for linking
      String city,                      // Fixed: City from Building
      String state,                     // Fixed: State from Building
      String fullAddress,               // Fixed: Full Address from Building
      String flatNumberFromBuilding,    // Fixed: Unit/Ground Floor from Building
      double lat,                       // Fixed: Latitude from Building
      double lng,                       // Fixed: Longitude from Building
      BuildContext context
      )
  {
    FirebaseFirestore.instance.collection("users")
        .doc(sharedPreferences!.getString("uid"))
        .collection("userAddress")
        .doc(DateTime.now().millisecondsSinceEpoch.toString())
        .set(
        {
          // User Input
          "name": name,
          "phoneNumber": phoneNumber,

          // Fixed Geographic Data (from the selected building)
          "buildingName": buildingName,
          "buildingAddressID": buildingAddressID,
          "flatNumber": flatNumberFromBuilding, // e.g., "Main Lobby"
          "city": city,
          "state": state,
          "fullAddress": fullAddress,
          "lat": lat,
          "lng": lng,
        }
    ).then((value){
      commonViewModel.showSnackBar("New Address has been saved", context);
    });
  }

  // -----------------------------------------------------------
  // 2. EXISTING METHOD: Retrieves addresses saved by the user
  // -----------------------------------------------------------
  retrieveUserShipmentAddress(){
    return FirebaseFirestore.instance.collection("users")
        .doc(sharedPreferences!.getString("uid"))
        .collection("userAddress")
        .snapshots();
  }

  // -----------------------------------------------------------
  // 3. NEW METHOD: Retrieves the list of fixed buildings
  // -----------------------------------------------------------
  retrieveFixedBuildings(){
    // Reads from the top-level collection you created
    return FirebaseFirestore.instance
        .collection("building")
        .snapshots();
  }

  // -----------------------------------------------------------
  // 4. GOOGLE MAPS METHOD: Fixed URL and improved launch method
  // -----------------------------------------------------------
  openGoogleMapWithGeoGraphicPosition(double latitude, double longitude) async
  {
    // Use the standard URL scheme for launching a precise location
    String googleMapUrl = "https://www.google.com/maps/search/?api=1&query=$latitude,$longitude";

    // Check if the URL can be launched
    if(await canLaunchUrl(Uri.parse(googleMapUrl)))
    {
      // Use external application mode for a better map experience
      await launchUrl(Uri.parse(googleMapUrl), mode: LaunchMode.externalApplication);
    }
    else
    {
      throw "Could not open the Google map.";
    }
  }
}