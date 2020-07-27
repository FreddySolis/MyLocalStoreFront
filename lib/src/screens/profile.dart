import 'package:flutter/material.dart';
import 'package:login_app/configs.dart';
import 'package:login_app/src/screens/productForm.dart';
import 'package:login_app/Api/Api.dart';
import 'dart:convert';
import 'package:login_app/src/extras/variables.dart' as globals;

import 'createSeller.dart';


class Profile extends StatefulWidget {
  Profile({Key key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}



String cardName1 = '';
String cardName2 = '';
String cardName3 = '';
String cardName4 = '';
Icon icon1 = Icon(
  Icons.error,
  color: Colors.red,
  size: 40,
);
Icon icon2 = Icon(
  Icons.error,
  color: Colors.red,
  size: 40,
);
Icon icon3 = Icon(
  Icons.error,
  color: Colors.red,
  size: 40,
);
Icon icon4 = Icon(
  Icons.error,
  color: Colors.red,
  size: 40,
);

class _ProfileState extends State<Profile> {
  @override
  void initState() {
    initNamesCards();
    super.initState();
  }

  /*void initData() async {
    Map<String, dynamic> dataTemp;
    await Api.get_UserByToken().then((sucess) {
      dataTemp = jsonDecode(sucess);
    });
    setState(() {
      name = dataTemp['name'];
      last_name = dataTemp['last_name'].toString();
      email = dataTemp['email'].toString();
    });
  }*/

  initNamesCards() {
    setState(() {
      if (globals.rolId == 1) {
        cardName1 = 'Crear Vendedor';
        cardName2 = 'Crear Productos';
        cardName3 = 'Ventas';
        icon1 = Icon(
          Icons.person_add,
          color: Colors.green[300],
          size: 40,
        );
        icon2 = Icon(
          Icons.create,
          color: Colors.yellow[500],
          size: 40,
        );
        icon3 = Icon(
          Icons.attach_money,
          color: Colors.green[600],
          size: 40,
        );
      } else if (globals.rolId == 2) {
        cardName1 = 'Editar info';
        cardName2 = 'ventas';
        cardName3 = 'Crear Productos';
        cardName4 = 'Actualizar contraseña';
        icon1 = Icon(
          Icons.build,
          color: Colors.green[300],
          size: 40,
        );
        icon2 = Icon(
          Icons.attach_money,
          color: Colors.green[600],
          size: 40,
        );
        icon3 = Icon(
          Icons.create,
          color: Colors.yellow[500],
          size: 40,
        );
        icon4 = Icon(
          Icons.update,
          color: Colors.yellow[500],
          size: 40,
        );
      } else {
        cardName1 = 'Editar info';
        cardName2 = 'Compras';
        cardName3 = 'Direcciones';
        // cardName4 = 'Actualizar\n\ncontraseña';
        icon1 = Icon(
        Icons.build,
        color: Colors.green[300],
        size: 40,
        );
        icon2 = Icon(
        Icons.shop,
        color: Colors.yellow[500],
        size: 40,
        );
        icon3 = Icon(
        Icons.local_shipping,
        color: Colors.brown,
        size: 40,
        );
        icon4 = Icon(
          Icons.update,
          color: Colors.yellow[500],
          size: 40,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: secondary,
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(120), child: customAppBar()),
        body: Material(
            elevation: 5,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(35), topRight: Radius.circular(35)),
            child: Container(
              child: SizedBox.expand(
                child: Container(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SingleChildScrollView(
                          child: Column(
                            children: cards(context)
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            )));
  }
}

List<Widget> cards(BuildContext context){
  if (globals.rolId == 1) {
    return <Widget>[
      profileCard('$cardName1', icon1, 1, context),
      profileCard('$cardName2', icon2, 2, context),
      profileCard('$cardName3', icon3, 3, context),
    ];
  }else{
    return <Widget>[
      profileCard('$cardName1', icon1, 1, context),
      profileCard('$cardName2', icon2, 2, context),
      profileCard('$cardName3', icon3, 3, context),
      profileCard('Actualizar\ncontraseña', icon4, 4, context)
    ];
  }
}

Widget profileCard(String text, Icon icon, int idCard, context) {
  return SizedBox(
    height: 130,
    width: 300,
    child: Card(
        color: primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: InkWell(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              icon,
              Padding(padding: EdgeInsets.only(left: 10)),
              Center(
                child: Text(
                  text,
                  style: textStyleCard,
                ),
              )
            ],
          ),
          onTap: () {
            actions(idCard, context);
          },
        )),
  );
}

void actions(int idCard, context) {
  if (globals.rolId == 1) {
    switch (idCard) {
      case 1:
        print('test 1');
        Navigator.of(context).pushNamed("/createSeller");
        break;
      case 2:
        Navigator.of(context).pushNamed("/createProduct");
        break;

      case 3:
        Navigator.of(context).pushNamed("/sellers");
        break;

      case 4:
        break;
      default:
    }
  } else if (globals.rolId == 2) {
    switch (idCard) {
      case 1:
        print('test 2');
        Navigator.of(context).pushNamed("/put_user");
        break;
      case 2:
        Navigator.of(context).pushNamed("/sellers");
        break;

      case 3:
        Navigator.of(context).pushNamed("/createProduct");
        break;

      case 4:
        Navigator.of(context).pushNamed("/updatePassword");
        break;
      
      case 5:
        break;
      default:
    }
  } else {
    switch (idCard) {
      case 1:
        print('test 3');
        Navigator.of(context).pushNamed("/put_user");
        break;
      case 2:
        Navigator.of(context).pushNamed("/shoppingList");
        break;
      case 3:
        Navigator.of(context).pushNamed("/address");
        break;
      case 4:
        Navigator.of(context).pushNamed("/updatePassword");
        break;
      case 5:
        break;
      default:
    }
  }
}

Widget customAppBar() {
  return AppBar(
    flexibleSpace: Material(
      color: Colors.transparent,
      child: Container(
          margin: EdgeInsets.fromLTRB(35, 40, 0, 0),
          alignment: Alignment.centerLeft,
          child: ListView(
            children: <Widget>[
              Row(
                children: <Widget>[
                  CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage(
                        'https://avatars1.githubusercontent.com/u/43459961?s=460&v=4'),
                  ),
                  Padding(padding: EdgeInsets.only(left: 10)),
                  Text(
                    '${globals.name}' + ' ${globals.lastName}',
                    style: textStyle,
                  )
                ],
              ),
              Container(
                  margin: EdgeInsets.only(left: 50),
                  child: Text(
                    '#${globals.email}',
                    style: textStyleSubText,
                  ))
            ],
          )),
    ),
    centerTitle: true,
    backgroundColor: secondary,
    actions: <Widget>[
      /*Container(
        margin: EdgeInsets.only(right: 5),
        child: Icon(Icons.menu),
      )*/
    ],
    elevation: 0,
  );
}

TextStyle textStyle = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 23,
    fontFamily: 'Monserrat',
    color: primary);

TextStyle textStyleCard = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 30,
    fontFamily: 'Monserrat',
    color: secondary);

TextStyle textStyleSubText = TextStyle(
  fontWeight: FontWeight.bold,
  fontSize: 15,
  fontFamily: 'Monserrat',
  color: primary.withOpacity(0.8),
);
