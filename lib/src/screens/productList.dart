import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:login_app/Api/Api.dart';
import 'package:login_app/configs.dart';
import 'dart:convert';

final TextEditingController name = TextEditingController();
final TextEditingController price = TextEditingController();
final TextEditingController finalPrice = TextEditingController();
final TextEditingController discount = TextEditingController();
final TextEditingController stock = TextEditingController();
final TextEditingController description = TextEditingController();
final TextEditingController size = TextEditingController();
final TextEditingController category = TextEditingController();
final productsRef = FirebaseDatabase.instance.reference().child("Products");

class ProductList extends StatefulWidget {
  ProductList({Key key}) : super(key: key);

  @override
  _ProductListState createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  List data = new List();
  BuildContext context;

  @override
  void initState() {
    getProducts();
    super.initState();
  }

  @override
  Widget build(context) {
    return Container(
        child: Scaffold(
            appBar: AppBar(
              centerTitle: true,
              backgroundColor: textcolor,
              title: Text('Lista de productos'),
            ),
            body: Container(
                child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(children: <Widget>[
                Expanded(
                  child: showProduct(context),
                )
              ]),
            ))));
  }

  getProducts() async {
    List<Product> fireTemp = [];
    List dataTemp;

    await Api.product_getAll().then((sucess) {
      dataTemp = jsonDecode(sucess);

      productsRef.once().then((DataSnapshot snap) {
        var keys = snap.value.keys;
        var dat = snap.value;

        for (var oneKey in keys) {
          Product pro = Product(dat[oneKey]['img'], dat[oneKey]['slug']);
          fireTemp.add(pro);
        }
        for (int i = 0; i < dataTemp.length; i++) {
          fireTemp.forEach((g) => {
            if (dataTemp[i]['slug'] == g.slug)
              {dataTemp[i]['img'] = g.img, print("a ver ${dataTemp[i]}")}
          });
        }
        setState(() {
          data = dataTemp;
        });
      });
    });
  }

  Widget showProduct(BuildContext cont) {
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 2,
      childAspectRatio: 0.70,
      children: List.generate(data.length, (index) {
        if (data.length > 0 && data.length != null) {
          return Card(
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                  child: Column(children: <Widget>[
                    Container(
                        child: Center(
                            child: 
                              Image.network(data[index]['img'],
                                width: 700,
                                height: 180))),
                    Container(
                      margin: EdgeInsets.all(5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Center(
                            child: Text(
                              data[index]['name'],
                              style: cardTitles,
                            ),
                          ),
                          Center(
                            child: Text(
                              'Precio: \$ ${data[index]['price']}',
                              style: cardText,
                            ),
                          ),
                        ],
                      ),
                    )
                  ]),
                  onTap: () => {showInfoProduct(cont, data[index])}));
        } else {
          return Card(
            child: Text("Hello World"),
          );
        }
      }),
    );
  }
}

void showInfoProduct(BuildContext conte, Map<String, dynamic> infoProduct) {
  List imgList = [];

  productsRef
      .orderByChild("slug")
      .equalTo(infoProduct["slug"])
      .once()
      .then((DataSnapshot snap) {
    var keys = snap.value.keys;
    var dat = snap.value;

    for (var oneKey in keys) {
      Product pro = Product(dat[oneKey]['img'], dat[oneKey]['slug']);
      imgList.add(pro.img);
    }

    name.text = infoProduct["name"];
    price.text = infoProduct["price"].toString();
    discount.text = infoProduct["discount"].toString();
    stock.text = infoProduct["stock"].toString();
    description.text = infoProduct["description"];
    size.text = infoProduct["size"];

    showDialog(
        context: conte,
        builder: (BuildContext contextPop) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)), //this right here
            child: SingleChildScrollView(
              child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                          child: CarouselSlider(
                        options: CarouselOptions(autoPlay: true),
                        items: imgList
                            .map((item) => Container(
                                  child: Center(
                                      child: Image.network(item,
                                          fit: BoxFit.fill)),
                                ))
                            .toList(),
                      )),
                      SizedBox(
                        height: 10.0,
                      ),
                      TextFormFields(
                          controller: name, text: "Nombre del producto"),
                      TextFormFields(
                          controller: description, text: "Descripción"),
                      TextFormFields(controller: price, text: "Precio"),
                      TextFormFields(controller: discount, text: "Descuento"),
                      TextFormFields(controller: stock, text: "Stock"),
                      TextFormFields(controller: size, text: "Cantidad"),
                      SizedBox(
                          width: 320.0,
                          child: Column(children: <Widget>[
                            ListTile(
                              title: Row(
                                children: <Widget>[
                                  Expanded(
                                      child: FloatingActionButton(
                                    child: Icon(Icons.add_shopping_cart),
                                    backgroundColor: const Color(0xFF1BC0C5),
                                    onPressed: () {
                                      Navigator.of(contextPop).pop();
                                      cleanFields();
                                    },
                                  )),
                                  Expanded(
                                      child: FloatingActionButton(
                                    child: Icon(Icons.cancel),
                                    backgroundColor: Colors.red,
                                    onPressed: () {
                                      Navigator.of(contextPop).pop();
                                      cleanFields();
                                    },
                                  )),
                                ],
                              ),
                            )
                          ])),
                    ],
                  )),
            ),
          );
        });
  }).catchError((err) {
    print("ESTE ES EL ERROR $err");
  });
}

class Product {
  String img, slug;
  Product(this.img, this.slug);
}

void cleanFields() {
  name.clear();
  description.clear();
  price.clear();
  discount.clear();
  stock.clear();
  size.clear();
}

class TextFormFields extends StatelessWidget {
  String text;
  TextEditingController controller;

  TextFormFields({this.text, this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      style: textStyle,
      obscureText: false,
      enabled: false,
      decoration: InputDecoration(
        labelText: text,
        labelStyle: placeHolderStyle,
        focusedBorder: underlineInputBorder,
      ),
    );
  }
}

TextStyle cardTitles =
    TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: textcolor);

TextStyle cardText =
    TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: textcolor);

TextStyle placeHolderStyle = TextStyle(
    fontFamily: 'Monserrat', fontWeight: FontWeight.bold, color: textcolor);

TextStyle textStyle = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 17,
    fontFamily: 'Monserrat',
    color: inputsTextColor);

UnderlineInputBorder underlineInputBorder = UnderlineInputBorder(
    borderSide: BorderSide(color: textFieldsunderlineColor));
