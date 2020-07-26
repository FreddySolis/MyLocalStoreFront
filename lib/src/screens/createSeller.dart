import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:login_app/Api/Api.dart';
import 'package:login_app/src/widgets/calendar.dart';
import 'package:login_app/src/encrypt.dart';
import '../../configs.dart';

final TextEditingController calendarController = TextEditingController();
final TextEditingController nameController = TextEditingController();
final TextEditingController lastnameController = TextEditingController();
final TextEditingController emailController = TextEditingController();
final TextEditingController birthdayController = TextEditingController();
final TextEditingController genreController = TextEditingController();
final TextEditingController phoneController = TextEditingController();
final TextEditingController passwordController = TextEditingController();
final TextEditingController passwordController2 = TextEditingController();

class CreateSeller extends StatefulWidget{
  @override
  _CreateSeller createState() => _CreateSeller();
}

class _CreateSeller extends State<CreateSeller>{
  var mapData = new Map<String, String>();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        title: Row(
          children: <Widget>[
            Text("Crear Vendedor"),
          ],
        ),
      ),
      body:SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(),
          child: Form(
            key: formKey,
            child:Container(
              margin: EdgeInsets.all(20.0),

              child: Column(
                children: <Widget>[
                  _addressInputs(),
                  Container(
                    margin: EdgeInsets.all(20.0),
                    child: _buttonSellerCreate(),
                  )
                ],
              ) ,
            )
          )
        ),
      )
    );
  }

  String _selectGenero = 'Masculino';
  String pass1Label = "Contraseña";
  String pass2Label = "Confirmarcion Contraseña";
  String emailLabel = "Email";
  String phoneLabel = "Telefono";
  String lastnameLabel = "Apellido ";
  String nameLabel = "Nombre";

  Widget _addressInputs(){
    return Container(
      padding: EdgeInsets.fromLTRB(0, 60, 0, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child:  TextFormField(
                  controller: nameController,
                  validator: (value) {
                    if (RegExp('[a-zA-Z]+').hasMatch(value)) {
                      return null;
                    } else {
                      return '$nameLabel invalido';
                    }
                  },
                  decoration: InputDecoration(
                    labelText: nameLabel,
                    focusedBorder: UnderlineInputBorder(
                        borderRadius: new BorderRadius.circular(10),
                        borderSide: new BorderSide(color: Colors.black)),
                    enabledBorder: UnderlineInputBorder(
                        borderRadius: new BorderRadius.circular(10),
                        borderSide: new BorderSide(color: textcolor)),
                  ),
                ),
              ),
              Expanded(
                child: TextFormField(
                  controller: lastnameController,
                  validator: (value) {
                    if (RegExp('[a-zA-Z]+').hasMatch(value)) {
                      return null;
                    } else {
                      return '$lastnameLabel invalido';
                    }
                  },
                  decoration: InputDecoration(
                    labelText: lastnameLabel,
                    focusedBorder: UnderlineInputBorder(
                        borderRadius: new BorderRadius.circular(10),
                        borderSide: new BorderSide(color: Colors.black)),
                    enabledBorder: UnderlineInputBorder(
                        borderRadius: new BorderRadius.circular(10),
                        borderSide: new BorderSide(color: textcolor)),
                  ),
                ),
              )

            ],
          ),
          TextFormField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            //style: textStyle,
            obscureText: false,
            decoration: InputDecoration(
                labelText: 'Correo Electronico',
                /*labelStyle: placeHolderStyle,
                hoverColor: inputsTextColor,
                fillColor: backgroundColor,*/
                //filled: true,
                focusedBorder: UnderlineInputBorder(
                    borderRadius: new BorderRadius.circular(10),
                    borderSide: new BorderSide(color: Colors.black)),
                enabledBorder: UnderlineInputBorder(
                    borderRadius: new BorderRadius.circular(10),
                    borderSide: new BorderSide(color: textcolor)),
                prefixIcon: Icon(
                  Icons.email,
                  color: Colors.black,
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
              //mapData['email'] = enc(value);
              //mapData['email'] = value;
              },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child:  TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  validator: (value) {
                    print(value);
                    if (RegExp('^.*[!\$@#%^&*(),.?":{}<>].*').hasMatch(value) &&
                        value.length > 7) {
                      return null;
                    } else {
                      return '$pass1Label invalida';
                    }
                  },
                  decoration: InputDecoration(
                    labelText: pass1Label,
                    focusedBorder: UnderlineInputBorder(
                        borderRadius: new BorderRadius.circular(10),
                        borderSide: new BorderSide(color: Colors.black)),
                    enabledBorder: UnderlineInputBorder(
                        borderRadius: new BorderRadius.circular(10),
                        borderSide: new BorderSide(color: textcolor)),
                  ),
                ),
              ),
              Expanded(
                child: TextFormField(
                  controller: passwordController2,
                  obscureText: true,
                  validator: (value) {
                    print(value);
                    if (RegExp('^.*[!\$@#%^&*(),.?":{}<>].*').hasMatch(value) &&
                        value.length > 7) {
                      return null;
                    } else {
                      return '$pass2Label invalida';
                    }
                  },
                  decoration: InputDecoration(
                    labelText: pass2Label,
                    focusedBorder: UnderlineInputBorder(
                        borderRadius: new BorderRadius.circular(10),
                        borderSide: new BorderSide(color: Colors.black)),
                    enabledBorder: UnderlineInputBorder(
                        borderRadius: new BorderRadius.circular(10),
                        borderSide: new BorderSide(color: textcolor)),
                  ),
                ),
              )

            ],
          ),
          TextFormField(
            keyboardType: TextInputType.number,
            controller: phoneController,
            inputFormatters: <TextInputFormatter> [WhitelistingTextInputFormatter.digitsOnly],
            decoration: InputDecoration(
                labelText: phoneLabel,
                focusedBorder: UnderlineInputBorder(
                    borderRadius: new BorderRadius.circular(10),
                    borderSide: new BorderSide(color: Colors.black)),
                enabledBorder: UnderlineInputBorder(
                    borderRadius: new BorderRadius.circular(10),
                    borderSide: new BorderSide(color: textcolor)),
                prefixIcon: Icon(
                  Icons.phone,
                  color: Colors.black,
                )
            ),
            validator: (value) {
              if (RegExp('[0-9]{10}').hasMatch(value)) {
                return null;
              } else {
                return '$phoneLabel invalido';
              }
            },
          ),
          Center(
            child: DropdownButton<String>(
              value: _selectGenero,
              icon: Icon(Icons.person_outline),
              style: TextStyle(color: Colors.black),
              underline: Container(
                height: 2,
                color: textcolor,
              ),
              onChanged: (String newValue) {
                setState(() {
                  _selectGenero = newValue;
                });
              },
              items: <String>['Masculino', 'Femenino']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),

          Container(
            child: MyCalendar(
              controller: calendarController,
              name: 'Cumpleaños',
            ),
          )




        ],
      ),
    );
  }

  Widget _buttonSellerCreate(){
    return MaterialButton(
      onPressed: () {
        if(formKey.currentState.validate()){
          formKey.currentState.save();
          mapData["name"] = nameController.text;
          mapData["last_name"] = lastnameController.text;
          mapData["email"] = enc(emailController.text);
          mapData["password"] = enc(passwordController.text);
          mapData["password_confirmation"] = enc(passwordController2.text);
          mapData["rol_id"] = "2";
          mapData["birthday"] = calendarController.text;
          //mapData["birthday"] = "12-12-12";
          mapData["genre"] = _selectGenero;
          mapData["phone"] = enc(phoneController.text);
          print(JsonEncoder().convert(mapData));
          if(passwordController.text == passwordController2.text){
            Api.registro(JsonEncoder().convert(mapData)).then((value) {
              print(value);
              if(value){
                _alert("Registro Exitoso");
                
              }else{
                _alert("Error al Registrar");
              }
            });
          }else{
            _alert("Contraseñas no coniciden");
          }

        }

      },
      padding: EdgeInsets.fromLTRB(80, 0, 80, 0),
      color: textcolor,
      child: Text(
        "Aceptar",
        style: TextStyle(
          fontSize: 20.0,
          color: Colors.black,
        ),
      ),
    );
  }

  void _alert(String text){
    AlertDialog dialog = AlertDialog(
      title: Text(text),
      actions: <Widget>[
        FlatButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Ok'),
        )
      ],

    );
     showDialog(
         context: context,
         builder: (BuildContext context) {
           return dialog;
         });
  }

}
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