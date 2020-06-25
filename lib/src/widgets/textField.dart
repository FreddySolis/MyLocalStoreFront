import 'package:flutter/material.dart';

Color color2 = Colors.grey;

TextStyle placeHolderStyle = TextStyle(
  
  color: color2,
  fontSize: 15,
);

class TextFields extends StatelessWidget {
  String text;
  TextStyle style;
  TextEditingController controller;
  bool obscureText;

  TextFields({this.text, this.style, this.controller, this.obscureText});

  @override
  Widget build(BuildContext context) {
    return TextField(
      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
      obscureText: obscureText,
      decoration: InputDecoration(hintText: text, hintStyle: placeHolderStyle),
      controller: controller,
    );
  }
}