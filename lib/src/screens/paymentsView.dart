import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:login_app/Api/Api.dart';

import '../../configs.dart';


class PaymentsView extends StatefulWidget {
  @override
  _PaymentsViewState createState() => _PaymentsViewState();
}

class _PaymentsViewState extends State<PaymentsView>{
  var payment = new List<Payment>();
  User user = null;
  var products = new List<Producto>();
  bool paymentsExist = false;

  @override
  void initState(){
    getPayment();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appbarr(),
      body: Container(
        child: Column(
          children: <Widget>[
            _listPayment()
          ],
        ),
      ),
    );
  }

  Widget _listPayment(){
    if(paymentsExist){
      return SingleChildScrollView(
          child: Container(
            child: Column(
              children: <Widget>[
                ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: payment.length,
                    itemBuilder: (context, index) => _Ventas(context, index)
                ),
              ],
            ),

          )
      );
    }else{
      return Container(
        padding: EdgeInsets.all(15.0),
        alignment: Alignment.centerLeft,
        child: Text(
          "Aun no existen ventas :(",
          style: TextStyle(
            fontSize: 40.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }


  }
  Widget _appbarr(){
    return AppBar(
      backgroundColor: textcolor,
      title: Text("Ventas", style: TextStyle(color: Colors.black),),
    );
  }

  getPayment() async{
    payment =[];
   /* for(var i=0; i < 3; i++){
      Payment direc = Payment(i,i, i+1, "status", 100, "created_at");
      payment.add(direc);
    }*/
    Api.get_Ventas().then((value){
      if(value != null){
        var jsonData = json.decode(value.body);
        setState(() {
          for(var i in jsonData){
            Payment direc = Payment(i["id"],i["user_id"], i["sc_id"], i["status"], i["cart_total"], i["created_at"]);
            payment.add(direc);
          }
          if(payment.length > 0){
            setState(() {
              paymentsExist = true;
            });
          }else {
            setState(() {
              paymentsExist = false;
            });
          }
        });
        //get_ShoppingCar();
        print(payment.length);
      }
    });
  }
  getUser(int id) async{
    user = User("name $id","last_name", "email", "phone", "genre");

    /*Api.get_userById(id).then((value){
      if(value != null){
        var jsonData = json.decode(value.body);
        setState(() {
          user = User(jsonData["name"],jsonData["last_name"], jsonData["email"], jsonData["phone"], jsonData["genre"]);
        });
      }
    });*/
  }
  getProducts(int id) async{
    for(var i = 0; i<5;i++){
      Producto direc = Producto(i,"produto $i", i+3);
      products.add(direc);
    }
    /*Api.get_UsersPayment(id).then((value){
      if(value != null){
        var jsonData = json.decode(value);
        setState(() {
          for(var i in jsonData['product']){
            Producto direc = Producto(i["id"],i["user_id"], i["sc_id"], i["status"], i["cart_total"], i["created_at"]);
            products.add(direc);
          }
        });
        //get_ShoppingCar();
        print(products.length);
      }
    });*/
  }

  Widget _Ventas(BuildContext context, int index){
    return Container(
      child: Column(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              var i = payment[index].id;
              print("index $i");
              getUser(payment[index].user_id);
              getProducts(payment[index].sc_id);
              _showDialog(i);
            } ,
            child:Container(
              width: 400,
              child: _cardVentas(index),
            )
          )

        ],
      ),
    );
  }

  Widget _cardVentas(int index){
    int id = payment[index].id;
    int user_id = payment[index].user_id;
    int sc_id = payment[index].sc_id;
    int total = payment[index].cart_total;
    return Card(
      margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
      elevation: 4.0,
      child: Container(
        margin: EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            Container(
              child: Text(
                "Venta numero $id",
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
              ),
            ),

            Container(
              child: Text(
                "Shopping id $sc_id",
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(50, 5, 10, 5),
              child: Text(
                "Total: $total",
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 18),
              ),
            )
          ],
        ),
      ),

    );
  }
  _showDialog(index) async{
    getUser(index);
    await showDialog(
        context: context,
        builder: (BuildContext context){
          return Container(
              padding: EdgeInsets.all(5.0),
            child: AlertDialog(
              title: Text("Detalles"),
              content: SingleChildScrollView(
                child:
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Container(
                              child: Text(
                                "Usuario",
                                textAlign: TextAlign.left,
                                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Icon(Icons.person, size: 30,)
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Container(
                              child: Text(
                                user.name,
                                textAlign: TextAlign.left,
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                            Container(
                              child: Text(
                                user.last_name,
                                textAlign: TextAlign.left,
                                style: TextStyle(fontSize: 20),
                              ),
                            )
                          ],
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            user.phone,
                            textAlign: TextAlign.left,
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            user.email,
                            textAlign: TextAlign.left,
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Produtos",
                            textAlign: TextAlign.left,
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                        SingleChildScrollView(
                          child:  Stack(
                            children: <Widget>[
                              Container(width: 200, height: 100,
                                  child: Column(
                                    children: <Widget>[
                                      ListView.builder(
                                          shrinkWrap: true,
                                          itemCount: products.length,
                                          itemBuilder: (context, index) {
                                            return Container(
                                              child: Text(products[index].name),
                                            );
                                          }
                                      ),
                                    ],
                                  )
                              ),
                            ],
                          )
                        )

                      ],
                    )

              ),
              actions: <Widget>[
              ],
            )
          );
        }
    );
  }

}

class Payment{
  final int id;
  final int user_id;
  var sc_id;
  var status;
  var cart_total;
  var created_at;

  Payment(this.id, this.user_id, this.sc_id, this.status, this.cart_total, this.created_at);
}
class User{
  var name;
  var last_name;
  var email;
  var phone;
  var genre;

  User(this.name, this.last_name, this.email, this.phone, this.genre);
}
class Producto{
  var id;
  var name;
  var price;
  var status;
  var cart_total;
  var created_at;

  Producto(this.id, this.name, this.price);
}