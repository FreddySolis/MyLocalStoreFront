import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:login_app/src/widgets/calendar.dart';
import 'package:login_app/Api/Api.dart';
import 'package:login_app/src/encrypt.dart';


double bottomDistance = 20;
double marginDistance = 20;
DateTime date;

final TextEditingController calendarController = TextEditingController();

void setDate(DateTime dateTime) {
  date = dateTime;

  print(date);
}

class SecondView extends StatefulWidget {
  SecondView({Key key}) : super(key: key);

  @override
  _SecondViewState createState() => _SecondViewState();
}

class _SecondViewState extends State<SecondView> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  var mapData = new Map<String, String>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff040404),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color(0xfff8a933),
        title: Text('Registro'),
      ),
      body: SingleChildScrollView(
          child: ConstrainedBox(
              constraints: BoxConstraints(),
              child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xff1d2120),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  margin: EdgeInsets.all(marginDistance),
                  padding: EdgeInsets.fromLTRB(0, 60, 0, 0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        rowNameAndLastName(
                            'Nombre', 'Apellido', 'name', 'last_name'),
                        Padding(
                            padding: EdgeInsets.only(bottom: bottomDistance)),
                        rowPhoneAndEmail(
                            'Telefono', 'Correo Electronico', 'phone', 'email'),
                        Padding(
                            padding: EdgeInsets.only(bottom: bottomDistance)),
                        Container(
                          padding: EdgeInsets.only(left: marginDistance),
                          child: MyCalendar(
                            controller: calendarController,
                            name: 'Cumpleaños',
                          ),

                          //CalendarDatePicker(initialDate: DateTime.now(), firstDate: DateTime(2020, 06), lastDate: DateTime(2101), onDateChanged: setDate,)
                        ),
                        Padding(
                            padding: EdgeInsets.only(bottom: bottomDistance)),
                        rowPasswordAndConfirmPassword(
                            'Contraseña',
                            'Confirmar Contraseña',
                            'password',
                            'password_confirmation'),
                        Padding(
                            padding: EdgeInsets.only(bottom: bottomDistance)),
                        Center(child: submidButton()),
                        SizedBox(
                          width: 20,
                        )
                      ],
                    ),
                  )))),
    );
  }

  Widget submidButton() {
    return RaisedButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25.0),
      ),
      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
      //color: Colors.purple[200],
      color: Color(0xfff8a933),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Text(
              "CONFIRMAR",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontFamily: 'Monserrat',
                fontSize: 15,
              ),
            ),
          )
        ],
      ),
      onPressed: () {
        if (formKey.currentState.validate()) {
          formKey.currentState.save();
          mapData['birthday'] = calendarController.text;
          mapData['rol_id'] = '1';
          mapData['genre'] = 'm';
          Api.registro(JsonEncoder().convert(mapData)).then((sucess) {
            if (sucess) {
              showDialog(
                  builder: (context) => AlertDialog(
                        title: Text('registrado con exito'),
                        actions: <Widget>[
                          FlatButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('Ok'),
                          )
                        ],
                      ),
                  context: context);
            } else {
              showDialog(
                  builder: (context) => AlertDialog(
                        title: Text('error al registro'),
                        actions: <Widget>[
                          FlatButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('Ok'),
                          )
                        ],
                      ),
                  context: context);
              return;
            }
          });
        }
      },
    );
  }

  Widget rowPasswordAndConfirmPassword(
      String nombre1, String nombre2, String jsonName, String jsonName2) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Padding(padding: EdgeInsets.fromLTRB(marginDistance, 0, 0, 0)),
        Expanded(
          child: Column(
            children: <Widget>[
              Container(child: passField(nombre1, jsonName)),
            ],
          ),
        ),
        Padding(padding: EdgeInsets.fromLTRB(0, 0, marginDistance, 0)),
        Expanded(
          // wrap your Column in Expanded
          child: Column(
            children: <Widget>[
              Container(child: passField(nombre2, jsonName2)),
            ],
          ),
        ),
      ],
    );
  }

  Widget rowPhoneAndEmail(
      String nombre1, String nombre2, String jsonName, String jsonName2) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Padding(padding: EdgeInsets.fromLTRB(marginDistance, 0, 0, 0)),
        Expanded(
          child: Column(
            children: <Widget>[
              Container(child: phoneField(nombre1, jsonName)),
            ],
          ),
        ),
        Padding(padding: EdgeInsets.fromLTRB(0, 0, marginDistance, 0)),
        Expanded(
          // wrap your Column in Expanded
          child: Column(
            children: <Widget>[
              Container(child: emailField(nombre2, jsonName2)),
            ],
          ),
        ),
      ],
    );
  }

  Widget rowNameAndLastName(
      String nombre1, String nombre2, String jsonName, String jsonName2) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Padding(padding: EdgeInsets.fromLTRB(marginDistance, 0, 0, 0)),
        Expanded(
          child: Column(
            children: <Widget>[
              Container(child: nameField(nombre1, jsonName)),
            ],
          ),
        ),
        Padding(padding: EdgeInsets.fromLTRB(0, 0, marginDistance, 0)),
        Expanded(
          // wrap your Column in Expanded
          child: Column(
            children: <Widget>[
              Container(child: nameField(nombre2, jsonName2)),
            ],
          ),
        ),
      ],
    );
  }

  Widget emailField(String name, String mapName) {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      style: textStyle,
      obscureText: false,
      decoration: InputDecoration(
          labelText: name,
          labelStyle: placeHolderStyle,
          focusedBorder: underlineInputBorder),
      validator: (value) {
        if (RegExp('.+[@].+').hasMatch(value)) {
          return null;
        } else {
          return '$name invalido';
        }
      },
      onSaved: (String value) {
        mapData[mapName] = enc(value);
      },
    );
  }

  Widget passField(String name, String mapName) {
    return TextFormField(
      style: textStyle,
      obscureText: true,
      decoration: InputDecoration(
          labelText: name,
          labelStyle: placeHolderStyle,
          focusedBorder: underlineInputBorder),
      validator: (value) {
        print(value);
        if (RegExp('^.*[!\$@#%^&*(),.?":{}<>].*').hasMatch(value) &&
            value.length > 7) {
          return null;
        } else {
          return '$name invalida';
        }
      },
      onSaved: (String value) {
        mapData[mapName] = enc(value);
      },
    );
  }

  Widget phoneField(String name, String mapName) {
    return TextFormField(
      keyboardType: TextInputType.phone,
      style: textStyle,
      obscureText: false,
      decoration: InputDecoration(
          labelText: name,
          labelStyle: placeHolderStyle,
          focusedBorder: underlineInputBorder),
      validator: (value) {
        if (RegExp('[0-9]{10}').hasMatch(value)) {
          return null;
        } else {
          return '$name invalido';
        }
      },
      onSaved: (String value) {
        mapData[mapName] = enc(value);
      },
    );
  }

  Widget nameField(String name, String mapName) {
    return TextFormField(
      style: textStyle,
      obscureText: false,
      decoration: InputDecoration(
          labelText: name,
          labelStyle: placeHolderStyle,
          focusedBorder: underlineInputBorder),
      validator: (value) {
        if (RegExp('[a-zA-Z]+').hasMatch(value)) {
          return null;
        } else {
          return '$name invalido';
        }
      },
      onSaved: (String value) {
        print(mapName);
        print(value);
        mapData[mapName] = enc(value);
      },
    );
  }
}

////
TextStyle placeHolderStyle = TextStyle(
    fontFamily: 'Monserrat',
    fontWeight: FontWeight.bold,
    color: Color(0xfff8a933));
TextStyle textStyle = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 17,
    fontFamily: 'Monserrat',
    color: Colors.white);

UnderlineInputBorder underlineInputBorder =
    UnderlineInputBorder(borderSide: BorderSide(color: Color(0xfff8a933)));
