import 'package:flutter/material.dart';
import 'package:sellers_app/global/global_instances.dart';
import 'package:sellers_app/global/global_vars.dart';
import 'package:sellers_app/view/mainScreens/home_screen.dart';
import 'package:sellers_app/view/widgets/my_appbar.dart';
import 'dart:io';


class MenusUploadScreen extends StatefulWidget {
  const MenusUploadScreen({super.key});

  @override
  State<MenusUploadScreen> createState() => _MenusUploadScreenState();
}





class _MenusUploadScreenState extends State<MenusUploadScreen> {

  TextEditingController infoTextEditingController = TextEditingController();
  String menuTitleCategoryName = "";


  defaultScreen()
  {
    return Scaffold(
      appBar:MyAppbar(
          titleMsg: "Add New Menu",
          showBackButton: true),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.shop_two,
              color: Colors.black87,
              size: 200,
            ),
            ElevatedButton(
              onPressed:() async {
                String response = await commonViewModel.showDialogWithImageOption(context);

                if(response == "selected")
                {
                  setState(() {
                    imageFile;
                  });
                }

              } ,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
              ),
              child: const Text(
                  "Add New Menu ",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  )
              ),
            ),
          ],
        ),
      ),
    );
  }

  uploadMenuFormScreen()
  {
    return Scaffold(
      appBar: MyAppbar(
        titleMsg: "Upload New Menu",
        showBackButton: true,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black87,
          onPressed: ()
          {
            setState(() {
              imageFile = null;
              menuTitleCategoryName = "";
              infoTextEditingController.clear();
            });
          },
          child: const Icon(
            Icons.close,
            color: Colors.white,
          ),
      ),
      body: ListView(
        children: [

          SizedBox(
            height: 230,
            width: MediaQuery.of(context).size.width * 0.8,
            child: Center(
              child: AspectRatio(
                  aspectRatio: 16/9,
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage
                      (image: FileImage(
                      File(
                        imageFile!.path
                      ),
                    ),
                      fit: BoxFit.cover,
                    )
                  ),
                ),
              ),
            ),
          ),

          const Divider(
            color: Colors.grey,
            thickness: 1,
          ),

          const SizedBox(height: 10,),

          ListTile(
            leading: const Icon(Icons.perm_device_information, color: Colors.black87,),
            title: TextField(
              style: const TextStyle(color: Colors.black),
              maxLines: 1,
              controller: infoTextEditingController,
              decoration: const InputDecoration(
                hintText: "menu info",
                hintStyle: TextStyle(color: Colors.grey),
                border: InputBorder.none,
              ),
            ),
          ),

          const Divider(
            color: Colors.grey,
            thickness: 1,
          ),

          Padding(
            padding: const EdgeInsets.all(26.0),
            child: DropdownButtonFormField(
              hint: const Text("Selected Category", style: TextStyle(color: Colors.black),),
              items: categoryList.map<DropdownMenuItem<String>>((categoryName)
              {
                return DropdownMenuItem(
                  value: categoryName,
                  child: Text(categoryName, style: const TextStyle(color: Colors.black87),),
                );
              }).toList(),
              onChanged: (value)
              {
                setState(() {
                  menuTitleCategoryName = value.toString();
                });

                commonViewModel.showSnackBar(menuTitleCategoryName, context);
              },
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ElevatedButton(
                onPressed: () async
                {
                  await  menuViewModel.validateMenuUploadForm(
                    infoTextEditingController.text,
                    menuTitleCategoryName,
                    context,
                  );

                  setState(() {
                    imageFile= null;
                  });
                  Navigator.push(context, MaterialPageRoute(builder: (c)=> HomeScreen()));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black87,
                ),
                child: const Text(
                  "Upload",
                  style: TextStyle(
                    color: Colors.white
                  ),
                )
            ),
          ),


        ],
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    menuViewModel.getCategories();
  }

  @override
  Widget build(BuildContext context) {
    return imageFile == null ? defaultScreen() : uploadMenuFormScreen();
  }
}
