// In lib/model/address.dart (Rider App)

class Address
{
  String? name;
  String? phoneNumber;
  String? flatNumber;
  String? city;
  String? state;
  String? fullAddress;
  double? lat;
  double? lng;

  // ADDED: Fields saved from the fixed building selection
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

  Address.fromJson(Map<String, dynamic> json)
  {
    name = json['name'] as String?;
    phoneNumber = json['phoneNumber'] as String?;
    flatNumber = json['flatNumber'] as String?; // Fixed Unit/Delivery point
    city = json['city'] as String?;
    state = json['state'] as String?;
    fullAddress = json['fullAddress'] as String?;

    // Safely cast num to double for lat/lng
    lat = (json['lat'] as num?)?.toDouble();
    lng = (json['lng'] as num?)?.toDouble();

    // ADDED: New fields for the fixed building
    buildingName = json['buildingName'] as String?;
    buildingAddressID = json['buildingAddressID'] as String?;
  }

  Map<String, dynamic> toJson() =>
      {
        'name': name,
        'phoneNumber': phoneNumber,
        'flatNumber': flatNumber,
        'city': city,
        'state': state,
        'fullAddress': fullAddress,
        'lat': lat,
        'lng': lng,
        'buildingName': buildingName, // Added
        'buildingAddressID': buildingAddressID, // Added
      };
}