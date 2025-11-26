import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:users_app/view/widgets/seller_ui_design.dart';

import '../../model/seller.dart';
class SearchCafesScreen extends StatefulWidget {
  const SearchCafesScreen({super.key});

  @override
  State<SearchCafesScreen> createState() => _SearchCafesScreenState();
}

class _SearchCafesScreenState extends State<SearchCafesScreen> {

  Future<QuerySnapshot>? restaurentsDocumentsList;
  String sellerNameText="";
  initSearchingRestaurant(String textEntered){

    restaurentsDocumentsList=FirebaseFirestore.instance
        .collection("sellers")
        .where("name",isGreaterThanOrEqualTo: textEntered)
        .get();
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initSearchingRestaurant("");
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black87,
        title: TextField(
          onChanged: (textEntered){
            setState(() {
              sellerNameText = textEntered;
            });
            initSearchingRestaurant(textEntered);
          },
          decoration: InputDecoration(
            hintText: "Search Specific Cafes & Restaurent here...",
            hintStyle: const TextStyle(color:Colors.white54,fontSize: 12),
            border: InputBorder.none,
            suffixIcon: IconButton(
              icon: const Icon(Icons.search),
              color: Colors.white,
              onPressed: (){
                initSearchingRestaurant(sellerNameText);
              },)
          ),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
      ),
      body: FutureBuilder<QuerySnapshot>(
          future: restaurentsDocumentsList,
          builder: (context,snapshot){
            return snapshot.hasData
                ?ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context,index){
                  Seller model = Seller.fromJson(
                    snapshot.data!.docs[index].data()! as Map<String, dynamic>
                  );
                  return Card(
                    elevation: 6,
                    color: Colors.black87,
                    child: SellerUIDesign(

                      sellerModel: model,
                    ),
                  );
                }
                )
                :const Center(child: CircularProgressIndicator(),);
          }
          ),
    );
  }
}
