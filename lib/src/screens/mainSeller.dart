import 'package:flutter/material.dart';

class MainSeller extends StatefulWidget{
  @override
  _MainSeller createState() => _MainSeller();

}

class _MainSeller extends State<MainSeller>{
  int _select = 0;

  @override
  void initState() {
    super.initState();

  }
  _getDrawerItemWidget(int p){
    switch(p){
      case 0: return AddressView();
      case 1: return ProductList();
      case 2: return Login();
    }
  }
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text("Menu Vendedor"),
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
          leading: Icon(Icons.person),
          selected: (0 == _select),
          onTap: (){
            setState(() {
              Navigator.of(context).pop();
              _select = 0;
            });
          },
        ),
        ListTile(
          title: Text("Nuevo Producto"),
          leading: Icon(Icons.person),
          selected: (0 == _select),
          onTap: (){
            setState(() {
              Navigator.of(context).pop();
              _select = 0;
            });
          },
        ),
        ListTile(
          title: Text("Ventas"),
          leading: Icon(Icons.shopping_cart),
          selected: (1 == _select),
          onTap: (){
            setState(() {
              Navigator.of(context).pop();
              _select = 1;
            });
          },
        ),
        ListTile(
          title: Text("Perfil"),
          leading: Icon(Icons.shopping_cart),
          selected: (1 == _select),
          onTap: (){
            setState(() {
              Navigator.of(context).pop();
              _select = 1;
            });
          },
        ),
        Divider(),
        ListTile(
          title: Text("Cerrar Sesion"),
          leading: Icon(Icons.backspace),
          selected: (2 == _select),
          onTap: (){
            setState(() {
              Navigator.of(context).pop();
              _select = 2;
            });
          },
        )
      ],
    );
  }
}