import 'package:http/http.dart' as http;
import 'package:login_app/src/encrypt.dart';
import 'package:login_app/src/extras/variables.dart' as globals;
import 'package:login_app/src/screens/mainView.dart';
import 'package:login_app/src/screens/productForm.dart';
import 'package:login_app/src/screens/productList.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:login_app/Api/Api.dart';
import 'package:login_app/configs.dart';

Map<String, int> resultCategory = new Map();
Widget tableWidget;
final TextEditingController categoryController = TextEditingController();
final TextEditingController categoryControllerCreate = TextEditingController();
List<String> categorys = [];
List categorysTemp = [];

class Categories extends StatefulWidget {
  Categories({Key key}) : super(key: key);

  @override
  _CategoriesState createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  @override
  void initState() {
    initCategory();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: textcolor,
          title: Text('Categorías'),
        ),
        body: SingleChildScrollView(
          child:Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Align(
              alignment: Alignment.topCenter,
              child: Column(
                children: <Widget>[
                  table(categorysTemp, context),
                  RaisedButton(
                    child: Icon(Icons.add),
                    color: submitFormButtonColor,
                    onPressed: () {
                      showDialog(
                          builder: (context) => AlertDialog(
                                title: Text('Crear categoría'),
                                content: nameField(
                                            'Nombre', categoryControllerCreate),
                                actions: <Widget>[
                                  FlatButton(
                                    onPressed: () {
                                      Api.create_category({
                                        'name': categoryControllerCreate.text
                                      }).then((onValue){
                                        if(onValue){
                                          Navigator.pop(context);
                                          Navigator.push(context,
                                            MaterialPageRoute(builder: (context) => MainView()));
                                        }else{
                                          showDialog(
                                          builder: (context) => AlertDialog(
                                                title: Text(
                                                    'Error al agregar categoria'),
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
                                     
                                    },
                                    child: Text('Registrar'),
                                  ),
                                ],
                              ),
                          context: context);
                    },
                  ),
                ],
              ),
            )
          ],
        )));
    // );
  }

  void initCategory() async {
    categorys.clear();
    await Api.categorias_get().then((value) {
      categorysTemp = json.decode(value);
    });
    setState(() {
      categorysTemp = categorysTemp;
      categorysTemp.forEach((element) {
        categorys.add(element['name']);
        resultCategory[element['name']] = element['id'];
      });
    });
  }
}

Widget table(List<dynamic> myRowDataList, BuildContext context) {
  final rowsTable = <DataRow>[];
  myRowDataList.forEach((element) {
    rowsTable.add(DataRow(cells: [
      DataCell(Text(element['name'])),
      DataCell(RaisedButton(
          child: Icon(Icons.edit),
          color: const Color(0xFF1BC0C5),
          onPressed: () {
            //
            categoryController.text = element['name'];
            showDialog(
                builder: (context) => AlertDialog(
                      title: Text('Actualizar categoría'),
                      content:nameField('Nombre', categoryController),
                      actions: <Widget>[
                        FlatButton(
                          onPressed: () {
                            Api.update_category(
                                {'name': categoryController.text},
                                element['id']);
                            Navigator.pop(context);
                            Navigator.push(context,
                              MaterialPageRoute(builder: (context) => MainView()));
                              categoryController.clear();
                          },
                          child: Text('Actualizar'),
                        ),
                      ],
                    ),
                context: context);
            //
          }))
    ]));
  });

  return Center(
    child: DataTable(
    columns: const <DataColumn>[
      DataColumn(
        label: Text(
          'Nombre categoría',
          style: TextStyle(fontStyle: FontStyle.normal),
        ),
      ),
      DataColumn(
        label: Text(
          'Editar',
          style: TextStyle(fontStyle: FontStyle.normal),
        ),
      ),
    ],
    rows: rowsTable,
  ));
}

Widget nameField(String name, TextEditingController controller) {
  return TextFormField(
    controller: controller,
    style: textStyle,
    obscureText: false,
    decoration: InputDecoration(
        labelText: name,
        labelStyle: placeHolderStyle,
        focusedBorder: underlineInputBorder),
  );
}

TextStyle placeHolderStyle = TextStyle(
    fontFamily: 'Monserrat', fontWeight: FontWeight.bold, color: textcolor);
TextStyle textStyle = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 17,
    fontFamily: 'Monserrat',
    color: inputsTextColor);

UnderlineInputBorder underlineInputBorder = UnderlineInputBorder(
    borderSide: BorderSide(color: textFieldsunderlineColor));
