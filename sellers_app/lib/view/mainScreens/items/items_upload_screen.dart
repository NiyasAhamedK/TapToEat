import 'package:flutter/material.dart';
import 'package:sellers_app/global/global_instances.dart';
import 'package:sellers_app/global/global_vars.dart';
import 'package:sellers_app/view/mainScreens/home_screen.dart';
import 'package:sellers_app/view/widgets/my_appbar.dart';
import 'dart:io';
import 'package:sellers_app/viewModel/menu_view_model.dart';
import '../../../model/menu.dart';

class ItemsUploadScreen extends StatefulWidget
{
  Menu? menuModel;

  ItemsUploadScreen({super.key, this.menuModel,});

  @override
  State<ItemsUploadScreen> createState() => _ItemsUploadScreenState();
}



class _ItemsUploadScreenState extends State<ItemsUploadScreen> {

  TextEditingController infoTextEditingController = TextEditingController();
  TextEditingController titleTextEditingController = TextEditingController();
  TextEditingController descriptionTextEditingController = TextEditingController();
  TextEditingController priceTextEditingController = TextEditingController();



  defaultScreen()
  {
    return Scaffold(
      appBar:MyAppbar(
          titleMsg: "Add New Item",
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
                  "Add New Item ",
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

  uploadItemFormScreen()
  {
    return Scaffold(
      appBar: MyAppbar(
        titleMsg: "Upload New Item",
        showBackButton: true,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black87,
        onPressed: ()
        {
          setState(() {
            imageFile = null;
            infoTextEditingController.clear();
            titleTextEditingController.clear();
            priceTextEditingController.clear();
            descriptionTextEditingController.clear();
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
                      image: DecorationImage(
                        image: FileImage(
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
                hintText: "item info",
                hintStyle: TextStyle(color: Colors.grey),
                border: InputBorder.none,
              ),
            ),
          ),
          const Divider(
            color: Colors.grey,
            thickness: 1,
          ),

          ListTile(
            leading: const Icon(Icons.title, color: Colors.black87,),
            title: TextField(
              style: const TextStyle(color: Colors.black),
              maxLines: 1,
              controller: titleTextEditingController,
              decoration: const InputDecoration(
                hintText: "item title",
                hintStyle: TextStyle(color: Colors.grey),
                border: InputBorder.none,
              ),
            ),
          ),
          const Divider(
            color: Colors.grey,
            thickness: 1,
          ),

          ListTile(
            leading: const Icon(Icons.description, color: Colors.black87,),
            title: TextField(
              style: const TextStyle(color: Colors.black),
              maxLines: 1,
              controller: descriptionTextEditingController,
              decoration: const InputDecoration(
                hintText: "item description",
                hintStyle: TextStyle(color: Colors.grey),
                border: InputBorder.none,
              ),
            ),
          ),
          const Divider(
            color: Colors.grey,
            thickness: 1,
          ),

          ListTile(
            leading: const Icon(Icons.price_change, color: Colors.black87,),
            title: TextField(
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.black),
              maxLines: 1,
              controller: priceTextEditingController,
              decoration: const InputDecoration(
                hintText: "item price",
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
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ElevatedButton(
                onPressed: () async
                {
                  await itemViewModel.validateItemUploadForm(
                      infoTextEditingController.text.trim(),
                      titleTextEditingController.text.trim(),
                      descriptionTextEditingController.text.trim(),
                      priceTextEditingController.text.trim(),
                      widget.menuModel!,
                      context
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

          const SizedBox(
            height: 90,
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
    return imageFile == null ? defaultScreen() : uploadItemFormScreen();
  }
}
