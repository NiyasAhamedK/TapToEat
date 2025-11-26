import 'package:admin_web_panel/global/global_ins.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BannerList extends StatelessWidget {
  const BannerList({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: bannerViewModel.readBannersFromFirestore(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> dataSnapshot)
        {
          if(dataSnapshot.hasError)
          {
            return const Text(
              "Error Occurred.",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 24,
              ),
            );
          }

          if(dataSnapshot.connectionState == ConnectionState.waiting)
          {
            return const Text(
              "Loading, Please wait...",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 24,
              ),
            );
          }

          if(dataSnapshot.data!.docs.isEmpty)
          {
            return const Text(
              "no banner available yet.",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 24,
              ),
            );
          }

          return GridView.builder(
            shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 6,
                mainAxisSpacing: 8,
                crossAxisSpacing: 6,
              ),
              itemCount: dataSnapshot.data!.docs.length,
              itemBuilder: (context, index)
              {
                var eachBanner = dataSnapshot.data!.docs[index];

                return Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        height: 100,
                        width: 100,
                        child: Image.network(
                          eachBanner["image"],
                          width: double.infinity,
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                    ],
                  ),
                );
              }
          );
        }
    );
  }
}
