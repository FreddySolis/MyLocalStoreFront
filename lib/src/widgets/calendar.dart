import 'package:flutter/material.dart';
import 'package:login_app/src/widgets/textField.dart';


class MyCalendar extends StatefulWidget {
  MyCalendar({Key key}) : super(key: key);

  @override
  _MyCalendarState createState() => _MyCalendarState();
}



class _MyCalendarState extends State<MyCalendar> {
    final TextEditingController controller =
      TextEditingController();

  void onPressButton() {
    setState(() {});
  }

  void setDate(DateTime dateTime){
    controller.text = dateTime.year.toString();
  }

  void showAlert() {
    AlertDialog dialog = AlertDialog(
      content: CalendarDatePicker(initialDate: DateTime.now(), firstDate: DateTime(2020, 06), lastDate: DateTime(2101), onDateChanged: setDate,),
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
                child: TextFields(
                  text: 'Fecha',
                  style: placeHolderStyle,
                  controller: controller,
                  obscureText: false,

                ),
              ),
            ],
          ),
        ),
        RaisedButton(onPressed: showAlert, child: Icon(Icons.control_point), )
      ],
    );
  }
}