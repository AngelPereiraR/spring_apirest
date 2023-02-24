// To parse this JSON data, do
//
//     final categoryAndProducts = categoryAndProductsFromMap(jsonString);

import 'dart:convert';

class CategoryAndProducts {
  CategoryAndProducts({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
  });

  int id;
  String name;
  String description;
  List<CategoryList> category;

  factory CategoryAndProducts.fromJson(String str) =>
      CategoryAndProducts.fromMap(json.decode(str));

  factory CategoryAndProducts.fromMap(Map<String, dynamic> json) =>
      CategoryAndProducts(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        category: List<CategoryList>.from(
            json["categoryId"].map((x) => CategoryList.fromMap(x))),
      );
}

class CategoryList {
  CategoryList({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
  });

  int id;
  String name;
  String description;
  double price;

  factory CategoryList.fromJson(String str) =>
      CategoryList.fromMap(json.decode(str));

  factory CategoryList.fromMap(Map<String, dynamic> json) => CategoryList(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        price: json["price"],
      );
}
