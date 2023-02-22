// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:requests/requests.dart';
import 'package:spring_apirest/services/services.dart';
import 'package:spring_apirest/models/models.dart';

class InsertProductServices extends ChangeNotifier {
  //Cambiar la IP por la conexión que tenga cada uno
  final String _baseUrl = '192.168.247.68:8080';

  InsertProductServices();

  postInsertProduct(int id, String name, String description, Category category,
      double price, bool favorite) async {
    String? token = await LoginServices().readToken();
    var response =
        await Requests.post("http://$_baseUrl/api/admin/categories/$id/product",
            body: {
              'id': id,
              'name': name,
              'description': description,
              'category': category,
              'price': price,
              'favorite': favorite
            },
            headers: {'Authorization': 'Bearer $token'},
            bodyEncoding: RequestBodyEncoding.JSON);

    var resp;
    final Map<String, dynamic> insertProduct = json.decode(response.body);
    if (insertProduct.containsKey("id")) {
      resp = 'OK';
    } else {
      String? error = '';

      error = 'ERROR TO INSERT PRODUCT. CHECK ATTRIBUTES';

      resp = error;
    }
    return resp;
  }
}
