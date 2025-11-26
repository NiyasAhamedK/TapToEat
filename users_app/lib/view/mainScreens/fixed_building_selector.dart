// fixed_building_selector.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:users_app/model/address.dart';
import 'package:users_app/global/global_instances.dart';

// Function that returns a Future with the selected Address model and its ID
Future<Map<String, dynamic>?> showBuildingSelector(BuildContext context) {
  return showModalBottomSheet<Map<String, dynamic>?>(
    context: context,
    isScrollControlled: true,
    builder: (BuildContext context) {
      return SizedBox(
        height: MediaQuery.of(context).size.height * 0.75,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text("Select Your Building", style: Theme.of(context).textTheme.titleLarge),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                // Calls the new method in your ViewModel
                stream: addressViewModel.retrieveFixedBuildings(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text("No Buildings available."));
                  }

                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot doc = snapshot.data!.docs[index];
                      // Uses the Address.fromJson factory you just updated
                      Address model = Address.fromJson(doc.data()! as Map<String, dynamic>);

                      return ListTile(
                        leading: const Icon(Icons.apartment),
                        title: Text(model.name ?? "Building Name"),
                        subtitle: Text("${model.fullAddress}, Unit: ${model.flatNumber}"),
                        onTap: () {
                          // Return the selected model data (with all fixed fields) and its ID
                          Navigator.pop(context, {'model': model, 'id': doc.id});
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      );
    },
  );
}