class Address
{
  String? name;
  String? phoneNumber;
  String? flatNumber;
  String? city;
  String? state;
  String? fullAddress;
  double? lat; // Stored as number in Firestore, must be parsed as double
  double? lng; // Stored as number in Firestore, must be parsed as double

  // NEW FIELDS to link the saved address back to the fixed building
  String? buildingName;
  String? buildingAddressID;

  Address(
      {
        this.name,
        this.phoneNumber,
        this.flatNumber,
        this.city,
        this.state,
        this.fullAddress,
        this.lat,
        this.lng,
        this.buildingName,
        this.buildingAddressID,
      }
      );

  // CORRECTED: Safe parsing for lat/lng (from 'number' to 'double') and added new fields.
  factory Address.fromJson(Map<String, dynamic> json)
  {
    // The fixed 'building' documents will NOT have name/phoneNumber, so they are optional here.
    return Address(
      name: json['name'] as String?,
      phoneNumber: json['phoneNumber'] as String?,

      // Geographic data
      flatNumber: json['flatNumber'] as String?,
      city: json['city'] as String?,
      state: json['state'] as String?,
      fullAddress: json['fullAddress'] as String?,

      // CRITICAL FIX: Safely cast Firestore number (num) to Dart double
      // This is essential for lat and lng fields
      lat: json['lat'] is num ? (json['lat'] as num).toDouble() : null,
      lng: json['lng'] is num ? (json['lng'] as num).toDouble() : null,

      // Linking Fields (will be null when reading from the fixed 'building' collection)
      // NOTE: We assume the building's main 'name' field is used as the buildingName.
      buildingName: json['buildingName'] as String? ?? json['name'] as String?,
      buildingAddressID: json['buildingAddressID'] as String?,
    );
  }

  // NEW METHOD: Required to convert the Address object back to a Map
  // for saving the combined data to the user's Firestore subcollection.
  Map<String, dynamic> toJson()
  {
    return {
      'name': name,
      'phoneNumber': phoneNumber,
      'flatNumber': flatNumber,
      'city': city,
      'state': state,
      'fullAddress': fullAddress,
      'lat': lat,
      'lng': lng,
      'buildingName': buildingName,
      'buildingAddressID': buildingAddressID,
    };
  }
}