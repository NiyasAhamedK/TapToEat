import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:users_app/global/global_instances.dart';
import 'package:users_app/view/widgets/item_ui_design.dart';
import 'package:users_app/view/widgets/my_appbar.dart';
import 'package:users_app/view/widgets/rp_item_ui_design.dart';
import 'package:users_app/view/widgets/seller_ui_design.dart';

import '../../model/item.dart';
import '../../model/seller.dart';
import '../widgets/my_drawer.dart';



class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}



class _HomeScreenState extends State<HomeScreen>
{
  List bannerImagesList = [];
  List categoriesList = [];
  updateUI() async{
    bannerImagesList = await homeViewModel.readBannersFromFirestore();
    categoriesList = await homeViewModel.readCategoriesFromFirestore();
    setState(() {
      bannerImagesList;
      categoriesList;
    });

    cartViewModel.clearCartNow(context);

  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    updateUI();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(),
      appBar: MyAppbar(
          titleMsg: "TapToEat",
          showBackButton: false),
      body: SingleChildScrollView(
        child: Column(
          children: [
            //banners
            Padding(
                padding: const EdgeInsets.only(top: 6,left: 10,right: 10),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * .3,
                  width: MediaQuery.of(context).size.width,
                  child: CarouselSlider(
                      options: CarouselOptions(
                        height: MediaQuery.of(context).size.height * .3,
                        aspectRatio: 16/9,
                        viewportFraction: 0.8,
                        initialPage: 0,
                        enableInfiniteScroll: true,
                        autoPlay: true,
                        reverse: false,
                        autoPlayInterval: const Duration(seconds: 4),
                        autoPlayAnimationDuration: const Duration(milliseconds: 500),
                        autoPlayCurve: Curves.easeInOut,
                        enlargeCenterPage: true,
                        scrollDirection: Axis.horizontal,
                      ),
                      items: bannerImagesList.map((index){
                        return Builder(
                            builder: (BuildContext context){

                              return Container(
                                width: MediaQuery.of(context).size.width,
                                margin: const EdgeInsets.symmetric(horizontal: 1.0),
                                decoration: const BoxDecoration(
                                  color: Colors.black,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(3.0),
                                  child: Image.network(
                                    index,
                                    width: MediaQuery.of(context).size.width,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              );
                            },
                        );
                  }).toList(),

                ),


            ),
            ),
            const SizedBox(height: 8,),
            //categories
            const Padding(
                padding: const EdgeInsets.only(left:4.0),
                child:Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Categories: ",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                ),
                ),
                ),
            ),

            SizedBox(
              height: 60,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: categoriesList.map((index)
                {
                  return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5.0),
                      child: ChoiceChip(
                          showCheckmark: false,
                          label: Text(
                            index,
                            style: const TextStyle(
                              fontSize:  15,
                            ),
                          ),
                          selected: categoriesList.contains(index),
                          onSelected: (c){
                            //commonViewModel.showSnackBar(index,context);
                          },
                        backgroundColor: Colors.white30,
                      ),
                  );
                }).toList(),
              ),
            ),

            //recommended
            const Padding(
              padding: const EdgeInsets.only(left:4.0),
              child:Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Recommended: ",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 264,
              child: StreamBuilder<QuerySnapshot>(
                  stream: homeViewModel.readRecommendedItemsFromFiresore(),
                  builder: (context, snapshot)
                  {
                      return !snapshot.hasData ? Center(child: Text("No Recommended Items"),)
                          : ListView.builder(

                              scrollDirection: Axis.horizontal,
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (context,index)
                              {
                                Item itemModel = Item.fromJson(
                                  snapshot.data!.docs[index].data() as Map<String, dynamic>
                                );
                                return Card(
                                  elevation: 6,
                                  child: RPItemUIDesign(
                                    itemModel: itemModel,
                                  ),
                                );
                              },
                      );
                  },
                  ),
            ),

            const SizedBox(height: 8,),

            //popular
            const Padding(
              padding: const EdgeInsets.only(left:4.0),
              child:Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Popular: ",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 264,
              child: StreamBuilder<QuerySnapshot>(
                stream: homeViewModel.readPopularItemsFromFiresore(),
                builder: (context, snapshot)
                {
                  return !snapshot.hasData ? Center(child: Text("No Popular Items"),)
                      : ListView.builder(

                    scrollDirection: Axis.horizontal,
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context,index)
                    {
                      Item itemModel = Item.fromJson(
                          snapshot.data!.docs[index].data() as Map<String, dynamic>
                      );
                      return Card(
                        elevation: 6,
                        child: RPItemUIDesign(
                          itemModel: itemModel,
                        ),
                      );
                    },
                  );
                },
              ),
            ),

            const SizedBox(height: 8,),

            //sellers-cafes/restaurents
            const Padding(
              padding: const EdgeInsets.only(left:4.0),
              child:Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Cafes & Restaurents: ",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height:10,),
            SizedBox(
              height: 284,
              child: StreamBuilder<QuerySnapshot>(
                stream: homeViewModel.readSellersFromFirestore(),
                builder: (context, snapshot)
                {
                  return !snapshot.hasData ? Center(child: Text("No Seller found"),)
                      : ListView.builder(

                    scrollDirection: Axis.horizontal,
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context,index)
                    {
                      Seller sellerModel = Seller.fromJson(
                          snapshot.data!.docs[index].data() as Map<String, dynamic>
                      );
                      return Card(
                        elevation: 6,
                        child: SellerUIDesign(
                          sellerModel: sellerModel,
                        ),
                      );
                    },
                  );
                },
              ),
            ),



          ],
        ),
      ),
    );
  }
}
