import 'package:http/http.dart' as http;
import 'package:login_app/src/encrypt.dart';
import 'package:login_app/src/extras/variables.dart' as globals;
import 'package:login_app/src/screens/productForm.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class URLS {
  static const String BASE_URL =
      'http://ec2-54-81-19-209.compute-1.amazonaws.com:8000';
}

/*class URLS {
  static const String BASE_URL =
      'http://86ce75530f16.ngrok.io/';
}*/

class Api {
  static Future<bool> login(data) async {
    final response = await http.post('${URLS.BASE_URL}/login',
        body: data,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json"
        });
    if (response.statusCode >= 200 && response.statusCode <= 204) {
      Map<String, dynamic> temp = jsonDecode(response.body);
      globals.token = 'Bearer ' + temp['token'];
      await get_UserByToken();
      final prefs = await SharedPreferences.getInstance();

      prefs.setString('token', globals.token);
      print(true);

      return true;
    } else {
      return false;
    }
  }

  static Future<bool> logOut() async {
    final response = await http.post('${URLS.BASE_URL}/logout', headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Authorization": '${globals.token}'
    });
    print(response.statusCode);
    if (response.statusCode >= 200 && response.statusCode <= 204) {
      final prefs = await SharedPreferences.getInstance();

      prefs.remove('token');

      return true;
    } else {
      final prefs = await SharedPreferences.getInstance();
      prefs.remove('token');
      return false;
    }
  }

  static Future<bool> registro(data) async {
    final response = await http.post('${URLS.BASE_URL}/register',
        body: data,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json"
        });
    print(response.body);
        print(response.statusCode);
    if (response.statusCode >= 200 && response.statusCode <= 204) {
      return true;
    } else {
      return false;
    }
  }
  //change-password
  static Future<bool> update_Password(data) async {
    final response = await http.post('${URLS.BASE_URL}/change-password', body: data, headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Authorization": '${globals.token}'
    });
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> update_user(data) async {
    final response =
        await http.post('${URLS.BASE_URL}/register', body: data, headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Authorization": '${globals.token}'
    });
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

