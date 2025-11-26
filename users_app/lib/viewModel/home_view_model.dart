import 'package:cloud_firestore/cloud_firestore.dart';

class HomeViewModel{

  readBannersFromFirestore() async{

    List bannersList =[];
    await FirebaseFirestore.instance.collection("banners").get().then((QuerySnapshot querySnapshot)
    {
      querySnapshot.docs.forEach((document)
      {

        bannersList.add(document["image"]);

      });

    });
    return bannersList;


}

  readCategoriesFromFirestore() async{

    List categoriesList =[];
    await FirebaseFirestore.instance.collection("categories").get().then((QuerySnapshot querySnapshot)
    {
      querySnapshot.docs.forEach((document)
      {

        categoriesList.add(document["name"]);

      });

    });
    return categoriesList;


  }

  readRecommendedItemsFromFiresore(){
    return FirebaseFirestore.instance.collection("items")
        .where("isRecommended",isEqualTo:  true)
        .snapshots();
  }
  readPopularItemsFromFiresore(){
    return FirebaseFirestore.instance.collection("items")
        .where("isPopular",isEqualTo:  true)
        .snapshots();
  }
  readSellersFromFirestore()
  {
    return FirebaseFirestore.instance
        .collection("sellers")
        .snapshots();
  }
}