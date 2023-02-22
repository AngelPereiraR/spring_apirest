// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:requests/requests.dart';
import 'package:spring_apirest/services/services.dart';
import 'package:spring_apirest/models/models.dart';

class GetCategoryAndProductsServices extends ChangeNotifier {
  //Cambiar la IP por la conexión que tenga cada uno
  final String _baseUrl = '192.168.113.68:8080';

  CategoryAndProducts? category;

  GetCategoryAndProductsServices();

  getCategoryAndProducts(int? id) async {
    String? token = await LoginServices().readToken();
    var response = await Requests.get(
        "http://$_baseUrl/api/user/categories/$id",
        headers: {'Authorization': 'Bearer $token'});

    int idCategory = 0;
    String nameCategory = "";
    String descriptionCategory = "";
    List<CategoryList> categoryList = [];

    int idProduct = 0;
    String name = "";
    String description = "";
    bool favorite = false;
    double price = 0;

    var resp;
    if (response.body.isNotEmpty) {
      final Map<String, dynamic> getProducts = json.decode(response.body);
      if (getProducts.containsKey("id")) {
        getProducts.forEach((key, value) {
          if (key == "id") {
            idCategory = value;
          } else if (key == "name") {
            nameCategory = value;
          } else if (key == "description") {
            descriptionCategory = value;
          } else if (key == "categoryId" && value.isNotEmpty) {
            for (int i = 0; i < value.length; i++) {
              value[i].forEach((key, value) {
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
                  categoryList.add(CategoryList(
                      id: idProduct,
                      name: name,
                      description: description,
                      favorite: favorite,
                      price: price));
                }
              });
              category = CategoryAndProducts(
                  id: idCategory,
                  name: nameCategory,
                  description: descriptionCategory,
                  category: categoryList);
            }
          }
        });
      } else {
        String? error = '';

        error = 'ERROR TO GET ATTRIBUTES. CHECK ID';

        resp = error;
      }

      resp = category;

      return resp;
    }
  }
}
