import 'package:flutter/material.dart';

class CustomForm extends StatelessWidget {

  final TextEditingController textEditingController;
  final GlobalKey formKey;
  final String hintText;


  CustomForm({this.textEditingController, this.formKey, this.hintText});

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: TextFormField(
        controller: textEditingController,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          hintText: hintText,
        ),
        validator: (input) {
          if (input.isEmpty) {
            return 'Enter some text';
          }
          if (input.contains(RegExp(r"^([A-Za-z0-9]){4,20}$"))) {
            return null;
          }
          return 'Can not contain special characters of spaces';
        },
      ),
    );
  }
}
