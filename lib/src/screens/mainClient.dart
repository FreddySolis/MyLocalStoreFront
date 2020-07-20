import 'package:flutter/material.dart';
import 'package:login_app/src/screens/addressView.dart';
import 'package:login_app/src/screens/productList.dart';

import 'firstView.dart';

class MainClient extends StatefulWidget{
  @override
  _MainClient createState() => _MainClient();

}

class _MainClient extends State<MainClient>{
  int _select = 0;
  String _selectTitle = "Productos";

  @override
  void initState() {
    super.initState();

  }
  _getDrawerItemWidget(int p){
    switch(p){
      case 0: return ProductList();
      case 1: return AddressView();

    }
  }
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.exit_to_app,color: Colors.white,size: 30.0) ,
              onPressed: null,
              color: Colors.black,),
            Text(_selectTitle),
          ],
        ),

      ),
      endDrawer: Drawer(
          child: _listViewVendedor()
      ),
      body: _getDrawerItemWidget(_select),
    );
  }

  Widget _listViewVendedor(){
    return ListView(
      children: <Widget>[
        UserAccountsDrawerHeader(
          accountName: Text("Joseph Joestar"),
          accountEmail: Text("joseph@hotmail.com"),
          currentAccountPicture: CircleAvatar(
            backgroundColor: Colors.red,
            child: Text("J", style: TextStyle(fontSize: 40),),
          ),
        ),
        ListTile(
          title: Text("Productos"),
          leading: Icon(Icons.shopping_basket),
          selected: (0 == _select),
          onTap: (){
            setState(() {
              Navigator.of(context).pop();
              _select = 0;
              _selectTitle = "Productos";
            });
          },
        ),
        ListTile(
          title: Text("Perfil"),
          leading: Icon(Icons.person),
          selected: (1 == _select),
          onTap: (){
            setState(() {
              Navigator.of(context).pop();
              _select = 1;
              _selectTitle = "Perfil";
            });
          },
        ),

        ListTile(
          title: Text("Carro"),
          leading: Icon(Icons.shopping_cart),
          selected: (2 == _select),
          onTap: (){
            setState(() {
              Navigator.of(context).pop();
              _select = 2;
              _selectTitle = "Carro";
            });
          },
        ),
        ListTile(
          title: Text("Mis Compras"),
          leading: Icon(Icons.format_list_bulleted),
          selected: (3 == _select),
          onTap: (){
            setState(() {
              Navigator.of(context).pop();
              _select = 3;
              _selectTitle = "Mis Compras";
            });
          },
        ),
        Divider(),

      ],
    );
  }
}