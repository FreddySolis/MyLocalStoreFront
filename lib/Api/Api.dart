import 'package:http/http.dart' as http;
import 'package:login_app/src/encrypt.dart';
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
    if (response.statusCode == 200) {
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
}
