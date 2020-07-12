import 'package:flutter/material.dart';
import 'package:login_app/Api/Api.dart';
import 'package:login_app/configs.dart';
import 'dart:convert';


class ProductList extends StatefulWidget {
  ProductList({Key key}) : super(key: key);

  @override
  _ProductListState createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  List data = new List();

  @override
  void initState() {
    getProducts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: textcolor,
          title: Text('Lista de productos'),
        ),
        body: ListView.builder(
          itemCount: data.length,
          itemBuilder: (BuildContext context, int index) {
            return Center(
              child: Card(
                margin: EdgeInsets.all(30),
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Container(
                        child: Image.network(
                            'https://images.rappi.com.mx/restaurants_background/food-inn-comida-china-home1-1569623118508.png?d=200x200',
                            fit: BoxFit.fill),
                      ),
                      Container(
                        margin: EdgeInsets.all(15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              data[index]['name'],
                              style: cardTitles,
                            ),
                            Text(
                              data[index]['description'],
                              style: cardText,
                            ),
                            Text(
                              'Precio: \$ ${data[index]['price']}',
                              style: cardText,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  getProducts() async {
    List dataTemp;
    await Api.product_getAll().then((sucess) {
      dataTemp = jsonDecode(sucess);
    });
    setState(() {
      data = dataTemp;
    });
  }
}

TextStyle cardTitles =
    TextStyle(fontSize: 35, fontWeight: FontWeight.bold, color: textcolor);

TextStyle cardText =
    TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: textcolor);
