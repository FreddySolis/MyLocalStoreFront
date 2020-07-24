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
  List data = [{
        "created_at": "2020-03-16 16:10:51",
        "deleted_at": null,
        "id": 2,
        "is_active": 1,
        "name": "Maybank",
        "updated_at": "2020-03-16 16:18:06"
      },
      {
        "created_at": "2020-03-16 16:27:37",
        "deleted_at": null,
        "id": 3,
        "is_active": 1,
        "name": "India International Bank (Malaysia) Berhad",
        "updated_at": "2020-03-16 16:27:37"
      },
      {
        "created_at": "2020-03-16 16:27:37",
        "deleted_at": null,
        "id": 4,
        "is_active": 1,
        "name": "National Bank of Abu Dhabi Malaysia Berhad",
        "updated_at": "2020-03-16 16:27:37"
      }];
  int total = 0;

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
                                Center(
                                  child: Column(
                                    children: <Widget>[
                                      Text(
                                        "Compra ${data[index]['name']}",
                                        style: cardTitles,
                                      ),
                                      Text(
                                        "Fecha ${data[index]['created_at']}",
                                        style: cardText,
                                      ),
                                      // Text(
                                      //   'Cantidad: ${data[index]['cantidad']}',
                                      //   style: cardText,
                                      // ),
                                      // Text(
                                      //   'Subtotal: \$ ${data[index]['subtotal']}',
                                      //   style: cardText,
                                      // ),
                                    ]
                                  )
                                ),  
                              ],
                            ),
                          )
                        ],
                      ),
                       onTap: () => { showDialog(
                        context: context,
                        builder: (BuildContext contextPop) {
                          return Dialog(
                            shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0)),
                            child: SizedBox(
                              height: 150,
                              child: Column(
                                children: <Widget>[
                                  Text(
                                    "ID ${data[index]['id']}",
                                    style: cardTitles,
                                  ),
                                ]
                              )
                            )                      
                          );
                        }
                       ),
                      },
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

  getBuysUser() async {
    int suma = 0;
    List dataTemp;
    List aux2 = [];
    Map<String, dynamic> aux;

    await Api.get_AllPayment().then((onValue){
      print("====ESTO ES onValue====");
      print(onValue);
    });
    // await Api.get_UsersPayment(3).then((sucess) {
    //   dataTemp = jsonDecode(sucess);
    //   // aux = jsonDecode(sucess);
    //   print("====ESTO ES DATATEMP====");
    //   print(dataTemp);
    // });
    // dataTemp.forEach((value) async {
    //   var slug = value['product_id'];
    //   await Api.product_getBySlug(slug).then((succes) {
    //     aux = jsonDecode(succes);
    //     suma = suma + (aux['price'] * value['quantity']);
    //     aux['subtotal'] = suma;
    //     total = total + suma;
    //     aux['cantidad'] = value['quantity'];
    //     aux2.add(aux);
    //     suma = 0;
    //     print("Valor AUX ${aux}");
    //   });
      setState(() {

        // print("total = $total");
        // data2 = aux2;
        // data = dataTemp;
      });
    // });
  }
}

TextStyle cardTitles =
    TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: textcolor);

TextStyle cardText =
    TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: textcolor);
