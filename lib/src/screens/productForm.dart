import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'package:login_app/Api/Api.dart';
import 'package:login_app/configs.dart';
import 'package:login_app/src/providers/upload_img_provider.dart';
import 'package:login_app/src/screens/mainView.dart';
import 'package:random_string/random_string.dart';

double bottomDistance = 20;
double marginDistance = 20;
DateTime date;
int id;
String slug;
List<String> categorys = [];
String selectedCategory;
int idCategory;
Map<String, int> resultCategory = new Map();
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
  UploadImgs upload = new UploadImgs();
  List<Object> images = List<Object>();
  List<File> imgs = List<File>();
  Future<File> _imageFile;

  @override
  void initState() {
    if (widget.text != null) {
      initData(widget.text);
      initCategory();
    } else {
      initCategory();
    }
    super.initState();
    setState(() {
      images.add("Add Image");
      images.add("Add Image");
      images.add("Add Image");
    });
  }

  void initData(String text) async {
    Map<String, dynamic> dataTemp;
    await Api.product_getBySlug(text).then((sucess) {
      dataTemp = jsonDecode(sucess);
      setState(() {
        name.text = dataTemp['name'];
        price.text = dataTemp['price'].toString();
        discount.text = dataTemp['discount'].toString();
        stock.text = dataTemp['stock'].toString();
        description.text = dataTemp['description'];
        size.text = dataTemp['size'];
        id = dataTemp['id'];
        idCategory = dataTemp['category_id'];
        mapData['slug'] = dataTemp['slug'];
      });
    });
  }

  void initCategory() async {
    categorys.clear();
    List categorysTemp = [];
    await Api.categorias_get().then((value) {
      categorysTemp = json.decode(value);
    });
    setState(() {
      categorysTemp.forEach((element) {
        categorys.add(element['name']);
        resultCategory[element['name']] = element['id'];
      });
    });
    if (widget.text != null) {
      Map<String, dynamic> dataTemp2;
      await Api.getCategoryById(idCategory.toString()).then((sucess) {
        dataTemp2 = jsonDecode(sucess);
      });
      setState(() {
        selectedCategory = dataTemp2['name'];
      });
    }
  }

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  var mapData = new Map<String, dynamic>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: textcolor,
        title: Text('Crear Producto'),
      ),
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
            buildGridView(),
            SizedBox(
              height: 30,
            ),
            form(context)
          ],
        ),
      )),
    );
    // );
  }

  Widget form(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          rowNameAndPrice('Nombre', 'precio', 'name', 'price', name, price),
          Padding(padding: EdgeInsets.only(bottom: bottomDistance)),
          rowDiscountAndStock(
              'Descuento', 'cantidad', 'discount', 'stock', discount, stock),
          Padding(padding: EdgeInsets.only(bottom: bottomDistance)),
          rowDescriptionAndSize('Descripcion', 'Tamaño', 'description', 'size',
              description, size),
          Padding(padding: EdgeInsets.only(bottom: bottomDistance)),
          SizedBox(
            width: double.infinity,
            // height: double.infinity,
            child: dropDown(),
          ),
          Center(child: submidButton(context)),
        ],
      ),
    );
  }

  Widget dropDown() {
    return DropdownButton<String>(
      isExpanded: true,
      value: selectedCategory,
      items: categorys.map((String value) {
        return new DropdownMenuItem<String>(
          value: value,
          child: new Text(
            value,
            style: textStyle,
          ),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          selectedCategory = value;
        });
      },
    );
  }

  Widget buildGridView() {
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 3,
      childAspectRatio: 0.45,
      children: List.generate(images.length, (index) {
        if (images[index] is ImageUploadModel) {
          ImageUploadModel uploadModel = images[index];
          return Card(
            clipBehavior: Clip.antiAlias,
            child: Stack(
              children: <Widget>[
                Image.file(
                  uploadModel.imageFile,
                  width: 500,
                  height: 700,
                ),
                Positioned(
                  right: 5,
                  top: 5,
                  child: InkWell(
                    child: Icon(
                      Icons.remove_circle,
                      size: 20,
                      color: Colors.red,
                    ),
                    onTap: () {
                      setState(() {
                        images.replaceRange(index, index + 1, ['Add Image']);
                      });
                    },
                  ),
                ),
              ],
            ),
          );
        } else {
          return Card(
            child: IconButton(
              icon: Icon(Icons.add_a_photo),
              onPressed: () {
                _onAddImageClick(index);
              },
            ),
          );
        }
      }),
    );
  }

  Future _onAddImageClick(int index) async {
    setState(() {
      _imageFile = ImagePicker.pickImage(source: ImageSource.gallery);
      getFileImage(index);
    });
  }

  void getFileImage(int index) async {
    _imageFile.then((file) async {
      if (file != null) {
        imgs.add(file);
        setState(() {
          ImageUploadModel imageUpload = new ImageUploadModel();
          imageUpload.imageFile = file;
          imageUpload.imageUrl = '';
          images.replaceRange(index, index + 1, [imageUpload]);
        });
      }
    }).catchError((onError) {
      print("EROR EN EL IMG $onError");
    });
  }

  Widget submidButton(BuildContext context2) {
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
          double discount = (int.parse(mapData['price'])) *
                  (int.parse(mapData['discount']) / 100);
          double priceDiscount = (int.parse(mapData['price']))-discount;
          mapData['category_id'] = resultCategory[selectedCategory];
          mapData['final_price'] = priceDiscount.toString();
          print(mapData['final_price']);
          if (widget.text == null) {
            slug = "Slug" + generateSlug();
            mapData['slug'] = slug;
            upload.slug = slug;
            if (imgs.length > 0) {
              Api.product_create(JsonEncoder().convert(mapData))
                  .then((sucess) async {
                if (sucess) {
                  upload.uploadStatusImg(imgs).whenComplete(clean());
                  print("longitud arreglo ${imgs.length}");
                  showDialog(
                      builder: (context) => AlertDialog(
                            title: Text('Registro exitoso'),
                            actions: <Widget>[
                              FlatButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  Navigator.push(context2,
                                  MaterialPageRoute(builder: (context) => MainView()));
                                  // Navigator.of(context2).pushReplacementNamed('/MainView');
                                },
                                child: Text('Ok'),
                              )
                            ],
                          ),
                      context: context);
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
                }
              });
            } else {
              showDialog(
                  builder: (context) => AlertDialog(
                        title: Text('Debe seleccionar al menos una imagen'),
                        actions: <Widget>[
                          FlatButton(
                            onPressed: () {
                              Navigator.pop(context);
                              // Navigator.of(context2).pushReplacementNamed('/MainView');
                            },
                            child: Text('Ok'),
                          )
                        ],
                      ),
                  context: context);
            }
          } else {
            if(imgs.length > 0){
              upload.uploadStatusImg(imgs).whenComplete(clean());
            }
            Api.product_update(JsonEncoder().convert(mapData), id)
                .then((sucess) {
              if (sucess) {
                print(sucess);
                showDialog(
                    builder: (context) => AlertDialog(
                          title: Text('Producto actualizado con exito'),
                          actions: <Widget>[
                            FlatButton(
                              onPressed: () {
                                clean();
                                Navigator.pop(context);
                                Navigator.push(context2,
                                MaterialPageRoute(builder: (context) => MainView()));
                              },
                              child: Text('Ok'),
                            )
                          ],
                        ),
                    context: context);
              } else {
                showDialog(
                    builder: (context) => AlertDialog(
                          title: Text('error al registro2'),
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
        mapData[mapName] = value;
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
        print(mapName);
        print(value);
        mapData[mapName] = value;
      },
    );
  }

  FutureOr<dynamic> clean() {
    setState(() {
      name.clear();
      price.clear();
      discount.clear();
      size.clear();
      description.clear();
      stock.clear();
      imgs.clear();
      images.clear();
      images.add("Add Image");
      images.add("Add Image");
      images.add("Add Image");
    });
  }
}

String generateSlug() {
  var num = randomNumeric(5);
  var let = randomString(5);

  var fin = num + let;

  return fin;
}

class ImageUploadModel {
  File imageFile;
  String imageUrl;

  ImageUploadModel({
    this.imageFile,
    this.imageUrl,
  });
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
