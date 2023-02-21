// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:requests/requests.dart';
import 'package:spring_apirest/services/services.dart';
import 'package:spring_apirest/models/models.dart';

class GetFavoritesServices extends ChangeNotifier {
  //Cambiar la IP por la conexión que tenga cada uno
  final String _baseUrl = '192.168.247.68:8080';
  List<Product> products = [];

  GetFavoritesServices();

  getGetFavorites() async {
    String? token = await LoginServices().readToken();
    var response = await Requests.get(
        "http://$_baseUrl/api/user/products/favorite",
        headers: {'Authorization': 'Bearer $token'});

    int idProduct = 0;
    String name = "";
    String description = "";
    bool favorite = false;
    double price = 0;

    var resp;
    final List<dynamic> productsResponse = json.decode(response.body);
    for (int i = 0; i < productsResponse.length; i++) {
      if (productsResponse[i].containsKey("id")) {
        productsResponse[i].forEach((key, value) {
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
}
