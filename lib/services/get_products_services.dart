// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:requests/requests.dart';
import 'package:spring_apirest/services/services.dart';
import 'package:spring_apirest/models/models.dart';

class GetProductsServices extends ChangeNotifier {
  //Cambiar la IP por la conexión que tenga cada uno
  final String _baseUrl = '192.168.247.68:8080';
  List<Product> products = [];

  GetProductsServices();

  getGetProducts(int id) async {
    String? token = await LoginServices().readToken();
    var response = await Requests.get(
        "http://$_baseUrl/api/user/categories/$id/products",
        headers: {'Authorization': 'Bearer $token'});

    int idProduct = 0;
    String name = "";
    String description = "";
    bool favorite = false;
    double price = 0;

    var resp;
    final Map<String, dynamic> getProducts = json.decode(response.body);
    if (getProducts.containsKey("id")) {
      getProducts.forEach((key, value) {
        if (key == "id") {
          idProduct = value;
        } else if (key == "name") {
          name = value;
        } else if (key == "description") {
          description = value;
        } else if (key == "favorite") {
          favorite = value;
        } else if (key == "price") {
          price = value;
          products.add(Product(
              id: idProduct,
              name: name,
              description: description,
              favorite: favorite,
              price: price));
        }
      });
      resp = products;
    } else {
      String? error = '';

      error = 'ERROR TO GET ATTRIBUTES. CHECK ID';

      resp = error;
    }
    return resp;
  }
}
