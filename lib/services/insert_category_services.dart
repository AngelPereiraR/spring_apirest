// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:requests/requests.dart';
import 'package:spring_apirest/services/services.dart';

class InsertCategoryServices extends ChangeNotifier {
  //Cambiar la IP por la conexión que tenga cada uno
  final String _baseUrl = '192.168.151.68:8080';

  InsertCategoryServices();

  postInsertCategory(int id, String name, String description) async {
    String? token = await LoginServices().readToken();
    var response = await Requests.post(
        "http://$_baseUrl/api/admin/categories/$id",
        body: {'id': id, 'name': name, 'description': description},
        headers: {'Authorization': 'Bearer $token'});

    var resp;
    final Map<String, dynamic> insertCategory = json.decode(response.body);
    if (insertCategory.containsKey("id")) {
      resp = 'OK';
    } else {
      String? error = '';

      error = 'ERROR TO INSERT CATEGORY. CHECK ATTRIBUTES';

      resp = error;
    }
    return resp;
  }
}
