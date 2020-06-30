import 'package:encrypt/encrypt.dart';

String enc(String text) {
  final plainText = text;
  final key = Key.fromUtf8('xxxSecretKey1xxxxxxSecretKey1xxx');
  final iv = IV.fromLength(16);

  final encrypter = Encrypter(
        AES(key, mode: AESMode.cbc, padding: "PKCS7"));

  final encrypted = encrypter.encrypt(plainText, iv: iv);
  //final decrypted = encrypter.decrypt(encrypted, iv: iv);

  //print(decrypted); // Lorem ipsum dolor sit amet, consectetur adipiscing elit
  print(encrypted
      .base64); // R4PxiU3h8YoIRqVowBXm36ZcCeNeZ4s1OvVBTfFlZRdmohQqOpPQqD1YecJeZMAop/hZ4OxqgC1WtwvX/hP9mw==

  return encrypted.base64;
}


String desEnc(String text) {
  String temp = 'pzDmh3V0QE5F8Va1ANDk8uuZl1sFV97XmgU/5UU42yY7Y1jgb7jxzlFi+ow/hJKV/emYd1NUskLDCZkJ1/1BUA==';
  final Encrypted encText = Encrypted.from64(temp);
  final key = Key.fromUtf8('xxxSecretKey1xxxxxxSecretKey1xxx');
  final iv = IV.fromLength(16);

  final encrypter = Encrypter(
        AES(key, mode: AESMode.cbc, padding: "PKCS7"));

  final decrypted = encrypter.decrypt(encText, iv: iv);

  print(decrypted);

  return decrypted;
}