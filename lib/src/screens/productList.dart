import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:login_app/Api/Api.dart';
import 'package:login_app/configs.dart';
import 'package:login_app/src/extras/variables.dart' as globals;
import 'dart:convert';

final TextEditingController name = TextEditingController();
final TextEditingController price = TextEditingController();
final TextEditingController finalPrice = TextEditingController();
final TextEditingController discount = TextEditingController();
final TextEditingController stock = TextEditingController();
final TextEditingController description = TextEditingController();
final TextEditingController size = TextEditingController();
final TextEditingController category = TextEditingController();
final TextEditingController quantity = TextEditingController();
final productsRef = FirebaseDatabase.instance.reference().child("Products");

class ProductList extends StatefulWidget {
  ProductList({Key key}) : super(key: key);

  @override
  _ProductListState createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  List data = new List();
  BuildContext context;
  var categorias = new List<Categoria>();
  List<DropdownMenuItem<Categoria>> _dropCategoria;
  Categoria _selectCategoria;

  @override
  void initState() {
    getProducts();
    getCategories();
    super.initState();
  }

  List<DropdownMenuItem<Categoria>> buildDropdownMenuItems(List categorias) {
    List<DropdownMenuItem<Categoria>> items = List();
    for (Categoria cat in categorias) {
      items.add(DropdownMenuItem(
        value: cat,
        child: Text(cat.name),
      ));
    }
    return items;
  }

