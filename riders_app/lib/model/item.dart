import 'package:cloud_firestore/cloud_firestore.dart';

class Item
{
  String? menuID;
  String? menuName;
  String? itemID;
  String? sellerUID;
  String? sellerName;
  String? itemInfo;
  String? itemTitle;
  String? itemImage;
  String? description;
  int? price;
  Timestamp? publishedDateTime;
  String? status;
  bool? isRecommended;
  bool? isPopular;

  Item({
    this.menuID,
    this.menuName,
    this.itemID,
    this.sellerUID,
    this.sellerName,
    this.itemInfo,
    this.itemTitle,
    this.itemImage,
    this.description,
    this.price,
    this.publishedDateTime,
    this.status,
    this.isRecommended,
    this.isPopular
  });

  Item.fromJson(Map<String, dynamic> json)
  {
    menuID = json["menuID"];
    menuName = json["menuName"];
    itemID = json["itemID"];
    sellerUID = json["sellerUID"];
    sellerName = json["sellerName"];
    itemInfo = json["itemInfo"];
    itemTitle = json["itemTitle"];
    itemImage = json["itemImage"];
    description = json["description"];
    price = json["price"];
    publishedDateTime = json["publishedDateTime"];
    status = json["status"];
    isRecommended = json["isRecommended"];
    isPopular = json["isPopular"];
  }
}