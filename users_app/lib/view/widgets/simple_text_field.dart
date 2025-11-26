import 'package:flutter/material.dart';
class SimpleTextField extends StatelessWidget {
  String? hint;
  TextEditingController? controller;

  SimpleTextField({super.key,this.hint,this.controller,});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration.collapsed(hintText: hint),
        validator: (value) => value!.isEmpty? "Field can not be empty": null,
      ),
    );
  }
}
