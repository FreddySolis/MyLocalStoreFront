import 'package:flutter/material.dart';
import 'package:login_app/Api/Api.dart';
import 'package:login_app/configs.dart';
import 'dart:convert';

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
                          // Container(
                          //   child: Image.network(
                          //       'https://images.rappi.com.mx/restaurants_background/food-inn-comida-china-home1-1569623118508.png?d=200x200',
                          //       fit: BoxFit.fill),
                          // ),
                          Container(
                            margin: EdgeInsets.all(15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
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
          SizedBox(
            height: 100,
            child:Center(
            child: Text(
              "Monto total: \$ $total"),
            ) ,
          )
          
        ]),
      ),
    );
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
        aux2.add(aux);
        suma = 0;
        print("Valor AUX ${aux}");
      });
      setState(() {
        print("total = $total");
        data2 = aux2;
        data = dataTemp;
      });
    });
  }
}

TextStyle cardTitles =
    TextStyle(fontSize: 35, fontWeight: FontWeight.bold, color: textcolor);

TextStyle cardText =
    TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: textcolor);
