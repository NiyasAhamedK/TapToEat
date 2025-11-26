class Seller
{
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

  Seller.fromJson(Map<String, dynamic> json)
  {
    uid = json["uid"];
    email = json["email"];
    name = json["name"];
    image = json["image"];
    phone = json["phone"];
    address = json["address"];
    status = json["status"];
    earning = json["earning"];
    latitude = json["latitude"];
    longitude = json["longitude"];
  }
}