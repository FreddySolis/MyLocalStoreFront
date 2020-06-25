import 'package:flutter/material.dart';

Color color2 = Colors.purple[800];

TextStyle placeHolderStyle = TextStyle(
  fontFamily: 'Monserrat',
  fontWeight:  FontWeight.bold,
  color: Colors.purple
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
      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, fontFamily: 'Monserrat'),
      obscureText: obscureText,
      controller: controller,
      decoration: InputDecoration(
        labelText: text,
        labelStyle:placeHolderStyle,
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.purple)
        )
      ),
    );
  }
}