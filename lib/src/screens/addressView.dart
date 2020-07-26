import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:login_app/Api/Api.dart';
import 'package:address_search_text_field/address_search_text_field.dart';

import '../../configs.dart';

class AddressView extends StatefulWidget {
  @override
  _AddressViewState createState() => _AddressViewState();
}

class _AddressViewState extends State<AddressView> {
  final GlobalKey<ScaffoldState> _scaffolKey = new GlobalKey<ScaffoldState>();
  AddressPoint addresspoint = null;
  TextEditingController addressController = new TextEditingController();
  TextEditingController street = new TextEditingController();
  TextEditingController number = new TextEditingController();
  TextEditingController col = new TextEditingController();
  TextEditingController city = new TextEditingController();
  TextEditingController state = new TextEditingController();
  TextEditingController country = new TextEditingController();
  TextEditingController code = new TextEditingController();
  TextEditingController phone = new TextEditingController();
  TextEditingController indications = new TextEditingController();
  TextEditingController street1 = new TextEditingController();
  TextEditingController street2 = new TextEditingController();

  var mapData = new Map<String, String>();
  var mapDataUser = new Map<String, String>();
  bool addressExist = false;
  bool _validate = false;
  bool _isLoading = false;

  String _selectCountry = 'Mexico';
  String _selectState = 'Chiapas';
  List<String> _estados= ['Aguascalientes','Baja' 'California','Baja California Sur','Campeche','Chiapas','Chihuahua','Coahuila','Colima','Distrito Federal',
    'Durango','Estado de México','Guanajuato','Guerrero','Hidalgo','Jalisco','Michoacán','Morelos','Nayarit','Nuevo León','Oaxaca','Puebla','Querétaro','Quintana Roo','San Luis Potosí',
    'Sinaloa','Sonora','Tabasco','Tamaulipas','Tlaxcala','Veracruz','Yucatán','Zacatecas'];

