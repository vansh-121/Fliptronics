import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UiHelper {
  static CustomTextField(
      TextEditingController controller, String text, IconData, bool toHide) {
    return TextField(
      controller: controller,
      obscureText: toHide,
      decoration: InputDecoration(
          hintText: text,
          prefixIcon: Icon(IconData),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
    );
  }
}
