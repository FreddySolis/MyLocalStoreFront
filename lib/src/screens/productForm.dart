import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:login_app/Api/Api.dart';
import 'package:login_app/src/encrypt.dart';
import 'package:login_app/configs.dart';

double bottomDistance = 20;
double marginDistance = 20;
DateTime date;
int id;
final TextEditingController name = TextEditingController();
final TextEditingController price = TextEditingController();
final TextEditingController discount = TextEditingController();
final TextEditingController stock = TextEditingController();
final TextEditingController description = TextEditingController();
final TextEditingController size = TextEditingController();

class ProductForm extends StatefulWidget {
  final String text;
  ProductForm({this.text, Key key}) : super(key: key);

  @override
  _ProductFormState createState() => _ProductFormState();
}

class _ProductFormState extends State<ProductForm> {
  @override
  void initState() {
    initData(widget.text);
    super.initState();
  }

  void initData(String text) async {
    List dataTemp;
    await Api.product_getBySlug(text).then((sucess) {
      dataTemp = jsonDecode(sucess);
    });
    setState(() {
      name.text = dataTemp[0]['name'];
      price.text = dataTemp[0]['price'].toString();
      discount.text = dataTemp[0]['discount'].toString();
      stock.text = dataTemp[0]['stock'].toString();
      description.text = dataTemp[0]['description'];
      size.text = dataTemp[0]['size'];
      id = dataTemp[0]['id'];
    });
  }

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  var mapData = new Map<String, String>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: textcolor,
        title: Text('productos'),
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
                        rowNameAndPrice(
                            'Nombre', 'precio', 'name', 'price', name, price),
                        Padding(
                            padding: EdgeInsets.only(bottom: bottomDistance)),
                        rowDiscountAndStock('Descuento', 'cantidad', 'discount',
                            'stock', discount, stock),
                        Padding(
                            padding: EdgeInsets.only(bottom: bottomDistance)),
                        rowDescriptionAndSize('Descripcion', 'Tamaño',
                            'description', 'size', description, size),
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
          mapData['slug'] = 'testSlug';
          mapData['category_id'] = '1';
          mapData['final_price'] = (int.parse(mapData['price']) *
                  (int.parse(mapData['discount']) / 100))
              .toString();
          print(mapData['final_price']);
          if (widget.text == '') {
            Api.product_create(JsonEncoder().convert(mapData))
                .then((sucess) {
              if (sucess) {
                //print(sucess);
              } else {

              }
            });
          } else {
            Api.product_update(JsonEncoder().convert(mapData), id)
                .then((sucess) {
              if (sucess) {
                print(sucess);
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
        }
      },
    );
  }

  Widget rowDescriptionAndSize(
      String nombre1,
      String nombre2,
      String jsonName,
      String jsonName2,
      TextEditingController controller1,
      TextEditingController controller2) {
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

  Widget rowDiscountAndStock(
      String nombre1,
      String nombre2,
      String jsonName,
      String jsonName2,
      TextEditingController controller1,
      TextEditingController controller2) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Padding(padding: EdgeInsets.fromLTRB(marginDistance, 0, 0, 0)),
        Expanded(
          child: Column(
            children: <Widget>[
              Container(child: priceField(nombre1, jsonName, controller1)),
            ],
          ),
        ),
        Padding(padding: EdgeInsets.fromLTRB(0, 0, marginDistance, 0)),
        Expanded(
          // wrap your Column in Expanded
          child: Column(
            children: <Widget>[
              Container(child: priceField(nombre2, jsonName2, controller2)),
            ],
          ),
        ),
      ],
    );
  }

  Widget rowNameAndPrice(
      String nombre1,
      String nombre2,
      String jsonName,
      String jsonName2,
      TextEditingController controller1,
      TextEditingController controller2) {
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
              Container(child: priceField(nombre2, jsonName2, controller2)),
            ],
          ),
        ),
      ],
    );
  }

  Widget nameField(
      String name, String mapName, TextEditingController controller) {
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
        mapData[mapName] = enc(value);
      },
    );
  }

  Widget priceField(
      String name, String mapName, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      style: textStyle,
      obscureText: false,
      decoration: InputDecoration(
          labelText: name,
          labelStyle: placeHolderStyle,
          focusedBorder: underlineInputBorder),
      validator: (value) {
        if (RegExp('[0-9]+').hasMatch(value)) {
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
}

////
TextStyle placeHolderStyle = TextStyle(
    fontFamily: 'Monserrat', fontWeight: FontWeight.bold, color: textcolor);
TextStyle textStyle = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 17,
    fontFamily: 'Monserrat',
    color: inputsTextColor);

UnderlineInputBorder underlineInputBorder = UnderlineInputBorder(
    borderSide: BorderSide(color: textFieldsunderlineColor));
