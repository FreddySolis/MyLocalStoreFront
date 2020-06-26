import 'package:flutter/material.dart';
import 'package:login_app/Api/Api.dart';
import 'package:login_app/src/secondView.dart';

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
        body: SingleChildScrollView(
            child: ConstrainedBox(
      constraints: BoxConstraints(),
      child: Center(
        child: Container(
          color: Colors.white,
          child: Padding(
              padding: const EdgeInsets.all(36.0),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 155.0,
                      child: Image.network(
                        'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTVD7AIlcufvAefTV03juE0XbIEcld5IKxNHg&usqp=CAU',
                      ),
                    ),
                    SizedBox(height: 20.0),
                    emailField(),
                    SizedBox(height: 20.0),
                    passField(),
                    SizedBox(height: 40.0),
                    loginButton(
                      Text(
                        'Ingresar',
                        style: TextStyle(color: Colors.white),
                      ),
                      Colors.purple[200],
                    ),
                    SizedBox(height: 15.0),
                    registerButton(
                      Text(
                        'Registrar',
                        style: TextStyle(color: Colors.white),
                      ),
                      Colors.purple[300],
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
            borderRadius: BorderRadius.circular(25.0),
          ),
          padding: EdgeInsets.fromLTRB(135, 0, 0, 0),
          color: color,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[text],
          ),
          onPressed: () {
            if (formKey.currentState.validate()) {
              formKey.currentState.save();
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SecondView()));
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
            borderRadius: BorderRadius.circular(25.0),
          ),
          padding: EdgeInsets.fromLTRB(135, 0, 0, 0),
          color: color,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[text],
          ),
          onPressed: () {
            //Navigator.push(
            //  context, MaterialPageRoute(builder: (context) => SecondView()));
          },
        ));
  }

  Widget emailField() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      style: textStyle,
      obscureText: false,
      decoration: InputDecoration(
          labelText: 'Correo',
          labelStyle: placeHolderStyle,
          focusedBorder: underlineInputBorder),
      validator: (value) {
        if (RegExp('.+[@].+').hasMatch(value)) {
          return null;
        } else {
          return 'correo invalido';
        }
      },
      onSaved: (String value) {
        print(value);
        mapData['email'] = value;
      },
    );
  }

  Widget passField() {
    return TextFormField(
      style: textStyle,
      obscureText: true,
      decoration: InputDecoration(
          labelText: 'contraseña',
          labelStyle: placeHolderStyle,
          focusedBorder: underlineInputBorder),
      /*validator: (value) {
        if (RegExp('^.*[!@#%^&*(),.?":{}<>].*').hasMatch(value) &&
            value.length > 7) {
          return null;
        } else {
          return 'contraseña invalida';
        }
      },*/
      onSaved: (String value) {
        mapData['password'] = value;
      },
    );
  }
}

///
TextStyle placeHolderStyle = TextStyle(
    fontFamily: 'Monserrat', fontWeight: FontWeight.bold, color: Colors.purple);
TextStyle textStyle = TextStyle(
    fontWeight: FontWeight.bold, fontSize: 17, fontFamily: 'Monserrat');

UnderlineInputBorder underlineInputBorder =
    UnderlineInputBorder(borderSide: BorderSide(color: Colors.purple));

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
