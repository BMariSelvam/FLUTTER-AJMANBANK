import 'dart:convert';
import 'package:http/http.dart' as http;
import 'encryprionChecking.dart';

class NetworkManager {
  static Future<dynamic> post(String url,
      {required Map<String, dynamic> body,
      required Map<String, String> headers}) async {

    final jsonString = json.encode(body);
    Map<String, dynamic> encrptedjson = {};
    print("==============url");
    print(url);
    print("==============body");
    print(body);
    print("==============headers");
    print(headers);
    // encryption
    if (body != {}) {
      String encodedString = EncrptionClass.getEncryptedString(jsonString);
       encrptedjson = {
        "channelId": "123",
        "lang": "ENUS",
        "encryptedMessage": encodedString
      };
    }
    print("============encrptedjson");
    print(encrptedjson);
    final response = await http.post(Uri.parse(url),
        body: json.encode(encrptedjson), headers: headers);
    if (response.statusCode == 200) {
      print(response.body);
      // decryption
       Map<dynamic, dynamic> data = json.decode(response.body);
       String decryptedString = DecrptionClass.getDecryptedString(data['encryptedMessage']);
      return json.decode(decryptedString);
    } else {
      throw Exception('Failed to perform POST request');
    }
  }

  static Future<dynamic> get(String url) async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      Map<String, dynamic> data = -json.decode(response.body);

      // decryption
      String decryptedString =
      DecrptionClass.getDecryptedString(data['encryptedMessage']);
      return json.decode(decryptedString);
    } else {
      throw Exception('Failed to perform GET request');
    }
  }

  static Future<dynamic> update(String url, Map<String, dynamic> body) async {
    final response = await http.put(Uri.parse(url), body: body);
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to perform UPDATE request');
    }
  }

  static Future<dynamic> delete(String url) async {
    final response = await http.delete(Uri.parse(url));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to perform DELETE request');
    }
  }
}
