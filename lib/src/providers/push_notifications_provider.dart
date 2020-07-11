import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotificationProvider {
  final String serverToken = 'AAAAF0E3_8o:APA91bHe3vPBJ1c8S8yQPegvDuOoJPURX87YbwHNMC0PB1efuN5n-uUYIwQo39YD6RQ-baszcMIOlcFVATUKp2Tw9JhRsDJ8unfwet4G8oezoPcQyVAAtaK6yCvOKLjwCQD1y6VCe5O0';
  String fcmToken;
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  Future initialize() async {
    if (Platform.isIOS) {
      _firebaseMessaging.requestNotificationPermissions(IosNotificationSettings());
    }
    _firebaseMessaging.getToken().then((token) {
      print("====FCM TOKEN===");
      fcmToken = token;
      print(token);
      //c8pgKIpqwSE:APA91bGDQNQWvTwOdnoiSXwuzHqw2a8TFsO9N0Fx5g9ztmfEgGpqoXGnLNFtoTijqXsdDO11hmDnsGIublNUk5WBKSZ97-N03so8wWWrZjsgZtS1xFmZ_W2nWUzd2L-OVC69cvFtJPso
    });

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("====On Message=== $message");
      },
        // onBackgroundMessage: myBackgroundMessageHandler,
      onLaunch: (Map<String, dynamic> message) async {
        print("====On Launch=== $message");
      },
      
      onResume: (Map<String, dynamic> message) async {
        print("====On Resume=== $message");
      });
  }

  Future send()async{
    await http.post(
      'https://fcm.googleapis.com/fcm/send',
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=$serverToken',
      },
      body: jsonEncode(
        <String, dynamic>{
          'notification': <String, dynamic>{
            'body': 'this is a body',
            'title': 'this is a title'
          },
          'priority': 'high',
          'data': <String, dynamic>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'comida': 'frita',
            'status': 'en pedido'
          },
          'to': fcmToken,
        },
      ),
    );
  }
  

  // Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) {
  //   if (message.containsKey('data')) {
  //     // Handle data messagesssss
  //     final dynamic data = message['data'];
  //   }

  //   if (message.containsKey('notification')) {
  //     // Handle notification message
  //     final dynamic notification = message['notification'];
  //   }
  // }
}
