import 'package:http/http.dart' as http;
import 'package:login_app/src/encrypt.dart';
class URLS {
  static const String BASE_URL = 'https://reqres.in/api';
}



class Api {
  static Future<bool> login(data) async {

    final response = await http.post('${URLS.BASE_URL}/login',
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

  static Future<bool> registro(data) async {
    String encData = enc(data);
    final response = await http.post('${URLS.BASE_URL}/register',
        body: encData,
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
}
