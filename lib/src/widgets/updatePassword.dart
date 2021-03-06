import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:login_app/Api/Api.dart';
import 'package:login_app/configs.dart';
import 'package:login_app/src/encrypt.dart';

final TextEditingController password = TextEditingController();

class UpdatePassword extends StatefulWidget {
  UpdatePassword({Key key}) : super(key: key);

  @override
  UpdatePasswordState createState() => UpdatePasswordState();
}

class UpdatePasswordState extends State<UpdatePassword> {
  final formKey = GlobalKey<FormState>();
  String pass;
  var mapData = new Map<String, String>();
  bool pas;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: textcolor,
          title: Text('Actualizar contraseña'),
        ),
        body: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Form(
                    key: formKey,
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          controller: password,
                          decoration: InputDecoration(
                            labelText: "Nueva Contraseña",
                            labelStyle: placeHolderStyle,
                            fillColor: backgroundColor,
                            filled: true,
                            border: new OutlineInputBorder(
                              borderRadius:
                                  new BorderRadius.all(Radius.circular(90.0)),
                            ),
                            focusedBorder: underlineInputBorder,
                            enabledBorder: UnderlineInputBorder(
                                borderRadius: new BorderRadius.circular(10),
                                borderSide:
                                    new BorderSide(color: inputsTextColor)),
                            prefixIcon: Icon(
                              Icons.enhanced_encryption,
                              color: iconColor,
                            ),
                          ),
                          obscureText: true,
                          validator: (value) {
                            if (RegExp('^(?=.*?[A-Za-z])(?=.*?[0-9])(?=.*?[!@#\$&*~])').hasMatch(value)) {
                              return null;
                            } else {
                              return 'contraseña NO VALIDA';
                            }
                          },
                          onChanged: (value) {
                            if (RegExp('^(?=.*?[A-Za-z])(?=.*?[0-9])(?=.*?[!@#\$&*~])')
                                    .hasMatch(value) &&
                                value.length > 7) {
                              print('contraseña valida');
                              return null;
                            } else {
                              print('contraseña invalida');
                              return 'contraseña invalida';
                            }
                          },
                        ),
                        SizedBox(height: 20.0),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: "Confirmar Contraseña",
                            labelStyle: placeHolderStyle,
                            fillColor: backgroundColor,
                            filled: true,
                            border: new OutlineInputBorder(
                              borderRadius:
                                  new BorderRadius.all(Radius.circular(90.0)),
                            ),
                            focusedBorder: underlineInputBorder,
                            enabledBorder: UnderlineInputBorder(
                                borderRadius: new BorderRadius.circular(10),
                                borderSide:
                                    new BorderSide(color: inputsTextColor)),
                            prefixIcon: Icon(
                              Icons.enhanced_encryption,
                              color: iconColor,
                            ),
                          ),
                          obscureText: true,
                          validator: (value) {
                            if (RegExp('^(?=.*?[A-Za-z])(?=.*?[0-9])(?=.*?[!@#\$&*~])').hasMatch(value)) {
                              return null;
                            } else {
                              return 'contraseña NO VALIDA';
                            }
                          },
                          onChanged: (value) {
                            if (value == password.text) {
                              pass = value;
                              pas= true;
                              print("Contraseñas correctas");
                            } else {
                              pas= false;
                              print("Las contraseñas no coinciden");
                            }
                          },
                          onSaved: (value) {
                            print("contra $pass");
                            mapData['password'] = enc(pass);
                          },
                        ),
                        SizedBox(height: 15,),
                        loginButton(buttonLoginColor)
                      ],
                    )),
              ]),
        ));
  }

  Widget loginButton(Color color) {
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
                child: Text('Actualizar'),
              )
            ],
          ),
          onPressed: () {
            if (formKey.currentState.validate() && pas) {
              formKey.currentState.save();
              print(JsonEncoder().convert(mapData));
              Api.update_Password(JsonEncoder().convert(mapData)).then((sucess) {
                if (sucess) {
                  showDialog(
                    builder: (context) => AlertDialog(
                      title: Text('Contraseña actualizada con éxito'),
                        actions: <Widget>[
                          FlatButton(
                            onPressed: () {
                              Api.logOut().then((sucess){
                                Navigator.of(context).pushReplacementNamed('/Login');
                              }).catchError((onError){
                                print("ERROR LOGOUT");
                              });
                            },
                            child: Text('Ok'),
                          )
                        ],
                      ),
                    context: context
                  );
                  
                  /*Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ProductList()));*/
                } else {
                  showDialog(
                      builder: (context) => AlertDialog(
                            title: Text('error al actualizar contraseña'),
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
            }else{
              showDialog(
                builder: (context) => AlertDialog(
                title: Text('Las contraseñas no coinciden o no es valida\ncorrobore, por favor.'),
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
            }
          },
        ));
  }
}

TextStyle placeHolderStyle = TextStyle(
    fontFamily: 'Monserrat', fontWeight: FontWeight.bold, color: textcolor);
TextStyle textStyle = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 17,
    fontFamily: 'Monserrat',
    color: inputsTextColor);

UnderlineInputBorder underlineInputBorder = UnderlineInputBorder(
    borderSide: BorderSide(color: textFieldsunderlineColor));
