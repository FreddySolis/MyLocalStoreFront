import 'package:flutter/material.dart';
import 'package:login_app/src/widgets/textField.dart';
//import 'package:login_app/src/widgets/calendar.dart';
import 'package:login_app/Api/Api.dart';

double bottomDistance = 20;
double marginDistance = 20;

DateTime date;

final TextEditingController calendarController = TextEditingController();
final TextEditingController nameController = TextEditingController();
final TextEditingController lastNameController = TextEditingController();
final TextEditingController phoneNumberController = TextEditingController();
final TextEditingController emailController = TextEditingController();
final TextEditingController passController = TextEditingController();
final TextEditingController passConfirmController = TextEditingController();

void setDate(DateTime dateTime) {
  date = dateTime;

  print(date);
}

class SecondView extends StatelessWidget {

void registro() {
  if (passController.text == passConfirmController.text) {
    String data = '{ "name": "' +
        nameController.text +
        '","lastName":"' +
        lastNameController.text +
        '","phone":"' +
        phoneNumberController.text +
        '","email":"' +
        emailController.text +
        '","date":"' +
        calendarController.text +
        '","password":"' +
        passController.text +
        '"';
        print(data);
    Api.login(data).then((sucess) {
      if (sucess) {
      } else {

      }
    });
  } else {
    


  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Register'),
      ),
      body: SingleChildScrollView(
          child: ConstrainedBox(
              constraints: BoxConstraints(),
              child: Container(
                padding: EdgeInsets.fromLTRB(marginDistance, 60, 30, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    RowWithTextFields(
                      nombre1: 'Nombre',
                      nombre2: 'Apellido',
                      controller1: nameController,
                      controller2: lastNameController,
                      pass1: false,
                      pass2: false,
                    ),
                    Padding(padding: EdgeInsets.only(bottom: bottomDistance)),
                    RowWithTextFields(
                      nombre1: 'Telefono',
                      nombre2: 'Correo Electronico',
                      controller1: phoneNumberController,
                      controller2: emailController,
                      pass1: false,
                      pass2: false,
                    ),
                    Padding(padding: EdgeInsets.only(bottom: bottomDistance)),
                    Container(
                      padding: EdgeInsets.only(left: marginDistance),
                      child: MyCalendar(),

                      //CalendarDatePicker(initialDate: DateTime.now(), firstDate: DateTime(2020, 06), lastDate: DateTime(2101), onDateChanged: setDate,)
                    ),
                    Padding(padding: EdgeInsets.only(bottom: bottomDistance)),
                    RowWithTextFields(
                      nombre1: 'Contraseña',
                      nombre2: 'confirmar contrase',
                      controller1: passController,
                      controller2: passConfirmController,
                      pass1: true,
                      pass2: true,
                    ),
                    Padding(padding: EdgeInsets.only(bottom: bottomDistance)),
                    Center(
                      child: RaisedButton(
                        onPressed: registro,
                        child: Text('Registrate'),
                      ),
                    )
                  ],
                ),
              ))),
    );
  }
}


class RowWithTextFields extends StatelessWidget {
  String nombre1;
  String nombre2;
  bool pass1;
  bool pass2;
  TextEditingController controller1;
  TextEditingController controller2;

  RowWithTextFields(
      {this.nombre1,
      this.nombre2,
      this.controller1,
      this.controller2,
      this.pass1,
      this.pass2});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Padding(padding: EdgeInsets.fromLTRB(marginDistance, 0, 0, 0)),
        Expanded(
          child: Column(
            children: <Widget>[
              Container(
                child: TextFields(
                  text: nombre1,
                  style: placeHolderStyle,
                  controller: controller1,
                  obscureText: pass1,
                ),
              ),
            ],
          ),
        ),
        Padding(padding: EdgeInsets.fromLTRB(0, 0, marginDistance, 0)),
        Expanded(
          // wrap your Column in Expanded
          child: Column(
            children: <Widget>[
              Container(
                child: TextFields(
                  text: nombre2,
                  style: placeHolderStyle,
                  controller: controller2,
                  obscureText: pass2,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

////
class MyCalendar extends StatefulWidget {
  MyCalendar({Key key}) : super(key: key);

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
    calendarController.text =
        dateTime.year.toString() + '-' + month + '-' + dateTime.day.toString();
  }

  void showAlert() {
    AlertDialog dialog = AlertDialog(
      content: CalendarDatePicker(
        initialDate: DateTime.now(),
        firstDate: DateTime(2020, 06),
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
                child: TextFields(
                  text: 'Fecha',
                  style: placeHolderStyle,
                  controller: calendarController,
                  obscureText: false,
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
}
