// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:requests/requests.dart';
import 'package:spring_apirest/services/services.dart';

class DeleteProductsOfCategoryServices extends ChangeNotifier {
  //Cambiar la IP por la conexión que tenga cada uno
  final String _baseUrl = '192.168.247.68:8080';

  DeleteProductsOfCategoryServices();

  deleteDeleteProductsOfCategory(int id) async {
    String? token = await LoginServices().readToken();
    Requests.delete("http://$_baseUrl/api/admin/categories/$id/products",
        headers: {'Authorization': 'Bearer $token'});

    var resp = 'OK';
    return resp;
  }
}
