import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
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
  TextEditingController phone = new TextEditingController();
  TextEditingController indications = new TextEditingController();
  TextEditingController street1 = new TextEditingController();
  TextEditingController street2 = new TextEditingController();

  var mapData = new Map<String, String>();
  var mapDataUser = new Map<String, String>();
  bool addressExist = false;
  bool _validate = false;
  bool _isLoading = false;

  var direcciones = new List<Direccion>();

  @override
  void initState() {
    super.initState();
    //addressController.text = "Los tulipanes 562, Benito Juares, Tuxtla Gutierrez, Chiapas, 27791 Mexico";
    //print(addressController.text);
    _getAddress();

  }
  _getAddress(){
    direcciones = [];
    Api.direccion_get().then((value){
      if(value != null){
        var jsonData = json.decode(value);
        setState(() {
          addressExist = true;
          for(var i in jsonData){
            Direccion direc = Direccion(i["id"],i["address"], i["contactphone"], i["indications"], i["street1"], i["street2"]);
            direcciones.add(direc);
          }
        });
        print(direcciones.length);
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffolKey,
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
    return
      SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            Container(
              child: Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(10.0),
                    child: _addressSearchTextField(),
                  ),
                  Container(
                    padding: EdgeInsets.all(10.0),
                    child: _addressInputs(),
                  ),
                  Container(
                    padding: EdgeInsets.all(10.0),
                    child: _buttonAddressAccess(),
                  ),
                  _exist()
                ],
              ),
            ),
          ],
        ),

      );

  }
  Widget _exist(){
    if(addressExist){
      return Container(
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

            ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: direcciones.length,
                itemBuilder: (context, index) => _Address(context, index)
            ),

          ],
        )
      );
    }else{
      return Container(
        padding: EdgeInsets.all(15.0),
        alignment: Alignment.centerLeft,
        child: Text(
          "Aun no tienes direccion :(",
          style: TextStyle(
            fontSize: 40.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }
  }

  Widget _Address(BuildContext context, int index){
    return Container(
        child: Column(
          children: <Widget>[
            GestureDetector(
              onTap: () {
                _showDialog(direcciones[index].id);
                var i = direcciones[index].id;
                print("index $i");
              } ,
              child: _cardAddress(index),
            )

          ],
        ),
    );
  }
  /*Widget _body(){
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
                child: _addressInputs(),
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

  }*/

  Widget _buttonAddressAccess(){
    return MaterialButton(
      onPressed: () {
        if(addressController.text != ""){
          if(phone.text != ""){
            if(indications.text != "" && street1.text != "" && street2.text != ""){
              setState(() {
                //addressController2.text = addressController.text;
                addressController.text.isEmpty ? _validate = true : _validate = false;
                //addressController.clear();
                addressExist = true;
              });
              mapData["address"] = addressController.text;
              mapData["contactphone"] = phone.text;
              mapData["indications"] = indications.text;
              mapData["street1"] = street1.text;
              mapData["street2"] = street2.text;
              print(JsonEncoder().convert(mapData));
              Api.direccion_post(JsonEncoder().convert(mapData)).then((value){
                var jsonData = json.decode(value.body);
                if(jsonData["messaje"] != "Dirección guardada exitosamente"){
                  print(value.body);
                  setState(() {
                  //addressController2.text = addressController.text;
                  //addressController.text.isEmpty ? _validate = true : _validate = false;
                  addressController.clear();
                  phone.clear();
                  indications.clear();
                  street1.clear();
                  street2.clear();
                  addressExist = true;
                  _getAddress();
                });
                  _snackBar(Text("Direccion Guardada"));
                  print("Direccion nueva: "+ addressController.text);
                }else{
                  _snackBar(Text("Error al guardar"));
                  print(jsonData);
                }
              });

            }else{
              _snackBar(Text("Aun existen campos vacios"));
              print("nell prro");
            }

          }else{
            _snackBar(Text("El numero no puede quedar vacio"));
            print("nell prro");
          }
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
        labelText: "Ingrese Nueva Direccion",
        errorText: _validate ? 'La direccion no\'puede ser vacio' : null,
        focusedBorder: UnderlineInputBorder(
            borderRadius: new BorderRadius.circular(10),
            borderSide: new BorderSide(color: Colors.black)),
        enabledBorder: UnderlineInputBorder(
            borderRadius: new BorderRadius.circular(10),
            borderSide: new BorderSide(color: Colors.blueAccent)),
      ),
      style: TextStyle(),
      country: "México",
      barrierDismissible: false,
      hintText: "Calle numero, col, cp ciudad, pais",
      noResultsText: "Sin resultados",
      exceptions: <String>[],
      coordForRef: false,
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

  Widget _addressInputs(){
    return Container(
      child: Column(
        children: <Widget>[
          TextField(
            keyboardType: TextInputType.number,
            controller: phone,
            inputFormatters: <TextInputFormatter> [WhitelistingTextInputFormatter.digitsOnly],
            decoration: InputDecoration(
                labelText: 'Numero Telefonico',
                focusedBorder: UnderlineInputBorder(
                    borderRadius: new BorderRadius.circular(10),
                    borderSide: new BorderSide(color: Colors.black)),
                enabledBorder: UnderlineInputBorder(
                    borderRadius: new BorderRadius.circular(10),
                    borderSide: new BorderSide(color: Colors.blueAccent)),
                prefixIcon: Icon(
                  Icons.phone,
                  color: Colors.black,
                )
            ),
          ),
          TextField(
            keyboardType: TextInputType.multiline,
            maxLines: null,
            controller: indications,
            decoration: InputDecoration(
                labelText: 'Indicaciones',
                focusedBorder: UnderlineInputBorder(
                    borderRadius: new BorderRadius.circular(10),
                    borderSide: new BorderSide(color: Colors.black)),
                enabledBorder: UnderlineInputBorder(
                    borderRadius: new BorderRadius.circular(10),
                    borderSide: new BorderSide(color: Colors.blueAccent)),
                ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child:  TextField(
                  controller: street1,
                  decoration: InputDecoration(
                    labelText: 'Calle 1',
                    focusedBorder: UnderlineInputBorder(
                        borderRadius: new BorderRadius.circular(10),
                        borderSide: new BorderSide(color: Colors.black)),
                    enabledBorder: UnderlineInputBorder(
                        borderRadius: new BorderRadius.circular(10),
                        borderSide: new BorderSide(color: Colors.blueAccent)),
                  ),
                ),
              ),
              Expanded(
                child: TextField(
                  controller: street2,
                  decoration: InputDecoration(
                    labelText: 'Calle 2',
                    focusedBorder: UnderlineInputBorder(
                        borderRadius: new BorderRadius.circular(10),
                        borderSide: new BorderSide(color: Colors.black)),
                    enabledBorder: UnderlineInputBorder(
                        borderRadius: new BorderRadius.circular(10),
                        borderSide: new BorderSide(color: Colors.blueAccent)),
                  ),
                ),
              )

            ],
          )
        ],
      ),
    );
  }

  Widget _cardAddress(int index){
    return Card(
      margin: EdgeInsets.all(15),
      elevation: 4.0,
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
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
                      direcciones[index].direccion,
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
            ),
            Container(
              padding: EdgeInsets.all(5.0),
              alignment: Alignment.topCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child:  Text(
                      direcciones[index].telefono,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontSize: 14, fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                  Container(
                    child: Icon(
                      Icons.phone, size: 20,
                    ),
                  )
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(5.0),
              alignment: Alignment.topCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child:  Text(
                      direcciones[index].calle1,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontSize: 14, fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                  Expanded(
                    child:  Text(
                      direcciones[index].calle2,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontSize: 14, fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(5.0),
              alignment: Alignment.topLeft,
              child: Text(
                direcciones[index].indicaciones,
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontSize: 14, fontWeight: FontWeight.bold
                ),
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
  _showDialog(index) async{
    showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            title: Text("Editar Direccion"),
            content: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  _addressSearchTextField(),
                  _addressInputs(),
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text("Aceptar"),
                onPressed: (){
                  if(addressController.text != ""){
                    if(phone.text != ""){
                      if(indications.text != "" && street1.text != "" && street2.text != ""){
                        setState(() {
                          //addressController2.text = addressController.text;
                          addressController.text.isEmpty ? _validate = true : _validate = false;
                          //addressController.clear();
                          addressExist = true;
                        });
                        mapData["address"] = addressController.text;
                        mapData["contactphone"] = phone.text;
                        mapData["indications"] = indications.text;
                        mapData["street1"] = street1.text;
                        mapData["street2"] = street2.text;
                        print(JsonEncoder().convert(mapData));
                        Api.direccion_put(index,JsonEncoder().convert(mapData)).then((value){
                          var jsonData = json.decode(value.body);
                          if(jsonData["messaje"] != "Dirección actualizada exitosamente"){
                            print(value.body);
                            setState(() {
                              //addressController2.text = addressController.text;
                              addressController.text.isEmpty ? _validate = true : _validate = false;
                              addressController.clear();
                              phone.clear();
                              indications.clear();
                              street1.clear();
                              street2.clear();
                              addressExist = true;
                              _getAddress();

                            });
                            _snackBar(Text("Direccion Guardada"));
                            Navigator.of(context).pop();
                            print("Direccion nueva: "+ addressController.text);
                          }else{
                            _snackBar(Text("Error al Actualizar"));
                            print(jsonData["messaje"]);
                          }
                        });
                      }else{
                        _snackBar(Text("Aun existen campos vacios"));
                        print("nell prro");
                      }
                    }else{
                      _snackBar(Text("El numero no puede quedar vacio"));
                      print("nell prro");
                    }
                  }else{
                    _snackBar(Text("Direccion no puede quedar vacia"));
                    print("nell prro");
                  }
                },
              ),
              FlatButton(
                child: Text("Eliminar",style: TextStyle(color: Colors.red),),
                onPressed: (){
                  Api.direccion_delete(index).then((value) {
                    var jsonData = json.decode(value.body);
                    if (jsonData["messaje"] != "Dirección eliminada exitosamente") {
                      setState(() {
                        _getAddress();
                      });
                      _snackBar(Text("Eliminacion Exitosa"));
                      Navigator.of(context).pop();
                    }else{
                      _snackBar(Text("Error al eliminar"));
                      Navigator.of(context).pop();
                    };
                  });
                },
              )
            ],
          );
        }
    );
  }
}

////////Temporal/////
class Direccion{
  final int id;
  final String direccion;
  final String telefono;
  final String indicaciones;
  final String calle1;
  final String calle2;

  Direccion(this.id,this.direccion, this.telefono, this.indicaciones, this.calle1, this.calle2);
}

