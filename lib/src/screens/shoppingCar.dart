import 'package:flutter/material.dart';
import 'package:login_app/Api/Api.dart';
import 'package:login_app/configs.dart';
import 'dart:convert';
import 'package:login_app/src/widgets/PaypalPayment.dart';

class ShoppingCar extends StatefulWidget {
  ShoppingCar({Key key}) : super(key: key);

  @override
  _ShoppingCarState createState() => _ShoppingCarState();
}

class _ShoppingCarState extends State<ShoppingCar> {
  List data = new List();
  List data2 = new List();
  int total = 0;

  @override
  void initState() {
    getProductsInCar();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        body: Column(children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
                child: Column(
                    children: List.generate(data2.length, (index) {
              return Center(
                child: Column(children: <Widget>[
                  Card(
                    margin: EdgeInsets.all(20),
                    child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.all(15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Center(
                                    child: Column(children: <Widget>[
                                  Text(
                                    data2[index]['name'],
                                    style: cardTitles,
                                  ),
                                  Text(
                                    'Precio: \$ ${data2[index]['price']}',
                                    style: cardText,
                                  ),
                                  Text(
                                    'Cantidad: ${data2[index]['cantidad']}',
                                    style: cardText,
                                  ),
                                  Text(
                                    'Subtotal: \$ ${data2[index]['subtotal']}',
                                    style: cardText,
                                  ),
                                  FloatingActionButton(
                                      child: Icon(Icons.delete),
                                      backgroundColor: Colors.red,
                                      onPressed: () {
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title:
                                                    Text("Eliminar de carrito"),
                                                content: Text(
                                                    "¿Esta seguro de eliminar este producto de su carrito?"),
                                                actions: <Widget>[
                                                  FlatButton(
                                                    color: Colors.green,
                                                    child: Text("Si"),
                                                    onPressed: () {
                                                      deleteProductInCar(data2[index]['idProduct']);
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                  ),
                                                  FlatButton(
                                                    color: Colors.red,
                                                    child: Text("No"),
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                  ),
                                                ],
                                              );
                                            });
                                      })
                                ])),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ]),
              );
            }))),
          ),
          payButton(
            Text(
              'Pagar',
              style: TextStyle(color: backgroundColor),
            ),
            Text(
              'Monto total: \$ $total',
              style: TextStyle(color: backgroundColor),
            ),
            secondary,
          ),
        ]),
      ),
    );
  }

  Widget payButton(Text text, Text text2, Color color) {
    return Material(
        elevation: 5,
        child: ButtonTheme(
            minWidth: 50.0,
            height: 50.0,
            child: RaisedButton(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
              color: color,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Center(
                    child: text,
                  ),
                  Padding(padding: EdgeInsets.all(2)),
                  Center(
                    child: text2,
                  )
                ],
              ),
              onPressed: () {
                pay();
              },
            )));
  }

  void pay() async {
    String temp = '';
    await Api.direccion_get().then((sucess) {
      temp = sucess;
    });
    if (temp != '[]') {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) => PaypalPayment(
            onFinish: (number) async {
              // payment done
              await Api.pay_ShopingCar().then((sucess) {});
              await Api.pay_id(number.toString()).then((sucess) {});
            },
          ),
        ),
      );
    } else {
      showDialog(
          builder: (context) => AlertDialog(
                title:
                    Text('agrega una direccion para poder realizar tu compra'),
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
  }

  getProductsInCar() async {
    int suma = 0;
    List dataTemp;
    List aux2 = [];
    Map<String, dynamic> aux;

    await Api.get_ShoppingCar().then((sucess) {
      dataTemp = jsonDecode(sucess);
    });
    dataTemp.forEach((value) async {
      var slug = value['product_id'];
      await Api.product_getBySlug(slug).then((succes) {
        aux = jsonDecode(succes);
        suma = suma + (aux['price'] * value['quantity']);
        aux['subtotal'] = suma;
        total = total + suma;
        aux['cantidad'] = value['quantity'];
        aux['idProduct'] = slug;
        aux2.add(aux);
        suma = 0;
        print("Valor AUX $aux");
      });
      setState(() {
        print("total = $total");
        data2 = aux2;
        data = dataTemp;
      });
    });
  }

  void deleteProductInCar(idProduct) async{
    await Api.delete_ProductShoppingCar(idProduct).then((succes) {
      if(succes){
        showDialog(
          builder: (context) => AlertDialog(
                title:
                    Text('Producto eliminado del carrito'),
                actions: <Widget>[
                  FlatButton(
                    onPressed: () {
                      Navigator.pop(context);
                      getProductsInCar();
                    },
                    child: Text('Ok'),
                  )
                ],
              ),
          context: context);
      }else{
        showDialog(
          builder: (context) => AlertDialog(
                title:
                    Text('No se pudo eliminar producto del carrito'),
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
    }).catchError((onError){
      print("error al eliminar de carro $onError");
    });
  }
}

TextStyle cardTitles =
    TextStyle(fontSize: 35, fontWeight: FontWeight.bold, color: textcolor);

TextStyle cardText =
    TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: textcolor);
