import 'package:flutter/material.dart';
import 'package:login_app/src/widgets/textField.dart';
import 'package:login_app/src/widgets/calendar.dart';
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
          '","last_name":"' +
          lastNameController.text +
          '","phone":"' +
          phoneNumberController.text +
          '","email":"' +
          emailController.text +
          '","birthday":"' +
          calendarController.text +
          '","password":"' +
          passController.text +
          '","password_confirmation":"' +
          passConfirmController.text +
          '","genre":"m","rol_id":1 } ';
      print(data);
      ApiR.login(data).then((sucess) {
        if (sucess) {
        } else {}
      });
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Registro'),
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
                      child: MyCalendar(controller:calendarController ,name: 'Cumpleaños',),

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
                        shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      padding: EdgeInsets.fromLTRB(135, 0, 0, 0),
                      color: Colors.purple[200],
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[Text("Confirmar",style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Monserrat'
                          ),)],
                      ),
                      onPressed: () {
                        registro();
                      },
                    ))
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

