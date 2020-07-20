import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:login_app/src/encrypt.dart';
import 'package:login_app/src/extras/variables.dart' as globals;
import 'dart:convert';

class URLS {
  static const String BASE_URL = 'http://ec2-54-81-19-209.compute-1.amazonaws.com:8000';
}



class Api {
  static Future<bool> login(data) async {
    final response = await http.post('${URLS.BASE_URL}/login',
        body: data,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json"
        });
        print(response.statusCode);
        print(response.body);
    if (response.statusCode >=200 && response.statusCode <=204) {
      Map<String, dynamic> temp = jsonDecode(response.body);
      globals.token = temp['token'];
      get_UserByToken();

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
  static Future<http.Response> direccion_get(String bearer) async {
    final response = await http.get('${URLS.BASE_URL}/address/',
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiI0IiwianRpIjoiMmJhOTM4MjVmMzI2ZTRlN2JjMTBmNzViOThiNDE0OTNiNzA2OGRmMmRlYjA1NDczYTJkMTg5OTQ1ZGRkYWE5OWZjZTJlOTVmY2MyNjJjY2MiLCJpYXQiOjE1OTQ5NDU2ODMsIm5iZiI6MTU5NDk0NTY4MywiZXhwIjoxNjI2NDgxNjgzLCJzdWIiOiI1Iiwic2NvcGVzIjpbXX0.mvA8r16D2EGm7MoALZASlEaHzgLhFJ2XKDz-W8yPJ5RKkJYcCPLfhwefxoRuh-Bi43gXBIolxe22nrSADHelMG6UKxqMUhekV9sWkz3et3OjWzkWdIIGihRYgH5Gm9yQMmy7NPKb0u9lUZgiVhY1H7gASrt1FoApH-Oq8eWkByqCvCASTYln4YVL3k2VmAJTd6SckNK2sAsriCtVd99CzBE3gEmud0eSsKzsYOnTXeePb_fAi_goOuaCKIrFoEMcjOUYhVu-UAhdUVsRwdvpAYwK-90-B8kcxDRf9McuLZYrmGnFQ7oL8kXlCtqsDS30mz5vSviIIorNZ7xNcSyKjj8PLPfpuTzDvqB2WynAsqfyOP5gybFSW_FzVG6fRd3iUS3TvjMNUv1RQe4MDCD48IwhCjXUP4PRvuAhtZm_idJEsDMSNB8f4jPOKSdjZpEF5FTJ6DcHbtPNrt4ZWYUJBmkxc0LkZZmSesIJHQmsXyc0mJ494jRd8ZqKEzgrcSX4nAW_gKlNqhDFq-Iakam4CfO8G0M-HK3oG4swKScUjcizAuB8hE0uakLaXkk_3H0q-Wbhg4M9wu9bbmsYJrVgI01rL9360Y9PGwQrvgTUu8_Y0m5AjX_aeiktbcwrrIQ5yFLrGRY8TBCoLoQ71GCO4qLKNRvvY_OfEgelxWe4fG8 ",
        });
    print(response.body);
    if (response.statusCode == 200) {
      print(response.body);
      return response;
    } else {
      return null;
    }
  }

