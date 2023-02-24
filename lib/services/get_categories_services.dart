// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:requests/requests.dart';
import 'package:spring_apirest/services/services.dart';
import 'package:spring_apirest/models/models.dart';

class GetCategoriesServices extends ChangeNotifier {
  //Cambiar la IP por la conexión que tenga cada uno
  final String _baseUrl = '192.168.164.68:8080';

  List<CategoryAndProducts> categories = [];

  bool isLoading = true;

  GetCategoriesServices();

  getCategories() async {
    categories.clear();
    String? token = await LoginServices().readToken();
    var response = await Requests.get("http://$_baseUrl/api/categories",
        headers: {'Authorization': 'Bearer $token'});

    isLoading = true;
    notifyListeners();

    int idCategory = 0;
    String nameCategory = "";
    String descriptionCategory = "";
    List<CategoryList> categoryList = [];

    int idProduct = 0;
    String name = "";
    String description = "";
    double price = 0;

    var resp;
    if (response.body.isNotEmpty) {
      final List<dynamic> categoriesResponse = json.decode(response.body);
      for (int i = 0; i < categoriesResponse.length; i++) {
        if (categoriesResponse[i].containsKey("id")) {
          categoriesResponse[i].forEach((key, value) {
            if (key == "id") {
              idCategory = value;
            } else if (key == "name") {
              nameCategory = value;
            } else if (key == "description") {
              descriptionCategory = value;
            } else if (key == "categoryId") {
              for (int j = 0; j < value.length; j++) {
                value[j].forEach((key, value) {
                  if (key == "id") {
                    idProduct = value;
                  } else if (key == "name") {
                    name = value;
                  } else if (key == "description") {
                    description = value;
                  } else if (key == "price") {
                    price = value;
                    categoryList.add(CategoryList(
                        id: idProduct,
                        name: name,
                        description: description,
                        price: price));
                  }
                });
              }
              CategoryAndProducts categoryAndProducts = CategoryAndProducts(
                  id: idCategory,
                  name: nameCategory,
                  description: descriptionCategory,
                  category: categoryList);

              categories.add(categoryAndProducts);
            }
          });
        } else {
          String? error = '';

          error = 'ERROR TO GET ATTRIBUTES. CHECK ID';

          resp = error;
        }
      }

      resp = categories;

      isLoading = false;
      notifyListeners();
      return resp;
    }

    isLoading = false;
    notifyListeners();
    return resp;
  }
}
