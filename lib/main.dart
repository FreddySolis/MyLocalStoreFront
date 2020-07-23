import 'package:flutter/material.dart';
import 'package:login_app/src/screens/firstView.dart';

void main(){
  
  runApp(
    MaterialApp(
      home: Login()
    )
  );
}
class StaticVariable{
static String token = '' ;
}

/*
void main(){
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyStore',
      initialRoute: "/Login",
      routes: {
        '/Login':(context) => Login(),
        '/ProductList':(context) => ProductList(),
        '/Address':(context) => AddressView(),
        '/MainCliente':(context) => MainClient(),
      },
    );
  }
}*/