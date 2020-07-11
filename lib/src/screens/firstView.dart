import 'package:flutter/material.dart';

import 'package:login_app/Api/Api.dart';
import 'package:login_app/src/secondView.dart';
import 'package:login_app/src/encrypt.dart';
import 'dart:convert';
import 'package:login_app/configs.dart';

class Login extends StatefulWidget {
  Login({Key key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  var mapData = new Map<String, String>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: backgroundColor,
        body: SingleChildScrollView(
            child: ConstrainedBox(
          constraints: BoxConstraints(),
          child: Center(
            child: Container(
              child: Padding(
                  padding: const EdgeInsets.all(36.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          height: 400,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: NetworkImage(
                                      'https://steamuserimages-a.akamaihd.net/ugc/787413668525333111/FAAB46B13296369D7FD9F07E7B44A982A8665D8C/'),
                                  fit: BoxFit.cover)),
                          child: Stack(
                            children: <Widget>[
                              Container(
                                padding:
                                    EdgeInsets.fromLTRB(0.0, 250.0, 0.0, 0.0),
                                child: Text('MyStore',
                                    style: TextStyle(
                                        fontSize: 80.0,
                                        fontWeight: FontWeight.bold,
                                        color: textcolor,
                                        fontFamily: 'Monserrat')),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Padding(
                          padding: EdgeInsets.all(1.0),
                          child: Column(
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.all(1),
                                decoration: BoxDecoration(
                                  color: backgroundColor,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  children: <Widget>[
                                    SizedBox(height: 20.0),
                                    emailField(),
                                    SizedBox(height: 20.0),
                                    passField(),
                                    SizedBox(height: 40.0),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        loginButton(
                          Text(
                            'INGRESAR',
                            style: TextStyle(color: inputsTextColor),
                          ),
                          buttonLoginColor,
                        ),
                        SizedBox(height: 100.0),
                        Text(
                          "No tienes cuenta aun?",
                          style: TextStyle(
                              color: inputsTextColor,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Montserrat',
                              fontSize: 16,
                              decoration: TextDecoration.underline),
                        ),
                        SizedBox(height: 10.0),
                        registerButton(
                          Text(
                            'REGISTRATE',
                            style: TextStyle(color: inputsTextColor),
                          ),
                          registerButtonColor,
                        ),
                      ],
                    ),
                  )),
            ),
          ),
        )));
  }

  Widget loginButton(Text text, Color color) {
    return ButtonTheme(
        minWidth: 50.0,
        height: 50.0,
        child: RaisedButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
          color: color,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Center(
                child: text,
              )
            ],
          ),
          onPressed: () {
            if (formKey.currentState.validate()) {
              formKey.currentState.save();
              print(JsonEncoder().convert(mapData));
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SecondView()));
              /*Api.login(JsonEncoder().convert(mapData)).then((sucess) {
                if (sucess) {
                  showDialog(
                      builder: (context) => AlertDialog(
                            title: Text('Logueado con exito'),
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
                            title: Text('error al iniciar sesion'),
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
              } );*/
            }
          },
        ));
  }

  Widget registerButton(Text text, Color color) {
    return ButtonTheme(
        minWidth: 50.0,
        height: 50.0,
        child: RaisedButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
          color: registerButtonColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Center(
                child: text,
              )
            ],
          ),
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => SecondView()));
          },
        ));
  }

  Widget emailField() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      style: textStyle,
      obscureText: false,
      decoration: InputDecoration(
          labelText: 'Correo Electronico',
          labelStyle: placeHolderStyle,
          hoverColor: inputsTextColor,
          fillColor: Color(0xff1d2120),
          filled: true,
          focusedBorder: underlineInputBorder,
          enabledBorder: UnderlineInputBorder(
              borderRadius: new BorderRadius.circular(10),
              borderSide: new BorderSide(color: inputsTextColor)),
          prefixIcon: Icon(
            Icons.email,
            color: inputsTextColor,
          )),
      validator: (value) {
        if (RegExp('.+[@].+').hasMatch(value)) {
          return null;
        } else {
          return 'correo invalido';
        }
      },
      onSaved: (String value) {
        print(value);
        mapData['email'] = enc(value);
      },
    );
  }

  Widget passField() {
    return TextFormField(
      style: textStyle,
      obscureText: true,
      decoration: InputDecoration(
          labelText: 'Contraseña',
          labelStyle: placeHolderStyle,
          fillColor: Color(0xff1d2120),
          filled: true,
          border: new OutlineInputBorder(
              borderRadius: new BorderRadius.all(Radius.circular(90.0))),
          focusedBorder: underlineInputBorder,
          enabledBorder: UnderlineInputBorder(
              borderRadius: new BorderRadius.circular(10),
              borderSide: new BorderSide(color: inputsTextColor)),
          prefixIcon: Icon(
            Icons.enhanced_encryption,
            color: inputsTextColor,
          )),
      /*validator: (value) {
        if (RegExp('^.*[!@#%^&*(),.?":{}<>].*').hasMatch(value) &&
            value.length > 7) {
          return null;
        } else {
          return 'contraseña invalida';
        }
      },*/
      onSaved: (String value) {
        mapData['password'] = enc(value);
      },
    );
  }
}

///
TextStyle placeHolderStyle = TextStyle(
    fontFamily: 'Monserrat', fontWeight: FontWeight.bold, color: textcolor);

TextStyle textStyle = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 17,
    fontFamily: 'Monserrat',
    color: inputsTextColor);

UnderlineInputBorder underlineInputBorder = UnderlineInputBorder(
    borderSide: BorderSide(color: textFieldsunderlineColor));

/*
              Api.login(mapData).then((sucess) {
                if (sucess) {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SecondView()));
                } else {
                  showDialog(
                      builder: (context) => AlertDialog(
                            title: Text('error al iniciar sesion'),
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
*/
