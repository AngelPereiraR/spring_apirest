import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class RegisterServices extends ChangeNotifier {
  //Cambiar la IP por la conexión que tenga cada uno
  final String _baseUrl = '192.168.136.68:8080';

  final storage = const FlutterSecureStorage();

  RegisterServices();

  postRegister(String username, String password, String role) async {
    final url = Uri.http(_baseUrl, '/register');
    final response = await http.post(url, body: {
      'username': username,
      'password': password,
      'role': role,
    });

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

      error = 'Error to register. The password is already taken';

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
