import 'package:flutter/material.dart';
import 'package:login_app/src/screens/addressView.dart';
import 'package:login_app/src/screens/createSeller.dart';
import 'package:login_app/src/screens/firstView.dart';
import 'package:login_app/src/screens/mainView.dart';
import 'package:login_app/src/screens/paymentsView.dart';
import 'package:login_app/src/screens/productForm.dart';

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


/*void main(){
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
        '/MainView':(context) => MainView(),
        '/createSeller':(context) => CreateSeller(),
        '/createProduct':(context) => ProductForm(),
        '/sellers':(context) => PaymentsView(),
        '/address':(context) => AddressView(),
        '/shoppingCar':(context) => ShoppingCar(),
        '/put_user':(context) => AddressView(),
      },
    );
  }
}*/