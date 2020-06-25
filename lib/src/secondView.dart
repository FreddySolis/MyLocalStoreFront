import 'package:flutter/material.dart';
import 'package:login_app/src/widgets/textField.dart';

double bottomDistance = 20;
double marginDistance = 20;

class SecondView extends StatelessWidget {
  final TextEditingController textFieldData1Controller =
      TextEditingController();
  final TextEditingController textFieldData2Controller =
      TextEditingController();
  final TextEditingController textFieldData3Controller =
      TextEditingController();
  final TextEditingController textFieldData4Controller =
      TextEditingController();
  final TextEditingController textFieldData5Controller =
      TextEditingController();
  final TextEditingController textFieldData6Controller =
      TextEditingController();
  final TextEditingController textFieldData7Controller =
      TextEditingController();

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
                      controller1: textFieldData1Controller,
                      controller2: textFieldData2Controller,
                      pass1: false,
                      pass2: false,
                    ),
                    Padding(padding: EdgeInsets.only(bottom: bottomDistance)),
                    RowWithTextFields(
                      nombre1: 'Telefono',
                      nombre2: 'Correo Electronico',
                      controller1: textFieldData3Controller,
                      controller2: textFieldData4Controller,
                      pass1: false,
                      pass2: false,
                    ),
                    Padding(padding: EdgeInsets.only(bottom: bottomDistance)),
                    Container(
                        padding: EdgeInsets.only(left: marginDistance),
                        child: TextFields(
                          text: 'Fecha de nacimiento',
                          style: placeHolderStyle,
                          controller: textFieldData5Controller,
                          obscureText: false,
                        )),
                    Padding(padding: EdgeInsets.only(bottom: bottomDistance)),
                    RowWithTextFields(
                      nombre1: 'Contraseña',
                      nombre2: 'confirmar contrase',
                      controller1: textFieldData6Controller,
                      controller2: textFieldData7Controller,
                      pass1: true,
                      pass2: true,
                    ),
                    Padding(padding: EdgeInsets.only(bottom: bottomDistance)),
                    Center(
                      child: RaisedButton(
                        onPressed: null,
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
