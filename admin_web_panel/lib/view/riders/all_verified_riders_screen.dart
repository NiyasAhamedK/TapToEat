import 'package:admin_web_panel/view/main_screens/home_screen.dart';
import 'package:admin_web_panel/view/widgets/my_appbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class AllVerifiedRidersScreen extends StatefulWidget {
  const AllVerifiedRidersScreen({super.key});

  @override
  State<AllVerifiedRidersScreen> createState() => _AllVerifiedRidersScreenState();
}

class _AllVerifiedRidersScreenState extends State<AllVerifiedRidersScreen>
{
  QuerySnapshot? allRiders;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    FirebaseFirestore.instance
        .collection("riders")
        .where("status", isEqualTo: "approved")
        .get()
        .then((allVerifiedRiders)
    {
      setState(() {
        allRiders = allVerifiedRiders;
      });
    });
  }

  displayDialogBoxForBlockingAccount(riderDocumentID)
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
                  Map<String, dynamic> riderDataMap =
                  {
                    "status": "not approved",
                  };

                  FirebaseFirestore.instance
                      .collection("riders")
                      .doc(riderDocumentID)
                      .update(riderDataMap)
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

  Widget displayVerifiedRidersUI()
  {
    if(allRiders != null)
    {
      return ListView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: allRiders!.docs.length,
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
                            image: NetworkImage(allRiders!.docs[i].get("image"))
                        ),
                      ),
                    ),

                    title: Text(
                      allRiders!.docs[i].get("name"),
                    ),

                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [

                        const Icon(Icons.email, color: Colors.white,),

                        const SizedBox(width: 20,),

                        Text(
                          allRiders!.docs[i].get("email"),
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
                      displayDialogBoxForBlockingAccount(allRiders!.docs[i].id);
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
      appBar: MyAppbar(titleMsg: "All Verified Riders Accounts", showBackButton: true),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * .5,
          child: displayVerifiedRidersUI(),
        ),
      ),
    );
  }
}
