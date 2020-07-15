import 'package:flutter/material.dart';
import 'package:login_app/Api/Api.dart';
import 'package:login_app/configs.dart';
import 'dart:convert';

final TextEditingController name = TextEditingController();
final TextEditingController price = TextEditingController();
final TextEditingController discount = TextEditingController();
final TextEditingController stock = TextEditingController();
final TextEditingController description = TextEditingController();
final TextEditingController size = TextEditingController();

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
    // getProducts();
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
          body: Column(
            children: <Widget>[
              Expanded(
                child: showProduct(context),
              )
            ],
          )),
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

  Widget showProduct(BuildContext cont) {
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 2,
      childAspectRatio: 0.70,
      children: List.generate(data.length, (index) {
        if (data.isNotEmpty) {
          print("Data[index] == $data[index]");
          return Card(
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                  child: Column(children: <Widget>[
                    Container(
                        child: Center(
                            child: Image.network(
                                'https://images.rappi.com.mx/restaurants_background/food-inn-comida-china-home1-1569623118508.png?d=200x200',
                                fit: BoxFit.fill))),
                    Container(
                      margin: EdgeInsets.all(15),
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
                  onTap: () => {
                        print("Data[index][ID] == \$ ${data[index]}"),
                        showInfoProduct(cont, data[index])
                      }));
        } else {
          return Card(
            child: IconButton(
              icon: Icon(Icons.error)
            ),
            
          );
        }
      }),
    );
  }
}

void showInfoProduct(BuildContext conte, Map<String, dynamic> infoProduct) {
  name.text = infoProduct["name"];
  price.text = infoProduct["name"].toString();
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
                    Center(child:
                    Image.network(
                        'https://images.rappi.com.mx/restaurants_background/food-inn-comida-china-home1-1569623118508.png?d=200x200',
                        fit: BoxFit.fill)),
                    SizedBox(height: 10.0,),
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