//------------- Direccion ---------
  static Future<String> direccion_get() async {
    final response = await http.get('${URLS.BASE_URL}/address/', headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Authorization": '${globals.token}'
    });
    print(response.body);
    if (response.statusCode >= 200 && response.statusCode <= 204) {
      print(response.body);
      return response.body;
    } else {
      return null;
    }
  }

  static Future<http.Response> direccion_post(data) async {
    final response =
        await http.post('${URLS.BASE_URL}/address', body: data, headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Authorization": '${globals.token}'
    });
    print(response.body);
    if (response.statusCode == 201) {
      return response;
    } else {
      return null;
    }
  }

  static Future<http.Response> direccion_put(id, data) async {
    final response =
        await http.put('${URLS.BASE_URL}/address/$id', body: data, headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Authorization": '${globals.token}'
    });
    print(response.body);
    if (response.statusCode == 200) {
      return response;
    } else {
      return null;
    }
  }

  static Future<http.Response> direccion_delete(int id) async {
    final response =
        await http.delete('${URLS.BASE_URL}/address/$id', headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Authorization": '${globals.token}'
    });
    print(response.body);
    if (response.statusCode == 200) {
      return response;
    } else {
      return null;
    }
  }

  //-------------Poductos-------
  // ignore: non_constant_identifier_names
  static Future<String> product_getAll() async {
    final response = await http.get('${URLS.BASE_URL}/products/');

    if (response.statusCode >= 200 && response.statusCode <= 204) {
      return response.body;
    } else {
      return null;
    }
  }

  // ignore: non_constant_identifier_names
  static Future<bool> product_create(data) async {
    print(data);
    final response = await http.post('${URLS.BASE_URL}/products/',
        body: data,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": '${globals.token}'
        });
    if (response.statusCode >= 200 && response.statusCode <= 204) {
      return true;
    } else {
      return false;
    }
  }

  // ignore: non_constant_identifier_names
  static Future<String> product_getBySlug(slug) async {
    print(slug);
    final response = await http.get('${URLS.BASE_URL}/products/$slug');
    if (response.statusCode >= 200 && response.statusCode <= 204) {
      return response.body;
    } else {
      return '';
    }
  }

  // ignore: non_constant_identifier_names
  static Future<bool> product_update(data, id) async {
    final response = await http.put('${URLS.BASE_URL}/products/$id',
        body: data,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": '${globals.token}'
        });
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> product_delete(id) async {
    final response =
        await http.delete('${URLS.BASE_URL}/products/$id', headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Authorization": '${globals.token}'
    });
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  // ignore: non_constant_identifier_names
  static Future<String> get_UserByToken() async {

    final response = await http.get('${URLS.BASE_URL}/auth_user', headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Authorization": '${globals.token}'
    });
    print(response.body);
    //Map<String, dynamic> temp = jsonDecode(response.body);
    Map<String, dynamic> temp = json.decode(response.body);
    globals.rolId = temp['rol_id'];
    globals.name = temp['name'];
    globals.lastName = temp['last_name'];
    globals.email = desEnc(temp['email']);
    Map<String, dynamic> dataTemp;
    if (response.statusCode >= 200 && response.statusCode <= 204) {
      dataTemp = jsonDecode(response.body);
      dataTemp['email'] = desEnc(dataTemp['email'].toString());
      dataTemp['phone'] = desEnc(dataTemp['phone']);
      
      return dataTemp.toString();
    } else {
      return '';
    }
  }


  static Future<http.Response> get_userById(int id) async {
    final response = await http.get('${URLS.BASE_URL}/user-inf/$id', headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Authorization":
      '${globals.token}'
    });
    print(response.body);
    if (response.statusCode == 200) {
      //print(response.body);
      return response;
    } else {
      return null;
    }
  }

  //----------categorias-------
  static Future<http.Response> categorias_get() async {
    final response = await http.get('${URLS.BASE_URL}/categories/', headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Authorization": '${globals.token}'
    });
    print(response.body);
    if (response.statusCode == 200) {
      print(response.body);
      return response;
    } else {
      return null;
    }
  }

  static Future<http.Response> products_by_categories(id) async {
    final response =
        await http.get('${URLS.BASE_URL}/prod_by_category/$id', headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
    });
    //print(response.body);
    if (response.statusCode == 200) {
      print(response.body);
      return response;
    } else {
      return null;
    }
  }

  //ShoppingCar
  static Future<bool> add_ShoppingCar(data) async {
    final response =
        await http.post('${URLS.BASE_URL}/add-to-sc/', body: data, headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Authorization": '${globals.token}'
    });
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  static Future<String> get_ShoppingCar() async {
    final response = await http.get('${URLS.BASE_URL}/prods-of-sc/', headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Authorization": '${globals.token}',
    });

    if (response.statusCode >= 200 && response.statusCode <= 204) {
      print(response.body);
      return response.body;
    } else {
      return null;
    }
  }

  static Future<bool> update_shoppingCar(data) async {
    final response = await http.put('${URLS.BASE_URL}/upt-to-sc/',
        body: data,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": '${globals.token}',
        });
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  static Future<String> pay_ShopingCar() async {
    final response = await http.get('${URLS.BASE_URL}/pay-sc/', headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Authorization": '${globals.token}',
    });

    if (response.statusCode >= 200 && response.statusCode <= 204) {
      return response.body;
    } else {
      return null;
    }
  }

    static Future<String> pay_id(String id) async {
      Map<String, String> data = {'pay_id': id};
    final response = await http.post('${URLS.BASE_URL}/paypalid/', headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Authorization": '${globals.token}',
    }, body: data,
    );

    if (response.statusCode >= 200 && response.statusCode <= 204) {
      return response.body;
    } else {
      return null;
    }
  }

  //Pays
  static Future<String> get_UsersPayment(id) async {
    final response = await http.get('${URLS.BASE_URL}/products_by_cars/$id',
    headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Authorization": '${globals.token}',
    });

    if (response.statusCode >= 200 && response.statusCode <= 204) {
      return response.body;
    } else {
      return null;
    }
  }

  static Future<String> get_AllPayment() async {
    final response = await http.post('${URLS.BASE_URL}/user-payments/',
    headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Authorization": '${globals.token}',
    });

    if (response.statusCode >= 200 && response.statusCode <= 204) {
      return response.body;
    } else {
      return null;
    }
  }

  //----------Ventas-------
  static Future<http.Response> get_Ventas() async {
    final response = await http.get('${URLS.BASE_URL}/all-payments/', headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Authorization":
      '${globals.token}'
    });
    print(response.body);
    if (response.statusCode == 200) {
      //print(response.body);
      return response;
    } else {
      return null;
    }
  }
}
