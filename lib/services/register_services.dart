import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:requests/requests.dart';

class RegisterServices extends ChangeNotifier {
  //Cambiar la IP por la conexión que tenga cada uno
  final String _baseUrl = '192.168.113.68:8080';

  final storage = const FlutterSecureStorage();

  RegisterServices();

  postRegister(String username, String password, String role) async {
    var response = await Requests.post("http://$_baseUrl/register",
        body: {'username': username, 'password': password, 'role': role},
        bodyEncoding: RequestBodyEncoding.JSON);

    String resp = '';
    final Map<String, dynamic> register = json.decode(response.body);
    if (register.containsValue(true)) {
      register.forEach((key, value) {
        if (key == "token") {
          storage.write(key: 'token', value: value);
        }
        if (key == "id") {
          storage.write(key: 'id', value: value.toString());
        }
      });
    } else {
      String? error = '';

      error = 'Error to register. The username is already taken';

      resp = error;
    }
    return resp;
  }

  Future logout() async {
    await storage.delete(key: 'token');
    await storage.delete(key: 'id');
    return;
  }

  Future<String> readToken() async {
    return await storage.read(key: 'token') ?? '';
  }

  Future<String> readId() async {
    return await storage.read(key: 'id') ?? '';
  }
}
