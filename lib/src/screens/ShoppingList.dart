import 'package:flutter/material.dart';
import 'package:login_app/Api/Api.dart';
import 'package:login_app/configs.dart';
import 'dart:convert';

class ShoppingList extends StatefulWidget {
  ShoppingList({Key key}) : super(key: key);

  @override
  _ShoppingListState createState() => _ShoppingListState();
}

class _ShoppingListState extends State<ShoppingList> {
  List data = new List();

  @override
  void initState() {
    getBuysUser();
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
                    children: List.generate(data.length, (index) {
              return Center(
                child: Column(children: <Widget>[
                  Card(
                    clipBehavior: Clip.antiAlias,
                    margin: EdgeInsets.all(20),
                    child: InkWell(
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
                                    "Monto total de compra: ${data[index]['cart_total']}",
                                    style: cardTitles,
                                  ),
                                  Text(
                                    "Fecha de la compra ${data[index]['created_at']}",
                                    style: cardText,
                                  ),
                                ])),
                              ],
                            ),
                          )
                        ],
                      ),
                      onTap: () => {
                        showDialog(
                            context: context,
                            builder: (BuildContext contextPop) {
                              return Dialog(
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(20.0)),
                                  child: SingleChildScrollView(
                                      child: SizedBox(
                                          child: Column(children: <Widget>[
                                    Card(
                                        child: Column(
                                      children: <Widget>[
                                        Text(
                                          "Producto:  ${data[index]['name']}",
                                          style: cardTitles,
                                        ),
                                        Text(
                                          "Precio: \$ ${data[index]['price']}",
                                          style: cardTitles,
                                        ),
                                        Text(
                                          "Cantidad:  ${data[index]['quantity']}",
                                          style: cardTitles,
                                        ),
                                        Text(
                                          "Porción:  ${data[index]['size']}",
                                          style: cardTitles,
                                        ),
                                        Text(
                                          "Subtotal:  ${data[index]['subtotal']}",
                                          style: cardTitles,
                                        ),
                                      ],
                                    ))
                                  ]))));
                            }),
                      },
                    ),
                  ),
                ]),
              );
            }))),
          ),
        ]),
      ),
    );
  }

  getBuysUser() async {
    List temp;
    List dataTemp;

    await Api.get_AllPayment().then((onValue) {
      dataTemp = jsonDecode(onValue);
    });

    for (var i = 0; i < dataTemp.length; i++) {
      await Api.get_UsersPayment(dataTemp[i]['sc_id']).then((sucess) {
        temp = jsonDecode(sucess);
        for (var i = 0; i < temp.length; i++) {
          var a = [
            temp[i]['product']['price'],
            temp[i]['quantity'],
            temp[i]['subtotal'],
            temp[i]['product']['name'],
            temp[i]['product']['size']
          ];
          dataTemp[i]['price'] = a[0];
          dataTemp[i]['quantity'] = a[1];
          dataTemp[i]['subtotal'] = a[2];
          dataTemp[i]['name'] = a[3];
          dataTemp[i]['size'] = a[4];
        }
      });
    }

    setState(() {
      data = dataTemp;
    });
  }
}

TextStyle cardTitles =
    TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: textcolor);

TextStyle cardText =
    TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: textcolor);
