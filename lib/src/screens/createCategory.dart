import 'package:http/http.dart' as http;
import 'package:login_app/src/encrypt.dart';
import 'package:login_app/src/extras/variables.dart' as globals;
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
        body: Container(
            child: Column(
      children: <Widget>[
        table(categorysTemp, context),
        RaisedButton(
          child: Text('create'),
          onPressed: () {
            showDialog(
                builder: (context) => AlertDialog(
                      title: Text('create'),
                      actions: <Widget>[
                        FlatButton(
                          onPressed: () {
                            Api.create_category(
                                {'name': categoryControllerCreate.text});
                            Navigator.pop(context);
                          },
                          child: Text('ok'),
                        ),
                        Container(
                          width: 50, // do it in both Container
                          child: Column(
                            children: <Widget>[
                              nameField('name', categoryControllerCreate),
                            ],
                          ),
                        ),
                      ],
                    ),
                context: context);
          },
        ),
      ],
    )));
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
      DataCell(RaisedButton(onPressed: () {
        //
        categoryController.text = element['name'];
        showDialog(
            builder: (context) => AlertDialog(
                  title: Text('Update'),
                  actions: <Widget>[
                    FlatButton(
                      onPressed: () {
                        Api.update_category(
                            {'name': categoryController.text}, element['id']);
                        Navigator.pop(context);
                      },
                      child: Text('ok'),
                    ),
                    Container(
                      width: 50, // do it in both Container
                      child: Column(
                        children: <Widget>[
                          nameField('name', categoryController),
                        ],
                      ),
                    ),
                  ],
                ),
            context: context);
        //
      }))
    ]));
  });

  return DataTable(
    columns: const <DataColumn>[
      DataColumn(
        label: Text(
          'Name',
          style: TextStyle(fontStyle: FontStyle.italic),
        ),
      ),
      DataColumn(
        label: Text(
          'Edit',
          style: TextStyle(fontStyle: FontStyle.italic),
        ),
      ),
    ],
    rows: rowsTable,
  );
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
