import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:login_app/Api/Api.dart';
import 'package:login_app/src/providers/push_notifications_provider.dart';
import 'package:login_app/src/encrypt.dart';
import 'dart:convert';
import 'package:login_app/configs.dart';
import 'package:login_app/src/screens/mainView.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:login_app/src/extras/variables.dart' as globals;
import 'package:login_app/src/widgets/makePayment.dart';
//routes
import 'package:login_app/src/secondView.dart';
import 'package:login_app/src/screens/productList.dart';
import 'package:login_app/src/screens/profile.dart';

class Login extends StatefulWidget {
  Login({Key key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final pushNotification = new PushNotificationProvider();
  Widget svg = SvgPicture.network(
    'https://firebasestorage.googleapis.com/v0/b/mystore-54a31.appspot.com/o/logo%2Flogo.svg?alt=media&token=a0872a7f-be0b-478f-bd4d-212f2ec7463c',
    semanticsLabel: 'Acme Logo'
  );

  @override
  void initState() {
    super.initState();
    isLogued();
    pushNotification.initialize();
  }

  void isLogued() async {
    final prefs = await SharedPreferences.getInstance();

    final token = prefs.getString('token') ?? '';
    print('token : ' + token);
    if (token != '') {
      globals.token = token;
      await Api.get_UserByToken().then((value) => null);
      Navigator.of(context).pushReplacementNamed('/MainView');
      /*Navigator.push(
          context, MaterialPageRoute(builder: (context) => ProductList()));*/
    }
  }

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
                          child: svg,
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
                            style: TextStyle(color: backgroundColor),
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
                            style: TextStyle(color: backgroundColor),
                          ),
                          registerButtonColor,
                        ),
                        RaisedButton(
                            child: Text('perfil'),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  /*MaterialPageRoute(
                                  builder: (context) => ProductForm(text: 'testSlug')));*/
                                  MaterialPageRoute(
                                      builder: (context) => Profile()));
                            }),
                        RaisedButton(
                            child: Text('log'),
                            onPressed: () {
                              Api.logOut().then((value) => null);
                            }),
                        RaisedButton(
                            child: Text('test paypal'),
                            onPressed: () {
                                                            Navigator.push(
                                  context,
                                  /*MaterialPageRoute(
                                  builder: (context) => ProductForm(text: 'testSlug')));*/
                                  MaterialPageRoute(
                                      builder: (context) => makePayment()));
                            })
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
              Api.login(JsonEncoder().convert(mapData)).then((sucess) {
                if (sucess) {
                  Navigator.of(context).pushReplacementNamed('/MainView');
                  /*Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ProductList()));*/
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
            pushNotification.send();
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
          fillColor: backgroundColor,
          filled: true,
          focusedBorder: underlineInputBorder,
          enabledBorder: UnderlineInputBorder(
              borderRadius: new BorderRadius.circular(10),
              borderSide: new BorderSide(color: inputsTextColor)),
          prefixIcon: Icon(
            Icons.email,
            color: iconColor,
          )),
      validator: (value) {
        if (RegExp('.+[@].+').hasMatch(value)) {
          return null;
        } else {
          return 'correo invalido';
        }
      },
      onSaved: (String value) {
        print(enc(value));
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
          fillColor: backgroundColor,
          filled: true,
          border: new OutlineInputBorder(
              borderRadius: new BorderRadius.all(Radius.circular(90.0))),
          focusedBorder: underlineInputBorder,
          enabledBorder: UnderlineInputBorder(
              borderRadius: new BorderRadius.circular(10),
              borderSide: new BorderSide(color: inputsTextColor)),
          prefixIcon: Icon(
            Icons.enhanced_encryption,
            color: iconColor,
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
        //mapData['password'] = value;
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
