import 'package:admin_web_panel/view/main_screens/home_screen.dart';
import 'package:admin_web_panel/view/widgets/my_appbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class AllBlockedUsersScreen extends StatefulWidget {
  const AllBlockedUsersScreen({super.key});

  @override
  State<AllBlockedUsersScreen> createState() => _AllBlockedUsersScreenState();
}

class _AllBlockedUsersScreenState extends State<AllBlockedUsersScreen>
{
  QuerySnapshot? allUsers;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    FirebaseFirestore.instance
        .collection("users")
        .where("status", isEqualTo: "not approved")
        .get()
        .then((allBlockedUsers)
    {
      setState(() {
        allUsers = allBlockedUsers;
      });
    });
  }

  displayDialogBoxForApprovingAccount(userDocumentID)
  {
    return showDialog(
        context: context,
        builder: (BuildContext context)
        {
          return AlertDialog(

            title: const Text(
              "Approve Account",
              style: TextStyle(
                fontSize: 25,
                letterSpacing: 2,
                fontWeight: FontWeight.bold,
              ),
            ),

            content: const Text(
              "Do you want to approve this account ?",
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
                  Map<String, dynamic> userDataMap =
                  {
                    "status": "approved",
                  };

                  FirebaseFirestore.instance
                      .collection("users")
                      .doc(userDocumentID)
                      .update(userDataMap)
                      .then((value)
                  {
                    Navigator.push(context, MaterialPageRoute(builder: (c)=> const HomeScreen()));

                    SnackBar snackBar= const SnackBar(
                      content: Text(
                        "Approved Successfully.",
                        style: TextStyle(
                          fontSize: 36,
                          color: Colors.black,
                        ),
                      ),
                      backgroundColor: Colors.green,
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

  Widget displayBlockedUsersUI()
  {
    if(allUsers != null)
    {
      return ListView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: allUsers!.docs.length,
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
                            image: NetworkImage(allUsers!.docs[i].get("image"))
                        ),
                      ),
                    ),

                    title: Text(
                      allUsers!.docs[i].get("name"),
                    ),

                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [

                        const Icon(Icons.email, color: Colors.white,),

                        const SizedBox(width: 20,),

                        Text(
                          allUsers!.docs[i].get("email"),
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
                      displayDialogBoxForApprovingAccount(allUsers!.docs[i].id);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    icon: const Icon(
                      Icons.person_pin_sharp,
                      color: Colors.white,
                    ),
                    label: Text(
                      "Approve This Account".toUpperCase(),
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
      appBar: MyAppbar(titleMsg: "All Blocked Users Accounts", showBackButton: true),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * .5,
          child: displayBlockedUsersUI(),
        ),
      ),
    );
  }
}
