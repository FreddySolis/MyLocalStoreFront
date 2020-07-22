import 'package:http/http.dart' as http;
import 'package:login_app/src/encrypt.dart';
import 'package:login_app/src/extras/variables.dart' as globals;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class URLS {
  static const String BASE_URL =
      'http://ec2-54-81-19-209.compute-1.amazonaws.com:8000';
}

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
      globals.token = 'Bearer ' +  temp['token'];
      get_UserByToken();
      final prefs = await SharedPreferences.getInstance();

      prefs.setString('token',globals.token);

      return true;
    } else {
      return false;
    }
  }

    static Future<bool> logOut() async {
    final response = await http.post('${URLS.BASE_URL}/logout',
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": globals.token
        });
    if (response.statusCode >= 200 && response.statusCode <= 204) {
      final prefs = await SharedPreferences.getInstance();

      prefs.remove('token');


      return true;
    } else {
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
    print(desEnc(response.body));
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

//------------- Direccion ---------
  static Future<http.Response> direccion_get() async {
    final response = await http.get('${URLS.BASE_URL}/address/', headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Authorization":
      '${globals.token}'
    });
    print(response.body);
    if (response.statusCode == 200) {
      print(response.body);
      return response;
    } else {
      return null;
    }
  }

  static Future<http.Response> direccion_post(data) async {
    final response =
        await http.post('${URLS.BASE_URL}/address', body: data, headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
          "Authorization":
          '${globals.token}'
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
          "Authorization":
          '${globals.token}'
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
          "Authorization":
          '${globals.token}'
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
          "Accept": "application/json"
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
          "Accept": "application/json"
        });
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  //----------users-------
  // ignore: non_constant_identifier_names
  static Future<String> get_userInfoById(data, id) async {
    print(data);
    final response = await http.post('${URLS.BASE_URL}/products/$id',
        body: data,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json"
        });
    if (response.statusCode >= 200 && response.statusCode <= 204) {
      return response.body;
    } else {
      return '';
    }
  }

  // ignore: non_constant_identifier_names
  static Future<String> get_UserByToken() async {
        print('test');
        print(globals.token);
        
    final response = await http.get('${URLS.BASE_URL}/auth_user', headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Authorization": '${globals.token}'
    });
    print(response.body);
    Map<String, dynamic> temp = jsonDecode(response.body);
    globals.rolId = temp['rol_id'];
    if (response.statusCode >= 200 && response.statusCode <= 204) {
      return response.body;
    } else {
      return '';
    }
  }

  //----------categorias-------
  static Future<http.Response> categorias_get(String categories) async {
    final response = await http.get('${URLS.BASE_URL}/categories/', headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Authorization":
      '${globals.token}'
    });
    print(response.body);
    if (response.statusCode == 200) {
      print(response.body);
      return response;
    } else {
      return null;
    }
  }
}
