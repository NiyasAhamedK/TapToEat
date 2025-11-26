import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../global/global_vars.dart';

class CommonViewModel
{
  showSnackBar(String message, BuildContext context){
    final snackBar = SnackBar
      (content: Text(message, style: const TextStyle(fontSize: 16, color: Colors.white),),
      backgroundColor: Colors.purple,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  pickImage() async
  {
    FilePickerResult? resultFilePicker = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );

    if (resultFilePicker != null) {
      imageFile = resultFilePicker.files.first.bytes;
      fileName = resultFilePicker.files.first.name;
    }
  }
}