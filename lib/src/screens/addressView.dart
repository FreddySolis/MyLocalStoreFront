import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:login_app/Api/Api.dart';
import 'package:address_search_text_field/address_search_text_field.dart';

class AddressView extends StatefulWidget {
  @override
  _AddressViewState createState() => _AddressViewState();
}

class _AddressViewState extends State<AddressView> {
  final GlobalKey<ScaffoldState> _scaffolKey = new GlobalKey<ScaffoldState>();
  AddressPoint addresspoint = null;
  TextEditingController addressController = new TextEditingController();
  TextEditingController addressController2 = new TextEditingController();
  var mapData = new Map<String, String>();
  bool addressExist = false;
  bool _validate = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    //addressController.text = "Los tulipanes 562, Benito Juares, Tuxtla Gutierrez, Chiapas, 27791 Mexico";
    //print(addressController.text);
    //Api.direccion_get(1);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffolKey,
      appBar: _appbarr(),
      body: _body(),
    );
  }

  Widget _appbarr(){
    return AppBar(
      backgroundColor: Colors.green,
      title: Text("Direccion", style: TextStyle(color: Colors.black),),
    );
  }

  Widget _body(){
    if(addressExist){
      return Container(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[

              Container(
                padding: EdgeInsets.all(15.0),
                alignment: Alignment.centerLeft,
                child: Text(
                  "Direccion Actual",
                  style: TextStyle(
                    fontSize: 40.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  _showDialog();
                } ,
                child: _cardAddress(),
              )

            ],
          ),
        ),
      );

    }else{

      return Container(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(10.0),
                child: _addressSearchTextField(),
              ),
              Container(
                padding: EdgeInsets.all(10.0),
                child: _buttonAddressAccess(),
              ),
              Container(
                padding: EdgeInsets.all(15.0),
                alignment: Alignment.centerLeft,
                child: Text(
                  "Aun no tienes direccion :(",
                  style: TextStyle(
                    fontSize: 40.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      );

    }

  }

  Widget _buttonAddressAccess(){
    return MaterialButton(
      onPressed: () {
        if(addressController.text != ""){
          setState(() {
            //addressController2.text = addressController.text;
            addressController.text.isEmpty ? _validate = true : _validate = false;
            //addressController.clear();
            addressExist = true;
          });
          mapData["address"] = addressController.text;
          _snackBar(Text("Direccion Guardada"));
          print("Direccion nueva: "+ addressController.text);
        }else{
          _snackBar(Text("Direccion no puede quedar vacia"));
          print("nell prro");
        }
      },
      padding: EdgeInsets.all(8.0),
      color: Colors.lightGreen,
      child: Text(
        "Ingrese Direccion",
        style: TextStyle(
          fontSize: 20.0,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _addressSearchTextField(){
    return AddressSearchTextField(
      controller: addressController,
      decoration: InputDecoration(
        hintText: "Ingrese Nueva Direccion",
        errorText: _validate ? 'La direccion no\'puede ser vacio' : null,
      ),
      style: TextStyle(),
      country: "México",
      hintText: "Calle numero, col, ciudad, pais",
      noResultsText: "Sin resultados",
      exceptions: <String>[],
      coordForRef: true,
      onDone: (AddressPoint point) {
        print(point.latitude);
        print(point.longitude);
        print(point.address);
        print(point.found);
        print(point.country);
        addresspoint = point;
        Navigator.of(context).pop();
      },
    );
  }

  Widget _cardAddress(){
    return Card(
      margin: EdgeInsets.all(15),
      elevation: 4.0,
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(5.0),
              alignment: Alignment.topCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child:  Text(
                      addressController.text,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                  Container(
                    child: Icon(
                      Icons.send, size: 40,
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
  
  _snackBar(Text text) async{
    final snackBar = SnackBar(
      content: text,
      duration: Duration(seconds: 3),
      backgroundColor: Colors.green,
    );
    _scaffolKey.currentState.showSnackBar(snackBar);
  }
  _showDialog() async{
    showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            title: Text("Editar Direccion"),
            content: _addressSearchTextField(),
            actions: <Widget>[
              FlatButton(
                child: Text("Aceptar"),
                onPressed: (){
                  if(addressController.text != ""){
                    setState(() {
                      //addressController2.text = addressController.text;
                      addressController.text.isEmpty ? _validate = true : _validate = false;
                      //addressController.clear();
                    });
                    mapData["address"] = addressController.text;
                    _snackBar(Text("Direccion Guardada"));
                    Navigator.of(context).pop();
                    print("Direccion nueva: "+ addressController.text);
                  }else{
                    _snackBar(Text("Direccion no puede quedar vacia"));
                    print("nell prro");
                  }
                },
              ),
              FlatButton(
                child: Text("Cancelar"),
                onPressed: (){
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        }
    );
  }
}

////////Temporal/////
class Direcciones{
  final String direccion;

  Direcciones(this.direccion);
}

