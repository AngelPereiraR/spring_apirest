// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:requests/requests.dart';
import 'package:spring_apirest/services/services.dart';

class UpdateCategoryServices extends ChangeNotifier {
  //Cambiar la IP por la conexión que tenga cada uno
  final String _baseUrl = '192.168.247.68:8080';

  UpdateCategoryServices();

  putUpdateCategory(int id, String name, String description) async {
    String? token = await LoginServices().readToken();
    var response = await Requests.put(
        "http://$_baseUrl/api/admin/categories/$id",
        body: {'id': id, 'name': name, 'description': description},
        headers: {'Authorization': 'Bearer $token'});

    var resp;
    final Map<String, dynamic> updateCategory = json.decode(response.body);
    if (updateCategory.containsKey("id")) {
      resp = 'OK';
    } else {
      String? error = '';

      error = 'ERROR TO UPDATE CATEGORY. CHECK ATTRIBUTES';

      resp = error;
    }
    return resp;
  }
}
