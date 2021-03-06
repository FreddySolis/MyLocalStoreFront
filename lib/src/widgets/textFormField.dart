import 'package:flutter/material.dart';

Color color2 = Colors.purple[800];

TextStyle placeHolderStyle = TextStyle(
  fontFamily: 'Monserrat',
  fontWeight:  FontWeight.bold,
  color: Colors.purple
);

class TextFormFields extends StatelessWidget {
  String text;
  TextStyle style;
  bool obscureText;

  TextFormFields({this.text, this.style, this.obscureText});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, fontFamily: 'Monserrat'),
      obscureText: obscureText,
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