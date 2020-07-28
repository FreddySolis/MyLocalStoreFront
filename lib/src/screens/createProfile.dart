import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:login_app/src/widgets/calendar.dart';
import 'package:login_app/Api/Api.dart';
import 'package:login_app/src/encrypt.dart';
import 'package:login_app/configs.dart';
import 'package:login_app/src/extras/variables.dart' as globals;

double bottomDistance = 20;
double marginDistance = 20;
DateTime date;

final TextEditingController name = TextEditingController();
final TextEditingController lastname = TextEditingController();
final TextEditingController email = TextEditingController();
final TextEditingController birthday = TextEditingController();
final TextEditingController genre = TextEditingController();
final TextEditingController phone = TextEditingController();


void setDate(DateTime dateTime) {
  date = dateTime;

  print(date);
}

class SecondView extends StatefulWidget {
  SecondView({ Key key}) : super(key: key);

  @override
  _SecondViewState createState() => _SecondViewState();
}

class _SecondViewState extends State<SecondView> {

    @override
  void initState() {
    initData();
    super.initState();
  }

    void initData() async {
    Map<String,dynamic> dataTemp;
    await Api.get_UserByToken().then((sucess) {
      dataTemp = sucess;
    });
    setState(() {
      name.text = globals.name;
      lastname.text = globals.lastName;
      email.text = globals.email;
      birthday.text = dataTemp['birthday'].toString();
      genre.text = dataTemp['genre'];
      phone.text = dataTemp['phone'];
    });
  }

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  var mapData = new Map<String, dynamic>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: textcolor,
        title: Text('Editar Perfil'),
      ),
      body: SingleChildScrollView(
          child: ConstrainedBox(
              constraints: BoxConstraints(),
              child: Container(
                  /*decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(10),
                  ),*/
                  margin: EdgeInsets.all(marginDistance),
                  padding: EdgeInsets.fromLTRB(0, 60, 0, 0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        rowNameAndLastName(
                            'Nombre', 'Apellido', 'name', 'last_name', name, lastname),
                        Padding(
                            padding: EdgeInsets.only(bottom: bottomDistance)),
                        rowPhoneAndEmail(
                            'Telefono', 'Correo Electronico', 'phone', 'email', phone, email),
                        Padding(
                            padding: EdgeInsets.only(bottom: bottomDistance)),
                        Container(
                          padding: EdgeInsets.only(left: marginDistance),
                          child: MyCalendar(
                            controller: birthday,
                            name: 'Cumpleaños',
                          ),

                          //CalendarDatePicker(initialDate: DateTime.now(), firstDate: DateTime(2020, 06), lastDate: DateTime(2101), onDateChanged: setDate,)
                        ),
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
      color: submitFormButtonColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Text(
              "CONFIRMAR",
              style: TextStyle(
                color: backgroundColor,
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
          mapData['birthday'] = birthday.text;
          mapData['genre'] = 'm';
          Api.update_user(JsonEncoder().convert(mapData)).then((sucess) {
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
      String nombre1, String nombre2, String jsonName, String jsonName2, TextEditingController controller1, TextEditingController controller2) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Padding(padding: EdgeInsets.fromLTRB(marginDistance, 0, 0, 0)),
        Expanded(
          child: Column(
            children: <Widget>[
              Container(child: phoneField(nombre1, jsonName, controller1)),
            ],
          ),
        ),
        Padding(padding: EdgeInsets.fromLTRB(0, 0, marginDistance, 0)),
        Expanded(
          // wrap your Column in Expanded
          child: Column(
            children: <Widget>[
              Container(child: emailField(nombre2, jsonName2, controller2)),
            ],
          ),
        ),
      ],
    );
  }

  Widget rowNameAndLastName(
      String nombre1, String nombre2, String jsonName, String jsonName2, TextEditingController controller1, TextEditingController controller2) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Padding(padding: EdgeInsets.fromLTRB(marginDistance, 0, 0, 0)),
        Expanded(
          child: Column(
            children: <Widget>[
              Container(child: nameField(nombre1, jsonName, controller1)),
            ],
          ),
        ),
        Padding(padding: EdgeInsets.fromLTRB(0, 0, marginDistance, 0)),
        Expanded(
          // wrap your Column in Expanded
          child: Column(
            children: <Widget>[
              Container(child: nameField(nombre2, jsonName2, controller2)),
            ],
          ),
        ),
      ],
    );
  }

  Widget emailField(String name, String mapName, TextEditingController controller) {
    return TextFormField(
      controller: controller,
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

  Widget phoneField(String name, String mapName,TextEditingController controller) {
    return TextFormField(
      controller: controller,
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

  Widget nameField(String name, String mapName,TextEditingController controller ) {
    return TextFormField(
      controller: controller,
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
        mapData[mapName] = value;
      },
    );
  }
}

////
TextStyle placeHolderStyle = TextStyle(
    fontFamily: 'Monserrat',
    fontWeight: FontWeight.bold,
    color: textcolor);
TextStyle textStyle = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 17,
    fontFamily: 'Monserrat',
    color: inputsTextColor);

UnderlineInputBorder underlineInputBorder =
    UnderlineInputBorder(borderSide: BorderSide(color: textFieldsunderlineColor));

