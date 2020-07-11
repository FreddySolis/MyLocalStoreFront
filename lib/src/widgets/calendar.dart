import 'package:flutter/material.dart';
import 'package:login_app/configs.dart';




class MyCalendar extends StatefulWidget {
  MyCalendar( {Key key,this.controller,this.name}) : super(key: key) ;

  final TextEditingController controller;
  final String name;


  @override
  _MyCalendarState createState() => _MyCalendarState();
}

class _MyCalendarState extends State<MyCalendar> {
  void onPressButton() {
    setState(() {});
  }

  void setDate(DateTime dateTime) {
    String month = '0';
    if (dateTime.month < 10) {
      month = '0' + dateTime.month.toString();
    } else {
      month = dateTime.month.toString();
    }
    widget.controller.text =
        dateTime.year.toString() + '-' + month + '-' + dateTime.day.toString();
  }

  void showAlert() {
    AlertDialog dialog = AlertDialog(
      content: CalendarDatePicker(
        initialDate: DateTime.now(),
        firstDate: DateTime(1900, 01),
        lastDate: DateTime(2101),
        onDateChanged: setDate,
      ),
      actions: <Widget>[
        FlatButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Aceptar')),
      ],
    );
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return dialog;
        });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                child: textFormField(
                  widget.name,
                  widget.controller,
                ),
              ),
            ],
          ),
        ),
        RaisedButton(
          onPressed: showAlert,
          child: Icon(Icons.control_point),
        )
      ],
    );
  }


Widget textFormField(String name, TextEditingController controller){
  return TextFormField(
      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, fontFamily: 'Monserrat'),
      obscureText: false,
      controller: controller,
      decoration: InputDecoration(
        labelText: name,
        labelStyle:placeHolderStyle,
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color:textcolor)
        )
      ),
      
    );
}

TextStyle placeHolderStyle = TextStyle(
  fontFamily: 'Monserrat',
  fontWeight:  FontWeight.bold,
  color: textcolor
  //color: Colors.purple
);
  
}