import 'package:admin_web_panel/view/main_screens/home_screen.dart';
import 'package:admin_web_panel/view/widgets/my_appbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class AllVerifiedSellersScreen extends StatefulWidget {
  const AllVerifiedSellersScreen({super.key});

  @override
  State<AllVerifiedSellersScreen> createState() => _AllVerifiedSellersScreenState();
}

class _AllVerifiedSellersScreenState extends State<AllVerifiedSellersScreen>
{
  QuerySnapshot? allSellers;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    FirebaseFirestore.instance
        .collection("sellers")
        .where("status", isEqualTo: "approved")
        .get()
        .then((allVerifiedSellers)
    {
      setState(() {
        allSellers = allVerifiedSellers;
      });
    });
  }

  displayDialogBoxForBlockingAccount(sellerDocumentID)
  {
    return showDialog(
        context: context,
        builder: (BuildContext context)
        {
          return AlertDialog(

            title: const Text(
              "Block Account",
              style: TextStyle(
                fontSize: 25,
                letterSpacing: 2,
                fontWeight: FontWeight.bold,
              ),
            ),

            content: const Text(
              "Do you want to block this account ?",
              style: TextStyle(
                fontSize: 16,
                letterSpacing: 2,
              ),
            ),

            actions: [

              ElevatedButton(
                onPressed: ()
                {
                  Navigator.pop(context);
                },
                child: const Text("No"),
              ),

              ElevatedButton(
                onPressed: ()
                {
                  Map<String, dynamic> sellerDataMap =
                  {
                    "status": "not approved",
                  };

                  FirebaseFirestore.instance
                      .collection("sellers")
                      .doc(sellerDocumentID)
                      .update(sellerDataMap)
                      .then((value)
                  {
                    Navigator.push(context, MaterialPageRoute(builder: (c)=> const HomeScreen()));

                    SnackBar snackBar= const SnackBar(
                      content: Text(
                        "Blocked Successfully.",
                        style: TextStyle(
                          fontSize: 36,
                          color: Colors.black,
                        ),
                      ),
                      backgroundColor: Colors.red,
                      duration: Duration(seconds: 2),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  });


                },
                child: const Text("Yes"),
              ),

            ],

          );
        }
    );
  }

  Widget displayVerifiedSellersUI()
  {
    if(allSellers != null)
    {
      return ListView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: allSellers!.docs.length,
        itemBuilder: (context, i)
        {
          return Card(
            elevation: 10,
            child: Column(
              children: [

                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ListTile(

                    leading: Container(
                      width: 65,
                      height: 65,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image: NetworkImage(allSellers!.docs[i].get("image"))
                        ),
                      ),
                    ),

                    title: Text(
                      allSellers!.docs[i].get("name"),
                    ),

                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [

                        const Icon(Icons.email, color: Colors.white,),

                        const SizedBox(width: 20,),

                        Text(
                          allSellers!.docs[i].get("email"),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                      ],
                    ),

                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: ElevatedButton.icon(
                    onPressed: ()
                    {
                      displayDialogBoxForBlockingAccount(allSellers!.docs[i].id);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    icon: const Icon(
                      Icons.person_pin_sharp,
                      color: Colors.white,
                    ),
                    label: Text(
                      "Block This Account".toUpperCase(),
                      style: const TextStyle(
                        fontSize: 15,
                        color: Colors.white,
                        letterSpacing: 3,
                      ),
                    ),
                  ),
                ),

              ],
            ),
          );
        },
      );
    }
    else
    {
      return const Center(
        child: Text(
          "No Records Found.",
          style: TextStyle(
              fontSize: 30
          ),
        ),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppbar(titleMsg: "All Verified Sellers Accounts", showBackButton: true),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * .5,
          child: displayVerifiedSellersUI(),
        ),
      ),
    );
  }
}
