import 'package:http/http.dart' as http;


class URLS{
  static const String BASE_URL = 'https://reqres.in/api';
}

class Api {
  static Future<bool> login(data) async {
    final response = await http.post('${URLS.BASE_URL}/login', body: data,headers: {
  "Content-Type": "application/json",
  "Accept": "application/json"
});
    print(data);
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200){
      return true;
    }else{
      return false;
    }

  }
}