import 'package:flutter/material.dart';
import 'package:login_app/Api/Api.dart';
import 'package:login_app/src/secondView.dart';
import 'package:login_app/src/widgets/textField.dart';

//Colores
Color color1 = Colors.green;
Color color2 = Colors.grey;

//controllers
final TextEditingController textFieldLoginController = TextEditingController();
final TextEditingController passFieldLoginController = TextEditingController();

class MyLogin extends StatelessWidget {
  const MyLogin({Key key}) : super(key: key);

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
                TextFields(
                  text: 'Email',
                  style: placeHolderStyle,
                  controller: textFieldLoginController,
                  obscureText: false,
                ),
                SizedBox(height: 20.0),
                TextField(
                  decoration: InputDecoration(
                      labelText: 'Contraseña',
                      labelStyle: TextStyle(
                          fontFamily: 'Monserrat',
                          fontWeight: FontWeight.bold,
                          color: Colors.purple),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.purple))),
                  obscureText: true,
                  controller: passFieldLoginController,
                  maxLength: 8,
                  onChanged: (text){
                    validate();
                  },
                ),
                SizedBox(height: 40.0),
                LoginButton(
                  text: Text(
                    'Ingresar',
                    style: TextStyle(color: Colors.white),
                  ),
                  color: Colors.purple[200],
                ),
                SizedBox(height: 15.0),
                RegisterButton(
                  text: Text(
                    'Registrar',
                    style: TextStyle(color: Colors.white),
                  ),
                  color: Colors.purple[300],
                ),
              ],
            ),
          ),
        ),
      ),
    )));
  }
}

void validate(){
  var length = passFieldLoginController.text;
  if(length.length >=8 && !length.contains(RegExp(r'\W')) && RegExp(r'\d+\w*\d+').hasMatch(length)){
    print("VALIDO");
  }else{
    print("NO VALIDO");
  }
}

class LinkText extends StatelessWidget {
  String text;
  double fontSize;

  LinkText({this.text, this.fontSize});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
          color: color1,
          fontSize: fontSize,
          decoration: TextDecoration.underline,
          fontWeight: FontWeight.bold),
    );
  }
}

class LoginButton extends StatelessWidget {
  Text text;
  Color color;
  String data;

  LoginButton({this.text, this.color});

  @override
  Widget build(BuildContext context) {
    int count;
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
            count = count+1;
            data = '{ "email": "' +
                textFieldLoginController.text +
                '","password": "' +
                passFieldLoginController.text +
                '" }';
            Api.login(data).then((sucess) {
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
          },
        ));
  }
}

class RegisterButton extends StatelessWidget {
  Text text;
  Color color;
  RegisterButton({
    this.text,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
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
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => SecondView()));
          },
        ));
  }
}
