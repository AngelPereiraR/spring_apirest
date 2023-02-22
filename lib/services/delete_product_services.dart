// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:requests/requests.dart';
import 'package:spring_apirest/services/services.dart';

class DeleteProductServices extends ChangeNotifier {
  //Cambiar la IP por la conexión que tenga cada uno
  final String _baseUrl = '192.168.113.68:8080';

  DeleteProductServices();

  deleteDeleteProduct(int id) async {
    String? token = await LoginServices().readToken();
    Requests.delete("http://$_baseUrl/api/admin/products/$id",
        headers: {'Authorization': 'Bearer $token'});

    var resp = 'OK';
    return resp;
  }
}