  @override
  Widget build(context) {
    return Container(
      child: Scaffold(
          body: Column(
        children: <Widget>[
          Container(
            child: _drowdownListCategorias(),
          ),
          Expanded(
            child: showProduct(context),
          )
        ],
      )),
    );
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

  getCategories() async {
    var categorias = new List<Categoria>();
    Categoria cat = Categoria(0, "Todos");
    categorias.add(cat);
    Api.categorias_get().then((value) {
      if (value != null) {
        var jsonData = json.decode(value.body);
        setState(() {
          for (var i in jsonData) {
            Categoria cat = Categoria(i["id"], i["name"]);
            categorias.add(cat);
          }
        });
        _dropCategoria = buildDropdownMenuItems(categorias);
        _selectCategoria = _dropCategoria[0].value;
      } else {
        print("Error");
      }
    });
  }

  filtrerProducts(id) async {
    List<Product> fireTemp = [];
    List dataTemp;

    Api.products_by_categories(id).then((value) {
      if (value != null) {
        dataTemp = json.decode(value.body);
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
      } else {
        print("Error");
      }
    });
  }

  onChangeDropItem(Categoria selectedCat) {
    print(selectedCat.id);
    if (selectedCat.id != 0) {
      filtrerProducts(selectedCat.id);
    } else {
      getProducts();
    }
    setState(() {
      _selectCategoria = selectedCat;
    });
  }

  Widget _drowdownListCategorias() {
    return Container(
      child: DropdownButton(
        value: _selectCategoria,
        items: _dropCategoria,
        onChanged: onChangeDropItem,
      ),
    );
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
                            child: Image.network(data[index]['img'],
                                width: 700, height: 180))),
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
            child: IconButton(
              icon: Icon(Icons.error),
              onPressed: () {},
            ),
          );
        }
      }),
    );
  }

  void deleteProduct(int idProduct, BuildContext contex) async {
    await Api.product_delete(idProduct).then((sucess) {
      if (sucess) {
        showDialog(
            builder: (context) => AlertDialog(
                  title: Text('Producto eliminado con éxito'),
                  actions: <Widget>[
                    FlatButton(
                      onPressed: () {
                        getProducts();
                        Navigator.pop(context);
                        Navigator.of(contex).pop();
                      },
                      child: Text('Ok'),
                    )
                  ],
                ),
            context: contex);
        return;
        // Navigator.push(context,
        //     MaterialPageRoute(builder: (context) => ProductList()));
      } else {
        showDialog(
            builder: (context) => AlertDialog(
                  title: Text('error al eliminar producto'),
                  actions: <Widget>[
                    FlatButton(
                      onPressed: () {
                        getProducts();
                        Navigator.pop(context);
                        Navigator.of(contex).pop();
                      },
                      child: Text('Ok'),
                    )
                  ],
                ),
            context: contex);
        return;
      }
    }).catchError((onError) {
      print("ESTE ES EL ERROR eliminar $onError");
    });
  }

  List<Widget> btn(BuildContext contextPop, Map<String, dynamic> infoProduct) {
    var quant = 1;
    quantity.text = quant.toString();

    if (globals.rolId == 3) {
      return <Widget>[
        Expanded(
            child: FloatingActionButton(
          child: Icon(Icons.add_shopping_cart),
          backgroundColor: const Color(0xFF1BC0C5),
          onPressed: () {
            showDialog(
                context: contextPop,
                builder: (BuildContext contextPop2) {
                  return Dialog(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                      child: SizedBox(
                          height: 150,
                          child: Column(
                            children: <Widget>[
                              ListTile(
                                title: Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: FloatingActionButton(
                                          onPressed: () {
                                            if (quant == 0) {
                                              quant = 0;
                                              quantity.text = quant.toString();
                                            } else {
                                              quant = quant - 1;
                                              quantity.text = quant.toString();
                                            }
                                          },
                                          child: Icon(Icons.remove)),
                                    ),
                                    Expanded(
                                      child: TextFormField(
                                        textAlign: TextAlign.center,
                                        controller: quantity,
                                      ),
                                    ),
                                    Expanded(
                                      child: FloatingActionButton(
                                          onPressed: () {
                                            quant = quant + 1;
                                            quantity.text = quant.toString();
                                          },
                                          child: Icon(Icons.add)),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              FloatingActionButton(
                                onPressed: () {
                                  addShopping(
                                      infoProduct['id'], quant, contextPop2);
                                },
                                child: Icon(Icons.done),
                              )
                            ],
                          )));
                });
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
      ];
    } else if (globals.rolId == 2 || globals.rolId == 1) {
      return <Widget>[
        Expanded(
          child: FloatingActionButton(
          child: Icon(Icons.edit),
          backgroundColor: const Color(0xFF1BC0C5),
          onPressed: () {
            print("PUSHANDO BTN");
            // Navigator.push(context,
            // MaterialPageRoute(builder: (context) => ProductList()));
            Navigator.of(context).pushNamed("/createProduct");
          },
        )),
        Expanded(
          child: FloatingActionButton(
          child: Icon(Icons.delete),
          backgroundColor: Colors.red,
          onPressed: () {
            deleteProduct(infoProduct['id'], contextPop);
          })),
      ];
    }
  }

  addShopping(int idProduct, int numProduct, BuildContext c) async {
    var mapData = new Map<String, int>();
    mapData['product_id'] = idProduct;
    mapData['quantity'] = numProduct;

    print(JsonEncoder().convert(mapData));
    await Api.add_ShoppingCar(JsonEncoder().convert(mapData)).then((sucess) {
      if (sucess) {
        showDialog(
            builder: (context) => AlertDialog(
                  title: Text('Agregado al carrito'),
                  actions: <Widget>[
                    FlatButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.of(c).pop();
                      },
                      child: Text('Ok'),
                    )
                  ],
                ),
            context: c);
        return;
      } else {
        updateProductInCar(idProduct, numProduct, c);
        return;
      }
    }).catchError((onError) {
      print("ESTE ES EL ERROR $onError");
    });
  }

  void updateProductInCar(
      int idProduct, int numProduct, BuildContext c2) async {
    var mapData = new Map<String, int>();
    mapData['product_id'] = idProduct;
    mapData['quantity'] = numProduct;

    await Api.update_shoppingCar(JsonEncoder().convert(mapData)).then((sucess) {
      if (sucess) {
        showDialog(
            builder: (context) => AlertDialog(
                  title: Text('Sumado al carrito'),
                  actions: <Widget>[
                    FlatButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.of(c2).pop();
                      },
                      child: Text('Ok'),
                    )
                  ],
                ),
            context: c2);
        return;
        // Navigator.push(context,
        //     MaterialPageRoute(builder: (context) => ProductList()));
      } else {
        showDialog(
            builder: (context) => AlertDialog(
                  title: Text('error al agregar a compra'),
                  actions: <Widget>[
                    FlatButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.of(c2).pop();
                      },
                      child: Text('Ok'),
                    )
                  ],
                ),
            context: c2);
        return;
      }
    }).catchError((onError) {
      print("ESTE ES EL ERROR $onError");
    });
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
                                title:
                                    Row(children: btn(contextPop, infoProduct)),
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

class Categoria {
  int id;
  String name;
  Categoria(this.id, this.name);
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
