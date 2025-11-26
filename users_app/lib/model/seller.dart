class Seller {
  String? uid;
  String? email;
  String? name;
  String? image;
  String? phone;
  String? address;
  String? status;
  double? earning;
  double? latitude;
  double? longitude;

  Seller({
    this.uid,
    this.email,
    this.name,
    this.image,
    this.phone,
    this.address,
    this.status,
    this.earning,
    this.latitude,
    this.longitude,
  });

  Seller.fromJson(Map<String, dynamic> json) {
    uid = json["uid"];
    email = json["email"];
    name = json["name"];
    image = json["image"];
    phone = json["phone"];
    address = json["address"];
    status = json["status"];
    // earning = json["earning"];
    // latitude = json["latitude"];
    // longitude = json["longitude"];

    // ✅ handle both string and double values safely
    earning = (json["earning"] is String)
        ? double.tryParse(json["earning"]) ?? 0.0
        : (json["earning"] ?? 0.0).toDouble();

    latitude = (json["latitude"] is String)
        ? double.tryParse(json["latitude"]) ?? 0.0
        : (json["latitude"] ?? 0.0).toDouble();

    longitude = (json["longitude"] is String)
        ? double.tryParse(json["longitude"]) ?? 0.0
        : (json["longitude"] ?? 0.0).toDouble();
  }
}