  var direcciones = new List<Direccion>();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> formKey2 = GlobalKey<FormState>();

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
          for(var i in jsonData){
            Direccion direc = Direccion(i["id"],i["street"], i["phone_number"], i["zip_code"], i["city"], i["state"]);
            direcciones.add(direc);
          }
          if(direcciones.length > 0){
            setState(() {
              addressExist = true;
            });
          }else{
            setState(() {
              addressExist = false;
            });
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
      appBar: _appbarr(),
      body: _body(context),
    );
  }

  Widget _appbarr(){
    return AppBar(
      backgroundColor: submitFormButtonColor,
      title: Text("Direccion", style: TextStyle(color: Colors.black),),
    );
  }
  Widget _body(BuildContext context){
    return
      SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            Container(
              child: Column(
                children: <Widget>[
                  /*Container(
                    padding: EdgeInsets.all(10.0),
                    child: _addressSearchTextField(),
                  ),*/
                  Container(
                    padding: EdgeInsets.all(10.0),
                    child: Form(
                      key: formKey,
                      child: _addressInputs(),
                    )
                  ),
                  Container(
                    width: 300,
                    padding: EdgeInsets.all(10.0),
                    child: _buttonAddressAccess(),
                  ),
                  _exist(context)
                ],
              ),
            ),
          ],
        ),

      );

  }
  Widget _exist(context){
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
                _showDialog(direcciones[index].id, context);
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
        if(formKey.currentState.validate()){
          formKey.currentState.save();
          setState(() {
            //addressController2.text = addressController.text;
            addressController.text.isEmpty ? _validate = true : _validate = false;
            //addressController.clear();

          });
          //mapData["address"] = addressController.text;
          mapData["street"] = street.text;
          //mapData["number"] = number.text;
          mapData["zip_code"] = code.text;
          //mapData["col"] = col.text;
          //mapData["city"] = city.text;
          mapData["city"] = city.text;
          //mapData["state"] = state.text;
          mapData["state"] = _selectState;
          mapData["country"] =  _selectCountry;
          mapData["phone_number"] = phone.text;
          /*mapData["indications"] = indications.text;
              mapData["street1"] = street1.text;
              mapData["street2"] = street2.text;*/
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
                street.clear();
                code.clear();
                city.clear();
                _selectState = "Chiapas";
                _selectCountry = "Mexico";
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
          _snackBar(Text("Existen campos vacios o erroneos"));
          print("nell prro");
        }


      },
      padding: EdgeInsets.all(8.0),
      color: submitFormButtonColor,
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
        List<String> split = addressController.text.split(",");
        for(int i=0; i<split.length ; i++){
          print(split[i]);
        }
        print(addressController.text);
        Navigator.of(context).pop();
      },
    );
  }

  Widget _addressInputs(){
    return Container(
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child:  TextFormField(
                  controller: street,
                  validator: (value) {
                    if (RegExp('[a-zA-Z]+').hasMatch(value)) {
                      return null;
                    } else {
                      return 'Calle invalida';
                    }
                  },
                  decoration: InputDecoration(
                    labelText: 'Calle',
                    focusedBorder: UnderlineInputBorder(
                        borderRadius: new BorderRadius.circular(10),
                        borderSide: new BorderSide(color: Colors.black)),
                    enabledBorder: UnderlineInputBorder(
                        borderRadius: new BorderRadius.circular(10),
                        borderSide: new BorderSide(color: Colors.blueAccent)),
                  ),
                ),
              ),
              /*Container(
                  width: 100,
                  child: TextField(
                    controller: number,
                    decoration: InputDecoration(
                      labelText: 'Numero',
                      focusedBorder: UnderlineInputBorder(
                          borderRadius: new BorderRadius.circular(10),
                          borderSide: new BorderSide(color: Colors.black)),
                      enabledBorder: UnderlineInputBorder(
                          borderRadius: new BorderRadius.circular(10),
                          borderSide: new BorderSide(color: Colors.blueAccent)),
                    ),
                  ),
                ),*/
              Container(
                width: 100,
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  controller: code,
                  validator: (value) {
                    if (RegExp('[0-9]{5}').hasMatch(value)) {
                      return null;
                    } else {
                      return 'Codigo Postal invalido';
                    }
                  },
                  inputFormatters: <TextInputFormatter> [WhitelistingTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(
                    labelText: 'Codigo Postal',
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
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              /*Expanded(
                child:  TextField(
                  controller: col,
                  decoration: InputDecoration(
                    labelText: 'Colonia',
                    focusedBorder: UnderlineInputBorder(
                        borderRadius: new BorderRadius.circular(10),
                        borderSide: new BorderSide(color: Colors.black)),
                    enabledBorder: UnderlineInputBorder(
                        borderRadius: new BorderRadius.circular(10),
                        borderSide: new BorderSide(color: Colors.blueAccent)),
                  ),
                ),
              ),*/
              Expanded(
                child: TextFormField(
                  controller: city,
                  validator: (value) {
                    if (RegExp('[a-zA-Z]+').hasMatch(value)) {
                      return null;
                    } else {
                      return 'Ciudad invalida';
                    }
                  },
                  decoration: InputDecoration(
                    labelText: 'Ciudad',
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
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: DropdownButton<String>(
                  value: _selectState,
                  style: TextStyle(color: Colors.black, fontSize: 18),
                  underline: Container(
                    height: 2,
                    color: Colors.blue,
                  ),
                  onChanged: (String newValue) {
                    setState(() {
                      _selectState = newValue;
                    });
                  },
                  items: <String>['Aguascalientes','Baja' 'California','Baja California Sur','Campeche','Chiapas','Chihuahua','Coahuila','Colima','Distrito Federal',
                    'Durango','Estado de México','Guanajuato','Guerrero','Hidalgo','Jalisco','Michoacán','Morelos','Nayarit','Nuevo León','Oaxaca','Puebla','Querétaro','Quintana Roo','San Luis Potosí',
                    'Sinaloa','Sonora','Tabasco','Tamaulipas','Tlaxcala','Veracruz','Yucatán','Zacatecas']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                /*TextField(
                  controller: state,
                  decoration: InputDecoration(
                    labelText: 'Estado',
                    focusedBorder: UnderlineInputBorder(
                        borderRadius: new BorderRadius.circular(10),
                        borderSide: new BorderSide(color: Colors.black)),
                    enabledBorder: UnderlineInputBorder(
                        borderRadius: new BorderRadius.circular(10),
                        borderSide: new BorderSide(color: Colors.blueAccent)),
                  ),
                ),*/
              ),
              Container(
                child: DropdownButton<String>(
                  value: _selectCountry,
                  style: TextStyle(color: Colors.black,  fontSize: 18),
                  underline: Container(
                    height: 2,
                    color: Colors.blue,
                  ),
                  onChanged: (String newValue) {
                    setState(() {
                      _selectCountry = newValue;
                    });
                  },
                  items: <String>['Mexico']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                /*TextFormField(
                  controller: country,
                  validator: (value) {
                    if (RegExp('[a-zA-Z]+').hasMatch(value)) {
                      return null;
                    } else {
                      return 'Campo invalido';
                    }
                  },
                  decoration: InputDecoration(
                    labelText: 'Pais',
                    focusedBorder: UnderlineInputBorder(
                        borderRadius: new BorderRadius.circular(10),
                        borderSide: new BorderSide(color: Colors.black)),
                    enabledBorder: UnderlineInputBorder(
                        borderRadius: new BorderRadius.circular(10),
                        borderSide: new BorderSide(color: Colors.blueAccent)),
                  ),
                ),*/
              )

            ],
          ),
          TextFormField(
            keyboardType: TextInputType.number,
            validator: (value) {
              if (RegExp('[0-9]{10}').hasMatch(value)) {
                return null;
              } else {
                return 'Numero invalido';
              }
            },
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
          /*TextField(
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
          ),*/
          /*Row(
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
          )*/
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
                    child: Text(
                      "Calle : ${direcciones[index].calle}",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontSize: 25, fontWeight: FontWeight.bold
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child:  Text(
                      "Telefono de Contacto: ${direcciones[index].telefono}",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.normal
                      ),
                    ),
                  ),
                  Expanded(
                    child: Icon(
                      Icons.phone, size: 20,
                    ),
                  ),
                  SizedBox(width: 80,)
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(5.0),
              alignment: Alignment.topCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child:  Text(
                      "Ciudad : ${direcciones[index].ciudad}",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                  Expanded(
                    child:  Text(
                      "Estado : ${direcciones[index].estado}",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold
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
                "Codigo Postal : ${direcciones[index].codigo}",
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold
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
  _showDialog(index, BuildContext context) async{
    showDialog(
        context: context,
        builder: (context){

                return Container(
                  width: 600,
                  child: AlertDialog(
                    title: Text("Editar Direccion"),
                    content: Container(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          //_addressSearchTextField(),
                          //_addressInputs(),
                          Form(
                            key: formKey2,
                            child: _addressInputs(),
                          )
                        ],
                      ),
                    ),
                    actions: <Widget>[
                      FlatButton(
                        child: Text("Aceptar"),
                        onPressed: (){
                          if(formKey2.currentState.validate()){
                            setState(() {
                              //addressController2.text = addressController.text;
                              addressController.text.isEmpty ? _validate = true : _validate = false;
                              //addressController.clear();
                            });
                            //mapData["address"] = addressController.text;
                            mapData["street"] = street.text;
                            //mapData["number"] = number.text;
                            mapData["zip_code"] = code.text;
                            //mapData["col"] = col.text;
                            //mapData["city"] = city.text;
                            mapData["city"] = city.text;
                            //mapData["state"] = state.text;
                            mapData["state"] = _selectState;
                            mapData["country"] =  _selectCountry;
                            mapData["phone_number"] = phone.text;
                            /*mapData["indications"] = indications.text;
                        mapData["street1"] = street1.text;
                        mapData["street2"] = street2.text;*/
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
                                  street.clear();
                                  code.clear();
                                  city.clear();
                                  _selectState = "Chiapas";
                                  _selectCountry = "Mexico";
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
                            _snackBar(Text("Existen campos vacios o erroneos"));
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
                  ),
                );

        }
    );
  }
}

////////Temporal/////
class Direccion{
  final int id;
  final String calle;
  final String telefono;
  final String codigo;
  final String ciudad;
  final String estado;

  Direccion(this.id,this.calle, this.telefono, this.codigo, this.ciudad, this.estado);
}