  static Future<http.Response> direccion_post(String bearer, data) async {
    final response = await http.post('${URLS.BASE_URL}/address',
        body: data,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiI0IiwianRpIjoiMmJhOTM4MjVmMzI2ZTRlN2JjMTBmNzViOThiNDE0OTNiNzA2OGRmMmRlYjA1NDczYTJkMTg5OTQ1ZGRkYWE5OWZjZTJlOTVmY2MyNjJjY2MiLCJpYXQiOjE1OTQ5NDU2ODMsIm5iZiI6MTU5NDk0NTY4MywiZXhwIjoxNjI2NDgxNjgzLCJzdWIiOiI1Iiwic2NvcGVzIjpbXX0.mvA8r16D2EGm7MoALZASlEaHzgLhFJ2XKDz-W8yPJ5RKkJYcCPLfhwefxoRuh-Bi43gXBIolxe22nrSADHelMG6UKxqMUhekV9sWkz3et3OjWzkWdIIGihRYgH5Gm9yQMmy7NPKb0u9lUZgiVhY1H7gASrt1FoApH-Oq8eWkByqCvCASTYln4YVL3k2VmAJTd6SckNK2sAsriCtVd99CzBE3gEmud0eSsKzsYOnTXeePb_fAi_goOuaCKIrFoEMcjOUYhVu-UAhdUVsRwdvpAYwK-90-B8kcxDRf9McuLZYrmGnFQ7oL8kXlCtqsDS30mz5vSviIIorNZ7xNcSyKjj8PLPfpuTzDvqB2WynAsqfyOP5gybFSW_FzVG6fRd3iUS3TvjMNUv1RQe4MDCD48IwhCjXUP4PRvuAhtZm_idJEsDMSNB8f4jPOKSdjZpEF5FTJ6DcHbtPNrt4ZWYUJBmkxc0LkZZmSesIJHQmsXyc0mJ494jRd8ZqKEzgrcSX4nAW_gKlNqhDFq-Iakam4CfO8G0M-HK3oG4swKScUjcizAuB8hE0uakLaXkk_3H0q-Wbhg4M9wu9bbmsYJrVgI01rL9360Y9PGwQrvgTUu8_Y0m5AjX_aeiktbcwrrIQ5yFLrGRY8TBCoLoQ71GCO4qLKNRvvY_OfEgelxWe4fG8 ",
        });
    print(response.body);
    if (response.statusCode == 201) {
      return response;
    } else {
      return null;
    }
  }

  static Future<http.Response> direccion_put(id, data) async {
    final response = await http.put('${URLS.BASE_URL}/address/$id',
        body: data,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiI0IiwianRpIjoiMmJhOTM4MjVmMzI2ZTRlN2JjMTBmNzViOThiNDE0OTNiNzA2OGRmMmRlYjA1NDczYTJkMTg5OTQ1ZGRkYWE5OWZjZTJlOTVmY2MyNjJjY2MiLCJpYXQiOjE1OTQ5NDU2ODMsIm5iZiI6MTU5NDk0NTY4MywiZXhwIjoxNjI2NDgxNjgzLCJzdWIiOiI1Iiwic2NvcGVzIjpbXX0.mvA8r16D2EGm7MoALZASlEaHzgLhFJ2XKDz-W8yPJ5RKkJYcCPLfhwefxoRuh-Bi43gXBIolxe22nrSADHelMG6UKxqMUhekV9sWkz3et3OjWzkWdIIGihRYgH5Gm9yQMmy7NPKb0u9lUZgiVhY1H7gASrt1FoApH-Oq8eWkByqCvCASTYln4YVL3k2VmAJTd6SckNK2sAsriCtVd99CzBE3gEmud0eSsKzsYOnTXeePb_fAi_goOuaCKIrFoEMcjOUYhVu-UAhdUVsRwdvpAYwK-90-B8kcxDRf9McuLZYrmGnFQ7oL8kXlCtqsDS30mz5vSviIIorNZ7xNcSyKjj8PLPfpuTzDvqB2WynAsqfyOP5gybFSW_FzVG6fRd3iUS3TvjMNUv1RQe4MDCD48IwhCjXUP4PRvuAhtZm_idJEsDMSNB8f4jPOKSdjZpEF5FTJ6DcHbtPNrt4ZWYUJBmkxc0LkZZmSesIJHQmsXyc0mJ494jRd8ZqKEzgrcSX4nAW_gKlNqhDFq-Iakam4CfO8G0M-HK3oG4swKScUjcizAuB8hE0uakLaXkk_3H0q-Wbhg4M9wu9bbmsYJrVgI01rL9360Y9PGwQrvgTUu8_Y0m5AjX_aeiktbcwrrIQ5yFLrGRY8TBCoLoQ71GCO4qLKNRvvY_OfEgelxWe4fG8 "
        });
    print(response.body);
    if (response.statusCode == 200) {
      return response;
    } else {
      return null;
    }
  }

  static Future<http.Response> direccion_delete(int id) async {
    final response = await http.delete('${URLS.BASE_URL}/address/$id',
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiI0IiwianRpIjoiMmJhOTM4MjVmMzI2ZTRlN2JjMTBmNzViOThiNDE0OTNiNzA2OGRmMmRlYjA1NDczYTJkMTg5OTQ1ZGRkYWE5OWZjZTJlOTVmY2MyNjJjY2MiLCJpYXQiOjE1OTQ5NDU2ODMsIm5iZiI6MTU5NDk0NTY4MywiZXhwIjoxNjI2NDgxNjgzLCJzdWIiOiI1Iiwic2NvcGVzIjpbXX0.mvA8r16D2EGm7MoALZASlEaHzgLhFJ2XKDz-W8yPJ5RKkJYcCPLfhwefxoRuh-Bi43gXBIolxe22nrSADHelMG6UKxqMUhekV9sWkz3et3OjWzkWdIIGihRYgH5Gm9yQMmy7NPKb0u9lUZgiVhY1H7gASrt1FoApH-Oq8eWkByqCvCASTYln4YVL3k2VmAJTd6SckNK2sAsriCtVd99CzBE3gEmud0eSsKzsYOnTXeePb_fAi_goOuaCKIrFoEMcjOUYhVu-UAhdUVsRwdvpAYwK-90-B8kcxDRf9McuLZYrmGnFQ7oL8kXlCtqsDS30mz5vSviIIorNZ7xNcSyKjj8PLPfpuTzDvqB2WynAsqfyOP5gybFSW_FzVG6fRd3iUS3TvjMNUv1RQe4MDCD48IwhCjXUP4PRvuAhtZm_idJEsDMSNB8f4jPOKSdjZpEF5FTJ6DcHbtPNrt4ZWYUJBmkxc0LkZZmSesIJHQmsXyc0mJ494jRd8ZqKEzgrcSX4nAW_gKlNqhDFq-Iakam4CfO8G0M-HK3oG4swKScUjcizAuB8hE0uakLaXkk_3H0q-Wbhg4M9wu9bbmsYJrVgI01rL9360Y9PGwQrvgTUu8_Y0m5AjX_aeiktbcwrrIQ5yFLrGRY8TBCoLoQ71GCO4qLKNRvvY_OfEgelxWe4fG8 "
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
  
    if (response.statusCode >=200 && response.statusCode <=204) {
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
    if (response.statusCode >=200 && response.statusCode <=204) {
      return true;
    } else {
      return false;
    }
  }

    // ignore: non_constant_identifier_names
    static Future<String> product_getBySlug(slug) async {
      print(slug);
    final response = await http.get('${URLS.BASE_URL}/products/$slug');
    if (response.statusCode >=200 && response.statusCode <=204) {
      return response.body;
    } else {
      return '';
    }
  }

    // ignore: non_constant_identifier_names
    static Future<bool> product_update(data,id) async {
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
    static Future<String> get_userInfoById(data,id) async {
      print(data);
    final response = await http.post('${URLS.BASE_URL}/products/$id',
        body: data,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json"
        });
    if (response.statusCode >=200 && response.statusCode <=204) {
      return response.body;
    } else {
      return '';
    }
  }

     // ignore: non_constant_identifier_names
    static Future<String> get_UserByToken() async {
    final response = await http.get('${URLS.BASE_URL}/auth_user',
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": 'Bearer ${globals.token}'
        });
        print(response.body);
      Map<String, dynamic> temp = jsonDecode(response.body);
      globals.rolId = temp['rol_id'];
    if (response.statusCode >=200 && response.statusCode <=204) {
      return response.body;
    } else {
      return '';
    }
  }
  
}
