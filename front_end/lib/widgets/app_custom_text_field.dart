import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String text;
  final String? Function(String?)? validator;
  const CustomTextField(
      {super.key, required this.controller, required this.text,this.validator});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          labelText: text,
          border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)))),
              validator: validator,
    );
  }
}
