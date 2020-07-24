import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:login_app/Api/Api.dart';


class PaymentsView extends StatefulWidget {
  @override
  _PaymentsViewState createState() => _PaymentsViewState();
}

class _PaymentsViewState extends State<PaymentsView>{
  var payment = new List<Payment>();

  @override
  void initState(){
    getPayment();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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

  }

  getPayment(){
    Api.get_Ventas().then((value){
      if(value != null){
        var jsonData = json.decode(value.body);
        setState(() {
          for(var i in jsonData){
            Payment direc = Payment(i["id"],i["user_id"], i["sc_id"], i["status"], i["cart_total"], i["created_at"]);
            payment.add(direc);
          }
        });
        //get_ShoppingCar();
        print(payment.length);
      }
    });
  }

  Widget _Ventas(BuildContext context, int index){
    return Container(
      child: Column(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              var i = payment[index].id;
              print("index $i");
            } ,
            child: _cardVentas(index),
          )

        ],
      ),
    );
  }

  Widget _cardVentas(int index){
    int id = payment[index].id;
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