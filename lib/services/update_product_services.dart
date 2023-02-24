// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:requests/requests.dart';
import 'package:spring_apirest/services/services.dart';

class UpdateProductServices extends ChangeNotifier {
  //Cambiar la IP por la conexión que tenga cada uno
  final String _baseUrl = '192.168.164.68:8080';

  UpdateProductServices();

  putUpdateProduct(int? id, String name, String description,
      Map<String, dynamic>? category, double price) async {
    String? token = await LoginServices().readToken();
    var response = await Requests.put("http://$_baseUrl/api/admin/products/$id",
        body: {
          'id': id,
          'name': name,
          'description': description,
          'category': category,
          'price': price
        },
        headers: {'Authorization': 'Bearer $token'},
        bodyEncoding: RequestBodyEncoding.JSON);

    var resp;
    final Map<String, dynamic> updateProduct = json.decode(response.body);
    if (updateProduct.containsKey("id")) {
      resp = 'OK';
    } else {
      String? error = '';

      error = 'ERROR TO UPDATE PRODUCT. CHECK ATTRIBUTES';

      resp = error;
    }
    return resp;
  }
}
